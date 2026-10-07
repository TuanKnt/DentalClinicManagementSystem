package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.model.Patient;
import com.dcms.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * GuestBookingServlet handles online appointment booking by unauthenticated Guests (public visitors).
 * UC00_04: Book Online Appointment (Guest Booking)
 */
@WebServlet(name = "GuestBookingServlet", urlPatterns = {"/booking", "/public/booking"})
public class GuestBookingServlet extends HttpServlet {

    private final AppointmentService appointmentService;
    private final PatientDAO patientDAO;
    private final DentistDAO dentistDAO;

    public GuestBookingServlet() {
        this.appointmentService = new AppointmentService();
        this.patientDAO = new PatientDAO();
        this.dentistDAO = new DentistDAO();
    }

    public GuestBookingServlet(AppointmentService appointmentService, PatientDAO patientDAO, DentistDAO dentistDAO) {
        this.appointmentService = appointmentService;
        this.patientDAO = patientDAO;
        this.dentistDAO = dentistDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Dentist> dentists = dentistDAO.listAllDentists();
        request.setAttribute("dentists", dentists);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "json".equalsIgnoreCase(request.getParameter("format"));

        try {
            String fullName = request.getParameter("fullName");
            // The public form uses phoneNumber while older clients/tests still send phone.
            // Accept both names so a valid booking cannot be rejected simply because the
            // browser is using the current field name.
            String phone = request.getParameter("phoneNumber");
            if (phone == null || phone.trim().isEmpty()) {
                phone = request.getParameter("phone");
            }
            String email = request.getParameter("email");
            String dentistIdParam = request.getParameter("dentistId");
            String dateParam = request.getParameter("appointmentDate");
            String timeSlotParam = request.getParameter("timeSlot");
            String reason = request.getParameter("reason");
            String notes = request.getParameter("notes");

            // 1. Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                throw new IllegalArgumentException("Họ và tên không được để trống");
            }
            if (phone == null || !phone.trim().matches("^0[35789][0-9]{8}$")) {
                throw new IllegalArgumentException("Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09");
            }
            if (dateParam == null || dateParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn ngày khám");
            }

            LocalDate appointmentDate;
            try {
                appointmentDate = LocalDate.parse(dateParam.trim());
            } catch (DateTimeParseException ex) {
                throw new IllegalArgumentException("Định dạng ngày hẹn không hợp lệ (YYYY-MM-DD)");
            }

            if (appointmentDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Không thể đặt lịch hẹn trong quá khứ");
            }

            // 2. Parse time slot (e.g. "09:00 - 09:45" or "09:00").
            // The public options represent 45-minute consultation slots.
            LocalTime startTime;
            LocalTime endTime;
            if (timeSlotParam == null || timeSlotParam.trim().isEmpty()) {
                startTime = LocalTime.of(9, 0);
                endTime = LocalTime.of(9, 45);
            } else {
                String slot = timeSlotParam.trim();
                if (slot.contains("-")) {
                    String[] parts = slot.split("-");
                    if (parts.length != 2) {
                        throw new IllegalArgumentException("Khung giờ hẹn không hợp lệ");
                    }
                    startTime = LocalTime.parse(parts[0].trim());
                    endTime = LocalTime.parse(parts[1].trim());
                } else {
                    startTime = LocalTime.parse(slot);
                    endTime = startTime.plusMinutes(45);
                }
            }

            // 3. Find or register Patient
            Patient patient = patientDAO.findByPhone(phone.trim());
            int patientId;
            if (patient == null) {
                Patient newPatient = new Patient();
                newPatient.setFullName(fullName.trim());
                newPatient.setPhone(phone.trim());
                // Gender is NOT NULL in the baseline schema. Guests do not provide
                // demographic details, so keep the record valid with the neutral value.
                newPatient.setGender("Khác");
                if (email != null && !email.trim().isEmpty()) {
                    newPatient.setEmergencyContact("Email: " + email.trim());
                }
                patientId = patientDAO.create(newPatient);
                if (patientId <= 0) {
                    throw new RuntimeException("Lỗi hệ thống: Không thể tạo hồ sơ tiếp nhận bệnh nhân");
                }
            } else {
                patientId = patient.getPatientId();
            }

            // 4. Resolve Dentist
            int dentistId = 0;
            if (dentistIdParam != null && !dentistIdParam.trim().isEmpty()) {
                try {
                    dentistId = Integer.parseInt(dentistIdParam.trim());
                } catch (NumberFormatException ignored) {}
            }
            if (dentistId <= 0) {
                List<Dentist> dentists = dentistDAO.listAllDentists();
                if (dentists != null && !dentists.isEmpty()) {
                    dentistId = dentists.get(0).getDentistId();
                } else {
                    throw new IllegalStateException("Hiện không có bác sĩ nào sẵn sàng tiếp nhận lịch hẹn");
                }
            }

            // 5. Build and book Appointment
            Appointment appt = new Appointment();
            appt.setPatientId(patientId);
            appt.setDentistId(dentistId);
            appt.setAppointmentDate(appointmentDate);
            appt.setStartTime(startTime);
            appt.setEndTime(endTime);
            appt.setReason((reason != null && !reason.trim().isEmpty()) ? reason.trim() : "Khám răng định kỳ");
            appt.setNotes("Khách vãng lai đặt Online qua Website. SĐT: " + phone.trim()
                    + (email != null && !email.trim().isEmpty() ? " | Email: " + email.trim() : "")
                    + (notes != null && !notes.trim().isEmpty() ? " | Yêu cầu: " + notes.trim() : ""));
            appt.setStatus(Appointment.STATUS_PENDING);

            Appointment booked = appointmentService.bookAppointment(appt);

            // 6. Return response
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(String.format(
                        "{\"success\": true, \"appointmentId\": %d, \"patientName\": \"%s\", \"message\": \"Đặt lịch thành công! Mã hẹn của bạn là #%d. Lễ tân DCMS sẽ gọi điện xác nhận trong ít phút.\"}",
                        booked.getAppointmentId(),
                        escapeJson(fullName.trim()),
                        booked.getAppointmentId()
                ));
            } else {
                response.sendRedirect(request.getContextPath() + "/?bookingSuccess=1&apptId=" + booked.getAppointmentId() + "#booking");
            }

        } catch (Exception ex) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(String.format(
                        "{\"success\": false, \"message\": \"%s\"}",
                        escapeJson(ex.getMessage() != null ? ex.getMessage() : "Lỗi không xác định")
                ));
            } else {
                String errorMsg = URLEncoder.encode(ex.getMessage() != null ? ex.getMessage() : "Lỗi đặt lịch hẹn", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/?bookingError=" + errorMsg + "#booking");
            }
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}

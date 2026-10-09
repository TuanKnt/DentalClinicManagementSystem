package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Patient;
import com.dcms.model.TreatmentPlan;
import com.dcms.model.User;
import com.dcms.service.AppointmentService;
import com.dcms.service.TreatmentPlanService;
import com.dcms.service.exception.AppointmentConflictException;
import com.dcms.service.exception.DentistNotAvailableException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller handling Treatment Plan Patient Acceptance & Informed Consent (UC22).
 * Managed by Thai (Appointment & Consent Module).
 */
@WebServlet(name = "TreatmentConsentServlet", urlPatterns = {
        "/treatment/consent",
        "/treatment/consent/print"
})
public class TreatmentConsentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TreatmentConsentServlet.class.getName());

    private final TreatmentPlanService planService;
    private final AppointmentService appointmentService;
    private final PatientDAO patientDAO;
    private final DentistDAO dentistDAO;

    public TreatmentConsentServlet() {
        this.planService = new TreatmentPlanService();
        this.appointmentService = new AppointmentService();
        this.patientDAO = new PatientDAO();
        this.dentistDAO = new DentistDAO();
    }

    public TreatmentConsentServlet(TreatmentPlanService planService, AppointmentService appointmentService,
                                   PatientDAO patientDAO, DentistDAO dentistDAO) {
        this.planService = planService;
        this.appointmentService = appointmentService;
        this.patientDAO = patientDAO;
        this.dentistDAO = dentistDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/treatment/consent/print".equalsIgnoreCase(path)) {
            showConsentPrint(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/treatment/plans");
    }

    private void showConsentPrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                    URLEncoder.encode("Thiếu mã kế hoạch điều trị.", StandardCharsets.UTF_8));
            return;
        }

        try {
            int planId = Integer.parseInt(idParam.trim());
            TreatmentPlan plan = planService.getPlanDetails(planId);
            if (plan == null) {
                response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                        URLEncoder.encode("Không tìm thấy kế hoạch điều trị #" + planId, StandardCharsets.UTF_8));
                return;
            }

            Patient patient = patientDAO.findById(plan.getPatientId());
            request.setAttribute("plan", plan);
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/WEB-INF/views/treatment/consent-print.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                    URLEncoder.encode("Mã kế hoạch không hợp lệ.", StandardCharsets.UTF_8));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String planIdParam = request.getParameter("planId");
        String consentType = request.getParameter("consentType");
        String consentNotes = request.getParameter("consentNotes");

        if (planIdParam == null || planIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                    URLEncoder.encode("Thiếu thông tin kế hoạch điều trị.", StandardCharsets.UTF_8));
            return;
        }

        try {
            int planId = Integer.parseInt(planIdParam.trim());
            TreatmentPlan plan = planService.getPlanDetails(planId);
            if (plan == null) {
                response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                        URLEncoder.encode("Kế hoạch điều trị không tồn tại.", StandardCharsets.UTF_8));
                return;
            }

            // 1. Record Patient Consent
            planService.recordPatientConsent(planId, consentType, consentNotes, LocalDateTime.now());

            // 2. Optional Next Session Appointment Scheduling
            String scheduleNext = request.getParameter("scheduleNext");
            String nextDateStr = request.getParameter("nextAppointmentDate");
            String nextTimeStr = request.getParameter("nextAppointmentTime");

            if ("on".equalsIgnoreCase(scheduleNext) || "true".equalsIgnoreCase(scheduleNext)) {
                if (nextDateStr != null && !nextDateStr.trim().isEmpty() &&
                    nextTimeStr != null && !nextTimeStr.trim().isEmpty()) {
                    try {
                        LocalDate apptDate = LocalDate.parse(nextDateStr.trim());
                        LocalTime startTime = LocalTime.parse(nextTimeStr.trim());
                        LocalTime endTime = startTime.plusMinutes(45); // Standard 45m dental session

                        Appointment appt = new Appointment();
                        appt.setPatientId(plan.getPatientId());
                        appt.setDentistId(plan.getDentistId());
                        appt.setAppointmentDate(apptDate);
                        appt.setStartTime(startTime);
                        appt.setEndTime(endTime);
                        appt.setStatus("Scheduled");
                        appt.setNotes("Lịch hẹn điều trị theo phác đồ #" + plan.getPlanId() + ": " + plan.getTitle());

                        appointmentService.bookAppointment(appt);
                        LOGGER.info("Successfully scheduled next treatment appointment for patient: " + plan.getPatientId());
                    } catch (DateTimeParseException dtEx) {
                        LOGGER.log(Level.WARNING, "Invalid date/time format for next appointment: " + nextDateStr + " " + nextTimeStr, dtEx);
                    } catch (DentistNotAvailableException | AppointmentConflictException schedEx) {
                        LOGGER.log(Level.WARNING, "Could not auto-schedule next appointment: " + schedEx.getMessage());
                        // Notice user but don't cancel consent
                        String redirectUrl = request.getContextPath() + "/treatment/plans/detail?id=" + planId +
                                "&msg=consent_recorded&warn=" + URLEncoder.encode("Cam kết đã lưu thành công, nhưng xếp lịch hẹn tiếp theo chưa hoàn tất: " + schedEx.getMessage(), StandardCharsets.UTF_8);
                        response.sendRedirect(redirectUrl);
                        return;
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/treatment/plans/detail?id=" + planId + "&msg=consent_recorded");
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/treatment/plans?error=" +
                    URLEncoder.encode("Mã kế hoạch không hợp lệ.", StandardCharsets.UTF_8));
        } catch (IllegalArgumentException | IllegalStateException ex) {
            response.sendRedirect(request.getContextPath() + "/treatment/plans/detail?id=" + planIdParam +
                    "&error=" + URLEncoder.encode(ex.getMessage(), StandardCharsets.UTF_8));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error recording patient consent", ex);
            response.sendRedirect(request.getContextPath() + "/treatment/plans/detail?id=" + planIdParam +
                    "&error=" + URLEncoder.encode("Lỗi hệ thống khi ghi nhận cam kết.", StandardCharsets.UTF_8));
        }
    }
}

package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.model.Patient;
import com.dcms.service.AppointmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * AppointmentServlet handles appointment scheduling, cancellation and daily schedule view.
 */
@WebServlet(name = "AppointmentServlet", urlPatterns = {
        "/reception/appointments",
        "/reception/appointments/create",
        "/reception/appointments/cancel",
        "/reception/appointments/confirm"
})
public class AppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private DentistDAO dentistDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.appointmentService = new AppointmentService();
        this.dentistDAO = new DentistDAO();
        this.patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/reception/appointments/create".equals(servletPath)) {
            showCreateForm(request, response);
            return;
        }

        // Default: list appointments for selected date and dentist
        showList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String servletPath = request.getServletPath();

        if ("/reception/appointments/cancel".equals(servletPath)) {
            handleCancel(request, response);
            return;
        }

        if ("/reception/appointments/confirm".equals(servletPath)) {
            handleConfirm(request, response);
            return;
        }

        handleCreate(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dateParam = request.getParameter("date");
        String dentistParam = request.getParameter("dentistId");

        LocalDate selectedDate = LocalDate.now();
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam.trim());
            } catch (DateTimeParseException ignored) {}
        }

        Integer dentistId = null;
        if (dentistParam != null && !dentistParam.trim().isEmpty()) {
            try {
                dentistId = Integer.parseInt(dentistParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Appointment> list = appointmentService.getAppointmentsForDate(selectedDate, dentistId);
        List<Dentist> dentists = dentistDAO.listAllDentists();

        request.setAttribute("appointmentList", list);
        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("selectedDentistId", dentistId);
        request.setAttribute("dentists", dentists);

        request.getRequestDispatcher("/WEB-INF/views/receptionist/appointment-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Dentist> dentists = dentistDAO.listAllDentists();
        request.setAttribute("dentists", dentists);

        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam.trim());
                Patient patient = patientDAO.findById(patientId);
                request.setAttribute("selectedPatient", patient);
            } catch (NumberFormatException ignored) {}
        }

        request.getRequestDispatcher("/WEB-INF/views/receptionist/appointment-form.jsp").forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Appointment appt = new Appointment();
        try {
            appt.setPatientId(Integer.parseInt(request.getParameter("patientId")));
            appt.setDentistId(Integer.parseInt(request.getParameter("dentistId")));
            appt.setAppointmentDate(LocalDate.parse(request.getParameter("appointmentDate")));
            appt.setStartTime(LocalTime.parse(request.getParameter("startTime")));
            appt.setEndTime(LocalTime.parse(request.getParameter("endTime")));
            appt.setReason(request.getParameter("reason"));
            appt.setNotes(request.getParameter("notes"));

            appointmentService.bookAppointment(appt);
            response.sendRedirect(request.getContextPath() + "/reception/appointments?date=" + appt.getAppointmentDate() + "&success=booked");
        } catch (Exception ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("appt", appt);
            showCreateForm(request, response);
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("appointmentId");
        String reason = request.getParameter("reason");
        String returnDate = request.getParameter("returnDate");

        try {
            int appointmentId = Integer.parseInt(idParam);
            appointmentService.cancelAppointment(appointmentId, reason);
            response.sendRedirect(request.getContextPath() + "/reception/appointments?date=" + returnDate + "&success=cancelled");
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/reception/appointments?date=" + returnDate + "&error=" + ex.getMessage());
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("appointmentId");
        String returnDate = request.getParameter("returnDate");

        try {
            int appointmentId = Integer.parseInt(idParam);
            appointmentService.confirmAppointment(appointmentId);
            response.sendRedirect(request.getContextPath() + "/reception/appointments?date=" + returnDate + "&success=confirmed");
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/reception/appointments?date=" + returnDate + "&error=" + ex.getMessage());
        }
    }
}

package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Visual Appointment Calendar servlet supporting week and day views,
 * dentist filtering, and quick appointment inspection.
 */
@WebServlet(name = "AppointmentCalendarServlet", urlPatterns = {"/reception/calendar"})
public class AppointmentCalendarServlet extends HttpServlet {

    private final AppointmentService appointmentService;
    private final DentistDAO dentistDAO;

    public AppointmentCalendarServlet() {
        this.appointmentService = new AppointmentService();
        this.dentistDAO = new DentistDAO();
    }

    public AppointmentCalendarServlet(AppointmentService appointmentService, DentistDAO dentistDAO) {
        this.appointmentService = appointmentService;
        this.dentistDAO = dentistDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dateParam = request.getParameter("date");
        LocalDate targetDate;
        try {
            targetDate = (dateParam != null && !dateParam.trim().isEmpty())
                    ? LocalDate.parse(dateParam.trim())
                    : LocalDate.now();
        } catch (DateTimeParseException e) {
            targetDate = LocalDate.now();
        }

        String dentistParam = request.getParameter("dentistId");
        Integer dentistId = null;
        if (dentistParam != null && !dentistParam.trim().isEmpty()) {
            try {
                dentistId = Integer.parseInt(dentistParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        String viewMode = request.getParameter("view");
        if (viewMode == null || (!"day".equals(viewMode) && !"week".equals(viewMode))) {
            viewMode = "week";
        }

        // Calculate Monday of current week
        LocalDate startOfWeek = targetDate.with(DayOfWeek.MONDAY);
        LocalDate endOfWeek = targetDate.with(DayOfWeek.SUNDAY);

        // Populate weekly grid map (Date -> List<Appointment>)
        Map<LocalDate, List<Appointment>> weekSchedule = new LinkedHashMap<>();
        int totalWeekAppointments = 0;
        for (int i = 0; i < 7; i++) {
            LocalDate d = startOfWeek.plusDays(i);
            List<Appointment> appts = appointmentService.getAppointmentsForDate(d, dentistId);
            if (appts == null) {
                appts = new ArrayList<>();
            }
            weekSchedule.put(d, appts);
            totalWeekAppointments += appts.size();
        }

        List<Dentist> dentists = dentistDAO.listAllDentists();

        request.setAttribute("targetDate", targetDate);
        request.setAttribute("viewMode", viewMode);
        request.setAttribute("startOfWeek", startOfWeek);
        request.setAttribute("endOfWeek", endOfWeek);
        request.setAttribute("prevWeekDate", startOfWeek.minusWeeks(1));
        request.setAttribute("nextWeekDate", startOfWeek.plusWeeks(1));
        request.setAttribute("todayDate", LocalDate.now());
        request.setAttribute("weekSchedule", weekSchedule);
        request.setAttribute("totalWeekAppointments", totalWeekAppointments);
        request.setAttribute("dentists", dentists);
        request.setAttribute("selectedDentistId", dentistId);

        request.getRequestDispatcher("/WEB-INF/views/receptionist/calendar.jsp").forward(request, response);
    }
}

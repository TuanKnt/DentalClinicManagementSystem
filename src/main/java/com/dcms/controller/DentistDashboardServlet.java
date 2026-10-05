package com.dcms.controller;

import com.dcms.model.User;
import com.dcms.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Controller displaying Dentist clinical dashboard and workbench metrics.
 */
@WebServlet(name = "DentistDashboardServlet", urlPatterns = {"/dentist/dashboard"})
public class DentistDashboardServlet extends HttpServlet {

    private final DashboardService dashboardService;

    public DentistDashboardServlet() {
        this.dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        int dentistId = 1; // default to first dentist if not resolved
        if (currentUser != null && "Dentist".equalsIgnoreCase(currentUser.getRoleName())) {
            dentistId = currentUser.getUserId();
        }

        Map<String, Object> metrics = dashboardService.getDentistDashboardMetrics(dentistId);
        for (Map.Entry<String, Object> entry : metrics.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        request.setAttribute("dentistId", dentistId);
        request.getRequestDispatcher("/WEB-INF/views/dentist/dashboard.jsp").forward(request, response);
    }
}

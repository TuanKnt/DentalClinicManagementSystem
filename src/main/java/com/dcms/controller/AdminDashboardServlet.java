package com.dcms.controller;

import com.dcms.service.DashboardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * Controller displaying administrative system overview and clinic operations.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final DashboardService dashboardService;

    public AdminDashboardServlet() {
        this.dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Object> metrics = dashboardService.getAdminDashboardMetrics();
        for (Map.Entry<String, Object> entry : metrics.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

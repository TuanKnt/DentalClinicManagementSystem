package com.dcms.controller;

import com.dcms.model.DentalService;
import com.dcms.service.CatalogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * DentalServiceServlet manages dental procedure definitions, catalog categories,
 * and clinic pricing tariffs (UC40).
 */
@WebServlet(name = "DentalServiceServlet", urlPatterns = {
        "/admin/services",
        "/admin/services/create",
        "/admin/services/update",
        "/admin/services/toggle"
})
public class DentalServiceServlet extends HttpServlet {

    private final CatalogService catalogService;

    public DentalServiceServlet() {
        this.catalogService = new CatalogService();
    }

    public DentalServiceServlet(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String activeOnlyParam = request.getParameter("activeOnly");
        boolean onlyActive = "true".equalsIgnoreCase(activeOnlyParam);

        List<DentalService> services = catalogService.listServicesByCategory(category, onlyActive);

        // Calculate KPI summary
        long activeCount = services.stream().filter(DentalService::isActive).count();
        long inactiveCount = services.size() - activeCount;

        request.setAttribute("serviceList", services);
        request.setAttribute("selectedCategory", category != null ? category : "all");
        request.setAttribute("totalCount", services.size());
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("inactiveCount", inactiveCount);

        request.getRequestDispatcher("/WEB-INF/views/admin/service-catalog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/create")) {
            handleCreate(request, response);
        } else if (uri.endsWith("/update")) {
            handleUpdate(request, response);
        } else if (uri.endsWith("/toggle")) {
            handleToggle(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/services");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String code = request.getParameter("serviceCode");
            String name = request.getParameter("serviceName");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String unit = request.getParameter("unit");
            String description = request.getParameter("description");

            BigDecimal price = priceStr != null && !priceStr.trim().isEmpty()
                    ? new BigDecimal(priceStr.trim().replaceAll("[,.]", ""))
                    : BigDecimal.ZERO;

            DentalService service = new DentalService();
            service.setServiceCode(code);
            service.setServiceName(name);
            service.setCategory(category);
            service.setPrice(price);
            service.setUnit(unit != null && !unit.trim().isEmpty() ? unit.trim() : "Lần");
            service.setDescription(description != null ? description.trim() : "");
            service.setActive(true);

            catalogService.createService(service);
            redirectWithParam(response, request.getContextPath() + "/admin/services", "successMessage",
                    "Đã thêm thành công dịch vụ mới: " + service.getServiceName() + " (" + service.getServiceCode() + ")");
        } catch (IllegalArgumentException ex) {
            redirectWithParam(response, request.getContextPath() + "/admin/services", "errorMessage", ex.getMessage());
        } catch (Exception ex) {
            redirectWithParam(response, request.getContextPath() + "/admin/services", "errorMessage",
                    "Lỗi hệ thống khi thêm dịch vụ: " + ex.getMessage());
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("serviceId");
            int serviceId = Integer.parseInt(idStr);

            String code = request.getParameter("serviceCode");
            String name = request.getParameter("serviceName");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String unit = request.getParameter("unit");
            String description = request.getParameter("description");
            boolean active = "1".equals(request.getParameter("isActive")) || "true".equalsIgnoreCase(request.getParameter("isActive"));

            BigDecimal price = priceStr != null && !priceStr.trim().isEmpty()
                    ? new BigDecimal(priceStr.trim().replaceAll("[,.]", ""))
                    : BigDecimal.ZERO;

            DentalService service = new DentalService(serviceId, code, name, category, price, unit, description, active);
            catalogService.updateService(service);

            redirectWithParam(response, request.getContextPath() + "/admin/services", "successMessage",
                    "Đã cập nhật thông tin dịch vụ #" + service.getServiceCode() + " thành công!");
        } catch (IllegalArgumentException ex) {
            redirectWithParam(response, request.getContextPath() + "/admin/services", "errorMessage", ex.getMessage());
        } catch (Exception ex) {
            redirectWithParam(response, request.getContextPath() + "/admin/services", "errorMessage",
                    "Lỗi khi cập nhật dịch vụ: " + ex.getMessage());
        }
    }

    private void handleToggle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("serviceId");
            int serviceId = Integer.parseInt(idStr);

            catalogService.toggleServiceStatus(serviceId);
            redirectWithParam(response, request.getContextPath() + "/admin/services", "successMessage",
                    "Đã cập nhật trạng thái hoạt động của dịch vụ #" + serviceId);
        } catch (Exception ex) {
            redirectWithParam(response, request.getContextPath() + "/admin/services", "errorMessage",
                    "Lỗi khi đổi trạng thái: " + ex.getMessage());
        }
    }

    private void redirectWithParam(HttpServletResponse response, String baseUrl, String paramName, String message) throws IOException {
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(baseUrl + "?" + paramName + "=" + encoded);
    }
}

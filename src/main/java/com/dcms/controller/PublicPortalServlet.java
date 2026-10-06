package com.dcms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * PublicPortalServlet handles friendly URL routing for Dr.Smile public clinic portal:
 * - /dich-vu, /services: Dịch vụ nha khoa
 * - /gioi-thieu, /about: Giới thiệu phòng khám
 * - /bac-si, /doctors: Đội ngũ Bác sĩ
 * - /bang-gia, /uu-dai, /pricing: Bảng giá niêm yết & Các gói ưu đãi
 * - /tin-tuc, /news: Tin tức & Cẩm nang nha khoa
 * - /lien-he, /contact: Liên hệ cơ sở & Đặt lịch khám online
 */
@WebServlet(name = "PublicPortalServlet", urlPatterns = {
        "/dich-vu", "/dich-vu/*", "/services",
        "/gioi-thieu", "/gioi-thieu/*", "/about",
        "/bac-si", "/bac-si/*", "/doctors",
        "/bang-gia", "/bang-gia/*", "/uu-dai", "/pricing",
        "/tin-tuc", "/tin-tuc/*", "/news",
        "/lien-he", "/lien-he/*", "/contact"
})
public class PublicPortalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if (servletPath == null) {
            servletPath = "";
        }

        String targetTab = "home";
        if (servletPath.startsWith("/dich-vu") || servletPath.startsWith("/services")) {
            targetTab = "services";
        } else if (servletPath.startsWith("/gioi-thieu") || servletPath.startsWith("/about")) {
            targetTab = "about";
        } else if (servletPath.startsWith("/bac-si") || servletPath.startsWith("/doctors")) {
            targetTab = "doctors";
        } else if (servletPath.startsWith("/bang-gia") || servletPath.startsWith("/uu-dai") || servletPath.startsWith("/pricing")) {
            targetTab = "pricing";
        } else if (servletPath.startsWith("/tin-tuc") || servletPath.startsWith("/news")) {
            targetTab = "news";
        } else if (servletPath.startsWith("/lien-he") || servletPath.startsWith("/contact")) {
            targetTab = "booking";
        }

        String contextPath = request.getContextPath() != null ? request.getContextPath() : "";
        response.sendRedirect(contextPath + "/#" + targetTab);
    }
}

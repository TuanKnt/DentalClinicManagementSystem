package com.dcms.filter;

import com.dcms.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter controls access to protected functional modules based on Role (RBAC).
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {
        "/admin/*",
        "/reception/*",
        "/dentist/*",
        "/clinical/*",
        "/cashier/*"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. Not logged in -> Redirect to login page
        if (currentUser == null) {
            httpResponse.sendRedirect(contextPath + "/login?redirect=" + path);
            return;
        }

        // 2. Role-based authorization check
        String role = currentUser.getRoleName() != null ? currentUser.getRoleName().trim() : "";
        boolean isAuthorized = false;

        if (role.equalsIgnoreCase("Admin")) {
            // Admin has superuser privileges
            isAuthorized = true;
        } else if (path.startsWith("/reception/")) {
            isAuthorized = role.equalsIgnoreCase("Receptionist")
                    || (path.startsWith("/reception/calendar") && role.equalsIgnoreCase("Dentist"))
                    || (path.startsWith("/reception/patients") && (role.equalsIgnoreCase("Dentist") || role.equalsIgnoreCase("DentalAssistant")));
        } else if (path.startsWith("/dentist/")) {
            isAuthorized = role.equalsIgnoreCase("Dentist") || role.equalsIgnoreCase("DentalAssistant");
        } else if (path.startsWith("/clinical/")) {
            isAuthorized = role.equalsIgnoreCase("Dentist") || role.equalsIgnoreCase("DentalAssistant");
        } else if (path.startsWith("/cashier/")) {
            isAuthorized = role.equalsIgnoreCase("Cashier");
        }

        if (!isAuthorized) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.setAttribute("requiredPath", path);
            httpRequest.setAttribute("userRole", role);
            httpRequest.getRequestDispatcher("/WEB-INF/views/common/access-denied.jsp").forward(request, response);
            return;
        }

        // Authorized -> Continue chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

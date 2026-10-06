package com.dcms.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class PublicPortalServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    private PublicPortalServlet servlet;

    @BeforeEach
    public void setUp() {
        servlet = new PublicPortalServlet();
        when(request.getContextPath()).thenReturn("/dcms");
    }

    @Test
    @DisplayName("Route /dich-vu redirects to /dcms/#services")
    public void testRedirectServices() throws Exception {
        when(request.getServletPath()).thenReturn("/dich-vu");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#services");
    }

    @Test
    @DisplayName("Route /gioi-thieu redirects to /dcms/#about")
    public void testRedirectAbout() throws Exception {
        when(request.getServletPath()).thenReturn("/gioi-thieu");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#about");
    }

    @Test
    @DisplayName("Route /bac-si redirects to /dcms/#doctors")
    public void testRedirectDoctors() throws Exception {
        when(request.getServletPath()).thenReturn("/bac-si");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#doctors");
    }

    @Test
    @DisplayName("Route /bang-gia redirects to /dcms/#pricing")
    public void testRedirectPricing() throws Exception {
        when(request.getServletPath()).thenReturn("/bang-gia");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#pricing");
    }

    @Test
    @DisplayName("Route /tin-tuc redirects to /dcms/#news")
    public void testRedirectNews() throws Exception {
        when(request.getServletPath()).thenReturn("/tin-tuc");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#news");
    }

    @Test
    @DisplayName("Route /lien-he redirects to /dcms/#booking")
    public void testRedirectContactBooking() throws Exception {
        when(request.getServletPath()).thenReturn("/lien-he");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#booking");
    }

    @Test
    @DisplayName("Default or unknown public route redirects to /dcms/#home")
    public void testRedirectDefaultHome() throws Exception {
        when(request.getServletPath()).thenReturn("/unknown");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/dcms/#home");
    }
}

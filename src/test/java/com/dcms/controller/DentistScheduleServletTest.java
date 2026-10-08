package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.model.Dentist;
import com.dcms.model.DentistSchedule;
import com.dcms.service.DentistScheduleService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.LocalTime;
import java.util.Collections;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class DentistScheduleServletTest {

    @Mock
    private DentistScheduleService scheduleService;

    @Mock
    private DentistDAO dentistDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private RequestDispatcher requestDispatcher;

    private DentistScheduleServlet servlet;

    @BeforeEach
    public void setUp() {
        servlet = new DentistScheduleServlet(scheduleService, dentistDAO);
        when(request.getContextPath()).thenReturn("/dcms");
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    @Test
    @DisplayName("TC_SCHED_SERVLET_01: doGet renders schedule list page with dentists and schedules")
    public void testDoGetRendersScheduleList() throws Exception {
        Dentist d = new Dentist(3, "LIC001", "Chỉnh nha", "Phòng 201");
        d.setFullName("BS. Mai Tuấn Vũ");
        DentistSchedule s = new DentistSchedule(1, 3, 1, LocalTime.of(8, 0), LocalTime.of(17, 0), true);

        when(dentistDAO.listAllDentists()).thenReturn(Collections.singletonList(d));
        when(scheduleService.listAllSchedules(null)).thenReturn(Collections.singletonList(s));

        servlet.doGet(request, response);

        verify(request).setAttribute(eq("dentists"), any());
        verify(request).setAttribute(eq("scheduleList"), any());
        verify(request).getRequestDispatcher("/WEB-INF/views/receptionist/dentist-schedules.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    @DisplayName("TC_SCHED_SERVLET_02: doPost create schedule redirects to success")
    public void testDoPostCreateSuccess() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/schedules/create");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("dayOfWeek")).thenReturn("2");
        when(request.getParameter("shiftStart")).thenReturn("08:00");
        when(request.getParameter("shiftEnd")).thenReturn("17:00");
        when(request.getParameter("isAvailable")).thenReturn("true");

        DentistSchedule created = new DentistSchedule(10, 3, 2, LocalTime.of(8, 0), LocalTime.of(17, 0), true);
        when(scheduleService.addSchedule(any(DentistSchedule.class))).thenReturn(created);

        servlet.doPost(request, response);

        verify(scheduleService, times(1)).addSchedule(any(DentistSchedule.class));
        verify(response).sendRedirect("/dcms/reception/schedules?dentistId=3&success=created");
    }

    @Test
    @DisplayName("TC_SCHED_SERVLET_03: doPost delete schedule redirects to success")
    public void testDoPostDeleteSuccess() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/schedules/delete");
        when(request.getParameter("scheduleId")).thenReturn("10");
        when(request.getParameter("returnDentistId")).thenReturn("3");
        when(scheduleService.deleteSchedule(10)).thenReturn(true);

        servlet.doPost(request, response);

        verify(scheduleService, times(1)).deleteSchedule(10);
        verify(response).sendRedirect("/dcms/reception/schedules?dentistId=3&success=deleted");
    }

    @Test
    @DisplayName("TC_SCHED_SERVLET_04: doPost toggle availability redirects to success")
    public void testDoPostToggleSuccess() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/schedules/toggle");
        when(request.getParameter("scheduleId")).thenReturn("10");
        when(request.getParameter("available")).thenReturn("false");
        when(request.getParameter("returnDentistId")).thenReturn("3");
        when(scheduleService.toggleAvailability(10, false)).thenReturn(true);

        servlet.doPost(request, response);

        verify(scheduleService, times(1)).toggleAvailability(10, false);
        verify(response).sendRedirect("/dcms/reception/schedules?dentistId=3&success=toggled");
    }

    @Test
    @DisplayName("TC_SCHED_SERVLET_05: doPost with validation error redirects with error param")
    public void testDoPostCreateError() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/schedules/create");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("dayOfWeek")).thenReturn("2");
        when(request.getParameter("shiftStart")).thenReturn("17:00");
        when(request.getParameter("shiftEnd")).thenReturn("08:00");

        doThrow(new IllegalArgumentException("Giờ kết thúc ca trực phải sau giờ bắt đầu"))
                .when(scheduleService).addSchedule(any(DentistSchedule.class));

        servlet.doPost(request, response);

        verify(response).sendRedirect(contains("error="));
    }
}

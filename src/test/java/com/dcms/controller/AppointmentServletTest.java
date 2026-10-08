package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.service.AppointmentService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class AppointmentServletTest {

    @Mock
    private AppointmentService appointmentService;

    @Mock
    private DentistDAO dentistDAO;

    @Mock
    private PatientDAO patientDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private RequestDispatcher requestDispatcher;

    private AppointmentServlet servlet;

    @BeforeEach
    public void setUp() throws Exception {
        servlet = new AppointmentServlet();

        // Inject mocks via reflection
        Field serviceField = AppointmentServlet.class.getDeclaredField("appointmentService");
        serviceField.setAccessible(true);
        serviceField.set(servlet, appointmentService);

        Field dentistField = AppointmentServlet.class.getDeclaredField("dentistDAO");
        dentistField.setAccessible(true);
        dentistField.set(servlet, dentistDAO);

        Field patientField = AppointmentServlet.class.getDeclaredField("patientDAO");
        patientField.setAccessible(true);
        patientField.set(servlet, patientDAO);

        when(request.getContextPath()).thenReturn("/dcms");
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    @Test
    @DisplayName("TC_APPT_SERVLET_01: handleCreate parses fixed timeSlot parameter correctly")
    public void testHandleCreateWithTimeSlot() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/appointments/create");
        when(request.getParameter("patientId")).thenReturn("1");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("appointmentDate")).thenReturn(LocalDate.now().plusDays(1).toString());
        when(request.getParameter("timeSlot")).thenReturn("09:00-09:30");
        when(request.getParameter("reason")).thenReturn("Trám răng");

        ArgumentCaptor<Appointment> captor = ArgumentCaptor.forClass(Appointment.class);

        servlet.doPost(request, response);

        verify(appointmentService).bookAppointment(captor.capture());
        Appointment booked = captor.getValue();
        assertEquals(LocalTime.of(9, 0), booked.getStartTime());
        assertEquals(LocalTime.of(9, 30), booked.getEndTime());
        verify(response).sendRedirect(contains("success=booked"));
    }

    @Test
    @DisplayName("TC_APPT_SERVLET_02: handleReschedule parses fixed timeSlot parameter correctly")
    public void testHandleRescheduleWithTimeSlot() throws Exception {
        when(request.getServletPath()).thenReturn("/reception/appointments/reschedule");
        when(request.getParameter("appointmentId")).thenReturn("201");
        when(request.getParameter("newDate")).thenReturn(LocalDate.now().plusDays(2).toString());
        when(request.getParameter("timeSlot")).thenReturn("14:00-14:30");

        servlet.doPost(request, response);

        verify(appointmentService).rescheduleAppointment(
                eq(201),
                eq(LocalDate.now().plusDays(2)),
                eq(LocalTime.of(14, 0)),
                eq(LocalTime.of(14, 30))
        );
        verify(response).sendRedirect(contains("success=rescheduled"));
    }
}

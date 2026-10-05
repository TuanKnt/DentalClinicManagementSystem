package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.model.Patient;
import com.dcms.service.AppointmentService;
import com.dcms.service.exception.AppointmentConflictException;
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

import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class GuestBookingServletTest {

    @Mock
    private AppointmentService appointmentService;

    @Mock
    private PatientDAO patientDAO;

    @Mock
    private DentistDAO dentistDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    private GuestBookingServlet servlet;
    private StringWriter responseWriter;

    @BeforeEach
    public void setUp() throws Exception {
        servlet = new GuestBookingServlet(appointmentService, patientDAO, dentistDAO);
        responseWriter = new StringWriter();
        lenient().when(response.getWriter()).thenReturn(new PrintWriter(responseWriter));
        lenient().when(request.getContextPath()).thenReturn("/dcms");
    }

    @Test
    @DisplayName("TC_GUEST_01: Online Booking Success for New Patient")
    public void testGuestBookingNewPatientSuccess() throws Exception {
        when(request.getParameter("fullName")).thenReturn("Hoàng Minh Khôi");
        when(request.getParameter("phone")).thenReturn("0987654321");
        when(request.getParameter("email")).thenReturn("khoi.hoang@gmail.com");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("appointmentDate")).thenReturn(LocalDate.now().plusDays(2).toString());
        when(request.getParameter("timeSlot")).thenReturn("09:00 - 10:00");
        when(request.getParameter("reason")).thenReturn("Khám tư vấn Implant");

        // Patient doesn't exist yet
        when(patientDAO.findByPhone("0987654321")).thenReturn(null);
        when(patientDAO.create(any(Patient.class))).thenReturn(99);

        Appointment createdAppt = new Appointment();
        createdAppt.setAppointmentId(301);
        createdAppt.setStatus(Appointment.STATUS_PENDING);
        when(appointmentService.bookAppointment(any(Appointment.class))).thenReturn(createdAppt);

        servlet.doPost(request, response);

        verify(patientDAO).create(any(Patient.class));
        verify(appointmentService).bookAppointment(any(Appointment.class));
        verify(response).sendRedirect(contains("bookingSuccess=1&apptId=301"));
    }

    @Test
    @DisplayName("TC_GUEST_02: Online Booking Success for Existing Patient")
    public void testGuestBookingExistingPatientSuccess() throws Exception {
        when(request.getParameter("fullName")).thenReturn("Nguyễn Văn An");
        when(request.getParameter("phone")).thenReturn("0901234567");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("appointmentDate")).thenReturn(LocalDate.now().plusDays(1).toString());
        when(request.getParameter("timeSlot")).thenReturn("14:00 - 15:00");

        Patient existingPatient = new Patient();
        existingPatient.setPatientId(12);
        existingPatient.setPhone("0901234567");
        when(patientDAO.findByPhone("0901234567")).thenReturn(existingPatient);

        Appointment createdAppt = new Appointment();
        createdAppt.setAppointmentId(302);
        when(appointmentService.bookAppointment(any(Appointment.class))).thenReturn(createdAppt);

        servlet.doPost(request, response);

        verify(patientDAO, never()).create(any(Patient.class));
        ArgumentCaptor<Appointment> captor = ArgumentCaptor.forClass(Appointment.class);
        verify(appointmentService).bookAppointment(captor.capture());
        assertEquals(12, captor.getValue().getPatientId());
        verify(response).sendRedirect(contains("bookingSuccess=1&apptId=302"));
    }

    @Test
    @DisplayName("TC_GUEST_03: Invalid Phone Format triggers error redirect")
    public void testGuestBookingInvalidPhone() throws Exception {
        when(request.getParameter("fullName")).thenReturn("Lê Văn C");
        when(request.getParameter("phone")).thenReturn("12345"); // invalid length

        servlet.doPost(request, response);

        verify(appointmentService, never()).bookAppointment(any(Appointment.class));
        verify(response).sendRedirect(contains("bookingError="));
    }

    @Test
    @DisplayName("TC_GUEST_04: Blank Full Name triggers error redirect")
    public void testGuestBookingBlankName() throws Exception {
        when(request.getParameter("fullName")).thenReturn("   ");

        servlet.doPost(request, response);

        verify(appointmentService, never()).bookAppointment(any(Appointment.class));
        verify(response).sendRedirect(contains("bookingError="));
    }

    @Test
    @DisplayName("TC_GUEST_05: Overlap Time Conflict returns error message")
    public void testGuestBookingTimeConflict() throws Exception {
        when(request.getParameter("fullName")).thenReturn("Trần Văn D");
        when(request.getParameter("phone")).thenReturn("0912345678");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("appointmentDate")).thenReturn(LocalDate.now().plusDays(1).toString());
        when(request.getParameter("timeSlot")).thenReturn("09:00 - 10:00");

        Patient patient = new Patient();
        patient.setPatientId(15);
        when(patientDAO.findByPhone("0912345678")).thenReturn(patient);

        when(appointmentService.bookAppointment(any(Appointment.class)))
                .thenThrow(new AppointmentConflictException("Trùng lịch hẹn của bác sĩ"));

        servlet.doPost(request, response);

        verify(response).sendRedirect(contains("bookingError="));
    }

    @Test
    @DisplayName("TC_GUEST_06: AJAX Booking returns JSON response")
    public void testGuestBookingAjaxSuccess() throws Exception {
        when(request.getHeader("X-Requested-With")).thenReturn("XMLHttpRequest");
        when(request.getParameter("fullName")).thenReturn("Phạm Thu Hà");
        when(request.getParameter("phone")).thenReturn("0988776655");
        when(request.getParameter("dentistId")).thenReturn("3");
        when(request.getParameter("appointmentDate")).thenReturn(LocalDate.now().plusDays(3).toString());
        when(request.getParameter("timeSlot")).thenReturn("10:00 - 11:00");

        Patient patient = new Patient();
        patient.setPatientId(20);
        when(patientDAO.findByPhone("0988776655")).thenReturn(patient);

        Appointment createdAppt = new Appointment();
        createdAppt.setAppointmentId(305);
        when(appointmentService.bookAppointment(any(Appointment.class))).thenReturn(createdAppt);

        servlet.doPost(request, response);

        verify(response).setContentType(contains("application/json"));
        String json = responseWriter.toString();
        assertTrue(json.contains("\"success\": true"));
        assertTrue(json.contains("\"appointmentId\": 305"));
    }
}

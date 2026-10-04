package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.DentistScheduleDAO;
import com.dcms.model.Appointment;
import com.dcms.service.exception.AppointmentConflictException;
import com.dcms.service.exception.DentistNotAvailableException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AppointmentServiceTest {

    @Mock
    private AppointmentDAO appointmentDAO;

    @Mock
    private DentistScheduleDAO scheduleDAO;

    private AppointmentService appointmentService;

    private LocalDate futureDate;

    @BeforeEach
    public void setUp() {
        appointmentService = new AppointmentService(appointmentDAO, scheduleDAO);
        futureDate = LocalDate.now().plusDays(2);
    }

    @Test
    @DisplayName("TC_APPT_01: Book Slot Success when dentist on shift and no overlap")
    public void testBookAppointmentSuccess() {
        Appointment appt = new Appointment();
        appt.setPatientId(1);
        appt.setDentistId(3);
        appt.setAppointmentDate(futureDate);
        appt.setStartTime(LocalTime.of(9, 0));
        appt.setEndTime(LocalTime.of(10, 0));
        appt.setReason("Khám răng định kỳ");

        int dayOfWeek = futureDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(9, 0), LocalTime.of(10, 0))).thenReturn(true);
        when(appointmentDAO.countConflicts(3, futureDate, LocalTime.of(9, 0), LocalTime.of(10, 0), null)).thenReturn(0);
        when(appointmentDAO.create(appt)).thenReturn(201);

        Appointment result = appointmentService.bookAppointment(appt);

        assertNotNull(result);
        assertEquals(201, result.getAppointmentId());
        assertEquals(Appointment.STATUS_PENDING, result.getStatus());
        verify(appointmentDAO).create(appt);
    }

    @Test
    @DisplayName("TC_APPT_02: Book Fails when Overlap Time Conflict exists")
    public void testBookAppointmentConflictFails() {
        Appointment appt = new Appointment();
        appt.setPatientId(2);
        appt.setDentistId(3);
        appt.setAppointmentDate(futureDate);
        appt.setStartTime(LocalTime.of(9, 0));
        appt.setEndTime(LocalTime.of(10, 0));

        int dayOfWeek = futureDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(9, 0), LocalTime.of(10, 0))).thenReturn(true);
        when(appointmentDAO.countConflicts(3, futureDate, LocalTime.of(9, 0), LocalTime.of(10, 0), null)).thenReturn(1); // 1 conflict

        assertThrows(AppointmentConflictException.class, () -> {
            appointmentService.bookAppointment(appt);
        }, "Should throw AppointmentConflictException on overlapping slot");

        verify(appointmentDAO, never()).create(any());
    }

    @Test
    @DisplayName("TC_APPT_03: Book Fails when Dentist is not on shift")
    public void testBookAppointmentDentistNotWorkingFails() {
        Appointment appt = new Appointment();
        appt.setPatientId(2);
        appt.setDentistId(3);
        appt.setAppointmentDate(futureDate);
        appt.setStartTime(LocalTime.of(20, 0)); // Late night
        appt.setEndTime(LocalTime.of(21, 0));

        int dayOfWeek = futureDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(20, 0), LocalTime.of(21, 0))).thenReturn(false);

        assertThrows(DentistNotAvailableException.class, () -> {
            appointmentService.bookAppointment(appt);
        }, "Should throw DentistNotAvailableException when dentist has no shift");

        verify(appointmentDAO, never()).create(any());
    }

    @Test
    @DisplayName("TC_APPT_04: Book Fails on Past Date")
    public void testBookAppointmentPastDateFails() {
        Appointment appt = new Appointment();
        appt.setPatientId(1);
        appt.setDentistId(3);
        appt.setAppointmentDate(LocalDate.now().minusDays(1)); // Past date
        appt.setStartTime(LocalTime.of(9, 0));
        appt.setEndTime(LocalTime.of(10, 0));

        assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(appt);
        });
    }

    @Test
    @DisplayName("TC_APPT_05: Cancel Appointment with Reason Success")
    public void testCancelAppointmentSuccess() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(201);
        appt.setStatus(Appointment.STATUS_CONFIRMED);

        when(appointmentDAO.findById(201)).thenReturn(appt);
        when(appointmentDAO.cancelWithReason(201, "Bận việc đột xuất")).thenReturn(true);

        boolean result = appointmentService.cancelAppointment(201, "Bận việc đột xuất");
        assertTrue(result);
    }

    @Test
    @DisplayName("TC_APPT_06: Cancel Fails on Already Arrived Appointment")
    public void testCancelAlreadyArrivedAppointmentFails() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(202);
        appt.setStatus(Appointment.STATUS_ARRIVED); // Already checked in!

        when(appointmentDAO.findById(202)).thenReturn(appt);

        assertThrows(IllegalStateException.class, () -> {
            appointmentService.cancelAppointment(202, "Lý do hủy");
        }, "Cannot cancel appointment that is already marked Arrived");
    }

    @Test
    @DisplayName("TC_APPT_07: Confirm Appointment Success")
    public void testConfirmAppointmentSuccess() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(203);
        appt.setStatus(Appointment.STATUS_PENDING);

        when(appointmentDAO.findById(203)).thenReturn(appt);
        when(appointmentDAO.updateStatus(203, Appointment.STATUS_CONFIRMED)).thenReturn(true);

        boolean result = appointmentService.confirmAppointment(203);
        assertTrue(result);
    }
}

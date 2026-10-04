package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Visit;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class VisitServiceTest {

    @Mock
    private VisitDAO visitDAO;

    @Mock
    private AppointmentDAO appointmentDAO;

    private VisitService visitService;

    @BeforeEach
    public void setUp() {
        visitService = new VisitService(visitDAO, appointmentDAO);
    }

    @Test
    @DisplayName("TC_VISIT_01: Check-in scheduled patient transitions Appointment to Arrived and creates Waiting Visit")
    public void testCheckInSuccessCreatesWaitingVisit() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(301);
        appt.setPatientId(10);
        appt.setDentistId(3);
        appt.setStatus(Appointment.STATUS_CONFIRMED);
        appt.setReason("Đau răng hàm dưới");

        when(appointmentDAO.findById(301)).thenReturn(appt);
        when(appointmentDAO.updateStatus(301, Appointment.STATUS_ARRIVED)).thenReturn(true);
        when(visitDAO.create(any(Visit.class))).thenReturn(501);

        Visit visit = visitService.checkInPatient(301);

        assertNotNull(visit);
        assertEquals(501, visit.getVisitId());
        assertEquals(10, visit.getPatientId());
        assertEquals(3, visit.getPrimaryDentistId());
        assertEquals(Integer.valueOf(301), visit.getAppointmentId());
        assertEquals(Visit.STATUS_WAITING, visit.getStatus());
        assertEquals(Visit.TYPE_SCHEDULED, visit.getVisitType());

        verify(appointmentDAO).updateStatus(301, Appointment.STATUS_ARRIVED);
        verify(visitDAO).create(any(Visit.class));
    }

    @Test
    @DisplayName("TC_VISIT_02: Check-in fails when Appointment is already marked Arrived")
    public void testCheckInAlreadyArrivedThrowsException() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(302);
        appt.setStatus(Appointment.STATUS_ARRIVED); // Already checked in!

        when(appointmentDAO.findById(302)).thenReturn(appt);

        assertThrows(IllegalStateException.class, () -> {
            visitService.checkInPatient(302);
        }, "Should throw IllegalStateException when appointment is already Arrived");

        verify(appointmentDAO, never()).updateStatus(anyInt(), anyString());
        verify(visitDAO, never()).create(any(Visit.class));
    }

    @Test
    @DisplayName("TC_VISIT_03: Check-in fails when Appointment is Cancelled")
    public void testCheckInCancelledThrowsException() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(303);
        appt.setStatus(Appointment.STATUS_CANCELLED);

        when(appointmentDAO.findById(303)).thenReturn(appt);

        assertThrows(IllegalStateException.class, () -> {
            visitService.checkInPatient(303);
        }, "Should throw IllegalStateException when appointment is Cancelled");

        verify(visitDAO, never()).create(any(Visit.class));
    }

    @Test
    @DisplayName("TC_VISIT_04: Walk-in Visit MUST have AppointmentId = NULL (Rule 1)")
    public void testWalkInVisitHasNullAppointmentId() {
        ArgumentCaptor<Visit> captor = ArgumentCaptor.forClass(Visit.class);
        when(visitDAO.create(captor.capture())).thenReturn(502);

        Visit created = visitService.createWalkInVisit(15, 4, Visit.TYPE_WALK_IN, "Đau răng cấp");

        assertNotNull(created);
        assertEquals(502, created.getVisitId());

        Visit captured = captor.getValue();
        assertNull(captured.getAppointmentId(), "Walk-in encounter MUST have null AppointmentId");
        assertEquals(Visit.STATUS_WAITING, captured.getStatus());
        assertEquals(Visit.TYPE_WALK_IN, captured.getVisitType());
        assertTrue(captured.isWalkIn());
    }

    @Test
    @DisplayName("TC_VISIT_05: Start examination transitions Waiting status to InProgress")
    public void testStartExamination() {
        Visit v = new Visit();
        v.setVisitId(501);
        v.setStatus(Visit.STATUS_WAITING);

        when(visitDAO.findById(501)).thenReturn(v);
        when(visitDAO.updateStatus(501, Visit.STATUS_IN_PROGRESS)).thenReturn(true);

        boolean result = visitService.startExamination(501);
        assertTrue(result);
        verify(visitDAO).updateStatus(501, Visit.STATUS_IN_PROGRESS);
    }

    @Test
    @DisplayName("TC_VISIT_06: Fetch today waiting queue FIFO")
    public void testGetTodayWaitingQueue() {
        Visit v = new Visit(501, 1, 3, 301, Visit.TYPE_SCHEDULED);
        when(visitDAO.getWaitingQueue(3)).thenReturn(Collections.singletonList(v));

        List<Visit> queue = visitService.getTodayWaitingQueue(3);
        assertEquals(1, queue.size());
        assertEquals(501, queue.get(0).getVisitId());
    }
}

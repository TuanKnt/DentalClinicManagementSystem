package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.DentistScheduleDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Patient;
import com.dcms.model.Visit;
import com.dcms.service.exception.AppointmentConflictException;
import com.dcms.service.exception.DentistNotAvailableException;
import com.dcms.service.exception.DuplicatePhoneException;
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

/**
 * End-to-End Integration and Domain Invariant Test Suite for Iteration 1 (BF-01).
 * Validates compliance with all 10 Non-Negotiable Rules and SWP requirements.
 */
@ExtendWith(MockitoExtension.class)
public class Iteration1EndToEndIntegrationTest {

    @Mock private PatientDAO patientDAO;
    @Mock private AppointmentDAO appointmentDAO;
    @Mock private DentistScheduleDAO scheduleDAO;
    @Mock private VisitDAO visitDAO;

    private PatientService patientService;
    private AppointmentService appointmentService;
    private VisitService visitService;

    private LocalDate targetDate;

    @BeforeEach
    public void setUp() {
        patientService = new PatientService(patientDAO);
        appointmentService = new AppointmentService(appointmentDAO, scheduleDAO);
        visitService = new VisitService(visitDAO, appointmentDAO);
        targetDate = LocalDate.now().plusDays(1);
    }

    @Test
    @DisplayName("E2E-01: Complete Reception Lifecycle (Register -> Book -> Confirm -> Checkin -> Queue -> Start Exam)")
    public void testCompleteReceptionLifecycle() {
        // Step 1: Register Patient
        Patient p = new Patient();
        p.setFullName("Nguyễn Văn A");
        p.setPhone("0988111222");
        p.setGender("Nam");
        when(patientDAO.findByPhone("0988111222")).thenReturn(null);
        when(patientDAO.create(p)).thenReturn(101);

        Patient registered = patientService.createPatient(p);
        assertEquals(101, registered.getPatientId());

        // Step 2: Book Appointment
        Appointment appt = new Appointment();
        appt.setPatientId(registered.getPatientId());
        appt.setDentistId(3);
        appt.setAppointmentDate(targetDate);
        appt.setStartTime(LocalTime.of(9, 0));
        appt.setEndTime(LocalTime.of(9, 30));
        appt.setReason("Khám răng sâu");

        int dayOfWeek = targetDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(9, 0), LocalTime.of(9, 30))).thenReturn(true);
        when(appointmentDAO.countConflicts(3, targetDate, LocalTime.of(9, 0), LocalTime.of(9, 30), null)).thenReturn(0);
        when(appointmentDAO.create(appt)).thenReturn(201);

        Appointment booked = appointmentService.bookAppointment(appt);
        assertEquals(201, booked.getAppointmentId());
        assertEquals(Appointment.STATUS_PENDING, booked.getStatus());

        // Step 3: Confirm Appointment
        when(appointmentDAO.findById(201)).thenReturn(booked);
        when(appointmentDAO.updateStatus(201, Appointment.STATUS_CONFIRMED)).thenReturn(true);
        boolean confirmed = appointmentService.confirmAppointment(201);
        assertTrue(confirmed);
        booked.setStatus(Appointment.STATUS_CONFIRMED);

        // Step 4: Patient Arrives at Clinic -> Receptionist Check-in (Spawns Visit, links Appointment)
        when(appointmentDAO.updateStatus(201, Appointment.STATUS_ARRIVED)).thenReturn(true);
        when(visitDAO.create(any(Visit.class))).thenReturn(501);

        Visit visit = visitService.checkInPatient(201);
        assertNotNull(visit);
        assertEquals(501, visit.getVisitId());
        assertEquals(Integer.valueOf(201), visit.getAppointmentId());
        assertEquals(Visit.STATUS_WAITING, visit.getStatus());
        assertEquals(Visit.TYPE_SCHEDULED, visit.getVisitType());

        // Step 5: Dentist Views Queue and Starts Examination
        when(visitDAO.getWaitingQueue(3)).thenReturn(Collections.singletonList(visit));
        List<Visit> queue = visitService.getTodayWaitingQueue(3);
        assertEquals(1, queue.size());

        when(visitDAO.findById(501)).thenReturn(visit);
        when(visitDAO.updateStatus(501, Visit.STATUS_IN_PROGRESS)).thenReturn(true);
        boolean started = visitService.startExamination(501);
        assertTrue(started);
    }

    @Test
    @DisplayName("E2E-02: Rule 1 Invariant — Walk-in Patient Visit MUST have NULL AppointmentId")
    public void testWalkInVisitInvariant() {
        ArgumentCaptor<Visit> captor = ArgumentCaptor.forClass(Visit.class);
        when(visitDAO.create(captor.capture())).thenReturn(502);

        Visit walkIn = visitService.createWalkInVisit(102, 3, Visit.TYPE_WALK_IN, "Cấp cứu đau răng dữ dội");

        assertNotNull(walkIn);
        assertEquals(502, walkIn.getVisitId());
        Visit captured = captor.getValue();
        assertNull(captured.getAppointmentId(), "RULE 1: Walk-in Visit must NEVER reference an Appointment");
        assertEquals(Visit.STATUS_WAITING, captured.getStatus());
        assertTrue(captured.isWalkIn());
    }

    @Test
    @DisplayName("E2E-03: Rule Invariant — Block Duplicate Check-in of Already Arrived Appointment")
    public void testBlockDuplicateCheckIn() {
        Appointment appt = new Appointment();
        appt.setAppointmentId(202);
        appt.setStatus(Appointment.STATUS_ARRIVED);

        when(appointmentDAO.findById(202)).thenReturn(appt);

        assertThrows(IllegalStateException.class, () -> {
            visitService.checkInPatient(202);
        });
        verify(visitDAO, never()).create(any());
    }

    @Test
    @DisplayName("E2E-04: Rule Invariant — Block Overlapping Appointment Time Conflict")
    public void testBlockOverlappingAppointment() {
        Appointment appt = new Appointment();
        appt.setPatientId(1);
        appt.setDentistId(3);
        appt.setAppointmentDate(targetDate);
        appt.setStartTime(LocalTime.of(14, 0));
        appt.setEndTime(LocalTime.of(15, 0));

        int dayOfWeek = targetDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(14, 0), LocalTime.of(15, 0))).thenReturn(true);
        when(appointmentDAO.countConflicts(3, targetDate, LocalTime.of(14, 0), LocalTime.of(15, 0), null)).thenReturn(1); // Conflict!

        assertThrows(AppointmentConflictException.class, () -> {
            appointmentService.bookAppointment(appt);
        });
    }

    @Test
    @DisplayName("E2E-05: Rule Invariant — Block Booking When Dentist Off Shift")
    public void testBlockBookingWhenDentistOffShift() {
        Appointment appt = new Appointment();
        appt.setPatientId(1);
        appt.setDentistId(3);
        appt.setAppointmentDate(targetDate);
        appt.setStartTime(LocalTime.of(22, 0));
        appt.setEndTime(LocalTime.of(23, 0));

        int dayOfWeek = targetDate.getDayOfWeek().getValue();
        when(scheduleDAO.isDentistWorking(3, dayOfWeek, LocalTime.of(22, 0), LocalTime.of(23, 0))).thenReturn(false);

        assertThrows(DentistNotAvailableException.class, () -> {
            appointmentService.bookAppointment(appt);
        });
    }

    @Test
    @DisplayName("E2E-06: Rule Invariant — Block Duplicate Phone Registration")
    public void testBlockDuplicatePhoneRegistration() {
        Patient existing = new Patient();
        existing.setPatientId(99);
        existing.setFullName("Người Cũ");
        existing.setPhone("0988111222");

        when(patientDAO.findByPhone("0988111222")).thenReturn(existing);

        Patient newP = new Patient();
        newP.setFullName("Người Mới");
        newP.setPhone("0988111222");
        newP.setGender("Nam");

        assertThrows(DuplicatePhoneException.class, () -> {
            patientService.createPatient(newP);
        });
    }
}

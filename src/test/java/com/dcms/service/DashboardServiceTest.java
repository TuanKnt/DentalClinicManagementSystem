package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.dao.UserDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Dentist;
import com.dcms.model.Patient;
import com.dcms.model.User;
import com.dcms.model.Visit;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class DashboardServiceTest {

    @Mock
    private UserDAO userDAO;

    @Mock
    private DentistDAO dentistDAO;

    @Mock
    private PatientDAO patientDAO;

    @Mock
    private AppointmentDAO appointmentDAO;

    @Mock
    private VisitDAO visitDAO;

    private DashboardService dashboardService;

    @BeforeEach
    public void setUp() {
        dashboardService = new DashboardService(userDAO, dentistDAO, patientDAO, appointmentDAO, visitDAO);
    }

    @Test
    @DisplayName("TC_DASHBOARD_01: Admin dashboard aggregates system metrics correctly")
    public void testGetAdminDashboardMetrics() {
        when(userDAO.findAll()).thenReturn(Arrays.asList(new User(), new User()));
        when(dentistDAO.findAll()).thenReturn(Collections.singletonList(new Dentist()));
        when(patientDAO.findAll()).thenReturn(Arrays.asList(new Patient(), new Patient(), new Patient()));
        when(appointmentDAO.findByDate(any(LocalDate.class))).thenReturn(Collections.singletonList(new Appointment()));
        when(visitDAO.findWaitingVisits()).thenReturn(Collections.singletonList(new Visit()));

        Map<String, Object> metrics = dashboardService.getAdminDashboardMetrics();

        assertNotNull(metrics);
        assertEquals(2, metrics.get("totalUsers"));
        assertEquals(1, metrics.get("totalDentists"));
        assertEquals(3, metrics.get("totalPatients"));
        assertEquals(1, metrics.get("todayAppointmentsCount"));
        assertEquals(1, metrics.get("waitingQueueCount"));
    }

    @Test
    @DisplayName("TC_DASHBOARD_02: Dentist dashboard metrics counts in-progress and completed visits")
    public void testGetDentistDashboardMetrics() {
        Visit v1 = new Visit();
        v1.setStatus(Visit.STATUS_WAITING);

        Visit v2 = new Visit();
        v2.setStatus(Visit.STATUS_IN_PROGRESS);

        Visit v3 = new Visit();
        v3.setStatus(Visit.STATUS_COMPLETED);

        when(appointmentDAO.findByDateAndDentist(any(LocalDate.class), eq(3)))
                .thenReturn(Collections.singletonList(new Appointment()));
        when(visitDAO.findVisitsByDentistAndDate(eq(3), any(LocalDate.class)))
                .thenReturn(Arrays.asList(v1, v2, v3));
        when(visitDAO.findWaitingVisits()).thenReturn(Collections.singletonList(v1));

        Map<String, Object> metrics = dashboardService.getDentistDashboardMetrics(3);

        assertNotNull(metrics);
        assertEquals(1, metrics.get("waitingCount"));
        assertEquals(1, metrics.get("inProgressCount"));
        assertEquals(1, metrics.get("completedCount"));
        assertEquals(1, metrics.get("totalApptsCount"));
    }
}

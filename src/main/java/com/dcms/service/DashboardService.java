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

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service providing aggregated KPI metrics and activity summaries for Role Dashboards.
 */
public class DashboardService {

    private final UserDAO userDAO;
    private final DentistDAO dentistDAO;
    private final PatientDAO patientDAO;
    private final AppointmentDAO appointmentDAO;
    private final VisitDAO visitDAO;

    public DashboardService() {
        this(new UserDAO(), new DentistDAO(), new PatientDAO(), new AppointmentDAO(), new VisitDAO());
    }

    public DashboardService(UserDAO userDAO, DentistDAO dentistDAO, PatientDAO patientDAO, AppointmentDAO appointmentDAO, VisitDAO visitDAO) {
        this.userDAO = userDAO;
        this.dentistDAO = dentistDAO;
        this.patientDAO = patientDAO;
        this.appointmentDAO = appointmentDAO;
        this.visitDAO = visitDAO;
    }

    public Map<String, Object> getAdminDashboardMetrics() {
        Map<String, Object> metrics = new HashMap<>();

        List<User> users = userDAO.findAll();
        List<Dentist> dentists = dentistDAO.findAll();
        List<Patient> patients = patientDAO.findAll();
        List<Appointment> todayAppts = appointmentDAO.findByDate(LocalDate.now());
        List<Visit> waitingVisits = visitDAO.findWaitingVisits();

        metrics.put("totalUsers", users != null ? users.size() : 0);
        metrics.put("totalDentists", dentists != null ? dentists.size() : 0);
        metrics.put("totalPatients", patients != null ? patients.size() : 0);
        metrics.put("todayAppointmentsCount", todayAppts != null ? todayAppts.size() : 0);
        metrics.put("waitingQueueCount", waitingVisits != null ? waitingVisits.size() : 0);
        metrics.put("dentists", dentists);
        metrics.put("recentPatients", patients != null && patients.size() > 5 ? patients.subList(0, 5) : patients);

        return metrics;
    }

    public Map<String, Object> getDentistDashboardMetrics(int dentistId) {
        Map<String, Object> metrics = new HashMap<>();

        List<Appointment> doctorAppts = appointmentDAO.findByDateAndDentist(LocalDate.now(), dentistId);
        List<Visit> doctorVisits = visitDAO.findVisitsByDentistAndDate(dentistId, LocalDate.now());
        List<Visit> waitingQueue = visitDAO.findWaitingVisits();

        int waitingCount = 0;
        int inProgressCount = 0;
        int completedCount = 0;

        if (doctorVisits != null) {
            for (Visit v : doctorVisits) {
                if (Visit.STATUS_WAITING.equalsIgnoreCase(v.getStatus())) waitingCount++;
                else if (Visit.STATUS_IN_PROGRESS.equalsIgnoreCase(v.getStatus())) inProgressCount++;
                else if (Visit.STATUS_COMPLETED.equalsIgnoreCase(v.getStatus())) completedCount++;
            }
        }

        metrics.put("todayAppointments", doctorAppts);
        metrics.put("doctorVisits", doctorVisits);
        metrics.put("waitingVisits", waitingQueue);
        metrics.put("waitingCount", waitingCount);
        metrics.put("inProgressCount", inProgressCount);
        metrics.put("completedCount", completedCount);
        metrics.put("totalApptsCount", doctorAppts != null ? doctorAppts.size() : 0);

        return metrics;
    }
}

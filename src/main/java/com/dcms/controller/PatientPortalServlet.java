package com.dcms.controller;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.dao.TreatmentPlanDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Patient;
import com.dcms.model.TreatmentPlan;
import com.dcms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

/**
 * PatientPortalServlet handles self-service portal for registered Patients (Actor: Patient).
 * Allows patients to view their personal dental records, upcoming appointments, and treatment plans.
 */
@WebServlet(name = "PatientPortalServlet", urlPatterns = {"/patient/appointments", "/patient/portal"})
public class PatientPortalServlet extends HttpServlet {

    private final PatientDAO patientDAO;
    private final AppointmentDAO appointmentDAO;
    private final TreatmentPlanDAO treatmentPlanDAO;

    public PatientPortalServlet() {
        this.patientDAO = new PatientDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.treatmentPlanDAO = new TreatmentPlanDAO();
    }

    public PatientPortalServlet(PatientDAO patientDAO, AppointmentDAO appointmentDAO, TreatmentPlanDAO treatmentPlanDAO) {
        this.patientDAO = patientDAO;
        this.appointmentDAO = appointmentDAO;
        this.treatmentPlanDAO = treatmentPlanDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/patient/appointments");
            return;
        }

        Patient patient = null;
        if (currentUser.getPhone() != null && !currentUser.getPhone().trim().isEmpty()) {
            patient = patientDAO.findByPhone(currentUser.getPhone().trim());
        }

        List<Appointment> myAppointments = Collections.emptyList();
        List<TreatmentPlan> myPlans = Collections.emptyList();

        if (patient != null) {
            myAppointments = appointmentDAO.findByPatientId(patient.getPatientId());
            myPlans = treatmentPlanDAO.findByPatientId(patient.getPatientId());
        }

        request.setAttribute("patient", patient);
        request.setAttribute("appointments", myAppointments);
        request.setAttribute("treatmentPlans", myPlans);

        request.getRequestDispatcher("/WEB-INF/views/patient/portal.jsp").forward(request, response);
    }
}

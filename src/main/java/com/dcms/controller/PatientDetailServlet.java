package com.dcms.controller;

import com.dcms.dao.PatientDAO;
import com.dcms.model.DentalAttachment;
import com.dcms.model.Patient;
import com.dcms.model.ToothFinding;
import com.dcms.model.Visit;
import com.dcms.service.ClinicalService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Patient 360° Clinical Profile & History dossier.
 * Aggregates demographics, medical alerts, visit history, odontogram condition, and attachments.
 */
@WebServlet(name = "PatientDetailServlet", urlPatterns = {"/reception/patients/detail"})
public class PatientDetailServlet extends HttpServlet {

    private final PatientDAO patientDAO;
    private final ClinicalService clinicalService;

    public PatientDetailServlet() {
        this.patientDAO = new PatientDAO();
        this.clinicalService = new ClinicalService();
    }

    public PatientDetailServlet(PatientDAO patientDAO, ClinicalService clinicalService) {
        this.patientDAO = patientDAO;
        this.clinicalService = clinicalService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reception/patients");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reception/patients?error=invalid_id");
            return;
        }

        Patient patient = patientDAO.findById(patientId);
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/reception/patients?error=not_found");
            return;
        }

        List<Visit> visitHistory = clinicalService.getPatientVisitHistory(patientId);
        List<ToothFinding> toothFindings = clinicalService.getToothFindingsByPatient(patientId);
        List<DentalAttachment> attachments = clinicalService.getAttachmentsByPatient(patientId);

        request.setAttribute("patient", patient);
        request.setAttribute("visitHistory", visitHistory);
        request.setAttribute("toothFindings", toothFindings);
        request.setAttribute("attachments", attachments);

        request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-detail.jsp").forward(request, response);
    }
}

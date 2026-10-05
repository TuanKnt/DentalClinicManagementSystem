package com.dcms.controller;

import com.dcms.dao.PatientDAO;
import com.dcms.model.ClinicalExamination;
import com.dcms.model.DentalAttachment;
import com.dcms.model.Patient;
import com.dcms.model.PreTreatmentAssessment;
import com.dcms.model.ToothFinding;
import com.dcms.model.User;
import com.dcms.model.Visit;
import com.dcms.service.ClinicalService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Dental Examination & Treatment Workspace servlet.
 * Central hub for dentist during a clinical visit:
 * - Pre-treatment assessment (vitals, bleeding risk, clearance)
 * - Clinical examination (chief complaint, intraoral/extraoral, diagnoses)
 * - Operatory chair assignment
 * - SVG Odontogram charting & attachments integration
 */
@WebServlet(name = "DentalExaminationServlet", urlPatterns = {"/clinical/examination"})
public class DentalExaminationServlet extends HttpServlet {

    private final ClinicalService clinicalService;
    private final PatientDAO patientDAO;

    public DentalExaminationServlet() {
        this.clinicalService = new ClinicalService();
        this.patientDAO = new PatientDAO();
    }

    public DentalExaminationServlet(ClinicalService clinicalService, PatientDAO patientDAO) {
        this.clinicalService = clinicalService;
        this.patientDAO = patientDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String visitIdParam = request.getParameter("visitId");
        if (visitIdParam == null || visitIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue");
            return;
        }

        int visitId;
        try {
            visitId = Integer.parseInt(visitIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=invalid_visit");
            return;
        }

        Visit visit = clinicalService.getVisitById(visitId);
        if (visit == null) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=not_found");
            return;
        }

        // Auto transition Waiting to InProgress if dentist opens visit workspace
        if (Visit.STATUS_WAITING.equalsIgnoreCase(visit.getStatus())) {
            clinicalService.startExamination(visitId, visit.getOperatory());
            visit = clinicalService.getVisitById(visitId);
        }

        Patient patient = patientDAO.findById(visit.getPatientId());
        PreTreatmentAssessment assessment = clinicalService.getPreTreatmentAssessment(visitId);
        ClinicalExamination examination = clinicalService.getClinicalExamination(visitId);
        List<ToothFinding> toothFindings = clinicalService.getToothFindingsByPatient(visit.getPatientId());
        List<DentalAttachment> visitAttachments = clinicalService.getAttachmentsByVisit(visitId);
        List<DentalAttachment> allPatientAttachments = clinicalService.getAttachmentsByPatient(visit.getPatientId());

        request.setAttribute("visit", visit);
        request.setAttribute("patient", patient);
        request.setAttribute("assessment", assessment);
        request.setAttribute("examination", examination);
        request.setAttribute("toothFindings", toothFindings);
        request.setAttribute("visitAttachments", visitAttachments);
        request.setAttribute("allPatientAttachments", allPatientAttachments);

        request.getRequestDispatcher("/WEB-INF/views/clinical/examination.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String visitIdParam = request.getParameter("visitId");

        if (visitIdParam == null || visitIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue");
            return;
        }

        int visitId;
        try {
            visitId = Integer.parseInt(visitIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=invalid_visit");
            return;
        }

        Visit visit = clinicalService.getVisitById(visitId);
        if (visit == null) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=not_found");
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        int performedBy = (currentUser != null) ? currentUser.getUserId() : visit.getDentistId();

        try {
            if ("save_vitals".equals(action)) {
                handleSaveVitals(request, visit, performedBy);
                response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId + "&tab=vitals&success=vitals_saved");
                return;
            } else if ("save_exam".equals(action)) {
                handleSaveExamination(request, visit);
                response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId + "&tab=diagnosis&success=exam_saved");
                return;
            } else if ("update_operatory".equals(action)) {
                String operatory = request.getParameter("operatory");
                clinicalService.assignOperatory(visitId, operatory);
                response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId + "&success=operatory_updated");
                return;
            } else if ("complete_visit".equals(action)) {
                clinicalService.completeExamination(visitId);
                response.sendRedirect(request.getContextPath() + "/dentist/queue?success=visit_completed");
                return;
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId + "&error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
            return;
        }

        response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId);
    }

    private void handleSaveVitals(HttpServletRequest request, Visit visit, int performedBy) {
        String bloodPressure = request.getParameter("bloodPressure");
        String pulseStr = request.getParameter("pulse");
        String bloodSugarStr = request.getParameter("bloodSugar");
        String bleedingRisk = request.getParameter("bleedingRisk");
        boolean medicalClearance = "true".equalsIgnoreCase(request.getParameter("medicalClearance"))
                || "on".equalsIgnoreCase(request.getParameter("medicalClearance"));
        String assessmentNotes = request.getParameter("assessmentNotes");

        Integer pulse = null;
        if (pulseStr != null && !pulseStr.trim().isEmpty()) {
            try { pulse = Integer.parseInt(pulseStr.trim()); } catch (NumberFormatException ignored) {}
        }

        BigDecimal bloodSugar = null;
        if (bloodSugarStr != null && !bloodSugarStr.trim().isEmpty()) {
            try { bloodSugar = new BigDecimal(bloodSugarStr.trim()); } catch (NumberFormatException ignored) {}
        }

        PreTreatmentAssessment assessment = new PreTreatmentAssessment();
        assessment.setVisitId(visit.getVisitId());
        assessment.setPatientId(visit.getPatientId());
        assessment.setBloodPressure(bloodPressure);
        assessment.setPulse(pulse);
        assessment.setBloodSugar(bloodSugar);
        assessment.setBleedingRisk(bleedingRisk != null ? bleedingRisk : "Low");
        assessment.setMedicalClearance(medicalClearance);
        assessment.setAssessmentNotes(assessmentNotes);
        assessment.setAssessedBy(performedBy);

        clinicalService.recordPreTreatmentAssessment(assessment);
    }

    private void handleSaveExamination(HttpServletRequest request, Visit visit) {
        String chiefComplaint = request.getParameter("chiefComplaint");
        String extraoralExam = request.getParameter("extraoralExam");
        String intraoralExam = request.getParameter("intraoralExam");
        String provisionalDiagnosis = request.getParameter("provisionalDiagnosis");
        String finalDiagnosis = request.getParameter("finalDiagnosis");
        String clinicalNotes = request.getParameter("clinicalNotes");

        ClinicalExamination exam = new ClinicalExamination();
        exam.setVisitId(visit.getVisitId());
        exam.setChiefComplaint(chiefComplaint);
        exam.setExtraoralExam(extraoralExam);
        exam.setIntraoralExam(intraoralExam);
        exam.setProvisionalDiagnosis(provisionalDiagnosis);
        exam.setFinalDiagnosis(finalDiagnosis);
        exam.setClinicalNotes(clinicalNotes);

        clinicalService.recordClinicalExamination(exam);
    }
}

package com.dcms.service;

import com.dcms.dao.ClinicalExaminationDAO;
import com.dcms.dao.DentalAttachmentDAO;
import com.dcms.dao.PreTreatmentAssessmentDAO;
import com.dcms.dao.ToothFindingDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.ClinicalExamination;
import com.dcms.model.DentalAttachment;
import com.dcms.model.PreTreatmentAssessment;
import com.dcms.model.ToothFinding;
import com.dcms.model.Visit;

import java.util.List;

/**
 * Service orchestrating clinical intake, pre-treatment vitals,
 * dental examination, odontogram chart findings, and clinical attachments (BF-02).
 */
public class ClinicalService {

    private final VisitDAO visitDAO;
    private final PreTreatmentAssessmentDAO assessmentDAO;
    private final ToothFindingDAO toothFindingDAO;
    private final ClinicalExaminationDAO examinationDAO;
    private final DentalAttachmentDAO attachmentDAO;

    public ClinicalService() {
        this(new VisitDAO(), new PreTreatmentAssessmentDAO(), new ToothFindingDAO(), new ClinicalExaminationDAO(), new DentalAttachmentDAO());
    }

    public ClinicalService(VisitDAO visitDAO,
                           PreTreatmentAssessmentDAO assessmentDAO,
                           ToothFindingDAO toothFindingDAO,
                           ClinicalExaminationDAO examinationDAO,
                           DentalAttachmentDAO attachmentDAO) {
        this.visitDAO = visitDAO;
        this.assessmentDAO = assessmentDAO;
        this.toothFindingDAO = toothFindingDAO;
        this.examinationDAO = examinationDAO;
        this.attachmentDAO = attachmentDAO;
    }

    // 1. Visit Status & Operatory Assignment
    public boolean startExamination(int visitId, String operatory) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã lượt khám không hợp lệ.");
        }
        if (operatory != null && !operatory.trim().isEmpty()) {
            visitDAO.updateOperatory(visitId, operatory.trim());
        }
        return visitDAO.updateStatus(visitId, Visit.STATUS_IN_PROGRESS);
    }

    public boolean completeExamination(int visitId) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã lượt khám không hợp lệ.");
        }
        return visitDAO.updateStatus(visitId, Visit.STATUS_COMPLETED);
    }

    public boolean assignOperatory(int visitId, String operatory) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã lượt khám không hợp lệ.");
        }
        return visitDAO.updateOperatory(visitId, operatory);
    }

    public Visit getVisitById(int visitId) {
        return visitDAO.findById(visitId);
    }

    public List<Visit> getPatientVisitHistory(int patientId) {
        return visitDAO.findVisitsByPatientId(patientId);
    }

    // 2. Pre-Treatment Assessment & Vitals
    public int recordPreTreatmentAssessment(PreTreatmentAssessment assessment) {
        if (assessment == null) {
            throw new IllegalArgumentException("Dữ liệu đánh giá tiền thủ thuật không được để trống.");
        }
        if (assessment.getVisitId() <= 0 || assessment.getPatientId() <= 0) {
            throw new IllegalArgumentException("Mã lượt khám hoặc mã bệnh nhân không hợp lệ.");
        }
        return assessmentDAO.createOrUpdate(assessment);
    }

    public PreTreatmentAssessment getPreTreatmentAssessment(int visitId) {
        return assessmentDAO.findByVisitId(visitId);
    }

    // 3. Dental Chart & Tooth Findings (Odontogram)
    public int recordToothFinding(ToothFinding finding) {
        if (finding == null) {
            throw new IllegalArgumentException("Dữ liệu răng không được để trống.");
        }
        if (finding.getToothNumber() < 11 || finding.getToothNumber() > 48) {
            throw new IllegalArgumentException("Số hiệu răng phải theo chuẩn FDI (11 đến 48).");
        }
        return toothFindingDAO.create(finding);
    }

    public List<ToothFinding> getToothFindingsByPatient(int patientId) {
        return toothFindingDAO.findByPatientId(patientId);
    }

    public List<ToothFinding> getToothFindingsByVisit(int visitId) {
        return toothFindingDAO.findByVisitId(visitId);
    }

    public boolean removeToothFinding(int findingId) {
        return toothFindingDAO.deleteByFindingId(findingId);
    }

    // 4. Clinical Examination & Diagnoses
    public int recordClinicalExamination(ClinicalExamination exam) {
        if (exam == null) {
            throw new IllegalArgumentException("Dữ liệu khám lâm sàng không được để trống.");
        }
        if (exam.getVisitId() <= 0) {
            throw new IllegalArgumentException("Mã lượt khám không hợp lệ.");
        }
        return examinationDAO.createOrUpdate(exam);
    }

    public ClinicalExamination getClinicalExamination(int visitId) {
        return examinationDAO.findByVisitId(visitId);
    }

    // 5. Dental Attachments & Images
    public int addAttachment(DentalAttachment attachment) {
        if (attachment == null) {
            throw new IllegalArgumentException("Dữ liệu file đính kèm không được để trống.");
        }
        if (attachment.getPatientId() <= 0 || attachment.getFileName() == null || attachment.getFilePath() == null) {
            throw new IllegalArgumentException("Thông tin file đính kèm không đầy đủ.");
        }
        return attachmentDAO.create(attachment);
    }

    public List<DentalAttachment> getAttachmentsByPatient(int patientId) {
        return attachmentDAO.findByPatientId(patientId);
    }

    public List<DentalAttachment> getAttachmentsByVisit(int visitId) {
        return attachmentDAO.findByVisitId(visitId);
    }

    public boolean removeAttachment(int attachmentId) {
        return attachmentDAO.deleteById(attachmentId);
    }
}

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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ClinicalServiceTest {

    @Mock
    private VisitDAO visitDAO;

    @Mock
    private PreTreatmentAssessmentDAO assessmentDAO;

    @Mock
    private ToothFindingDAO toothFindingDAO;

    @Mock
    private ClinicalExaminationDAO examinationDAO;

    @Mock
    private DentalAttachmentDAO attachmentDAO;

    private ClinicalService clinicalService;

    @BeforeEach
    public void setUp() {
        clinicalService = new ClinicalService(visitDAO, assessmentDAO, toothFindingDAO, examinationDAO, attachmentDAO);
    }

    @Test
    @DisplayName("TC_CLINICAL_01: Start examination assigns operatory chair and sets InProgress status")
    public void testStartExaminationWithOperatory() {
        when(visitDAO.updateOperatory(101, "Ghế 1 - P.101")).thenReturn(true);
        when(visitDAO.updateStatus(101, Visit.STATUS_IN_PROGRESS)).thenReturn(true);

        boolean success = clinicalService.startExamination(101, "Ghế 1 - P.101");

        assertTrue(success);
        verify(visitDAO).updateOperatory(101, "Ghế 1 - P.101");
        verify(visitDAO).updateStatus(101, Visit.STATUS_IN_PROGRESS);
    }

    @Test
    @DisplayName("TC_CLINICAL_02: Complete examination transitions visit to Completed")
    public void testCompleteExamination() {
        when(visitDAO.updateStatus(101, Visit.STATUS_COMPLETED)).thenReturn(true);

        boolean success = clinicalService.completeExamination(101);

        assertTrue(success);
        verify(visitDAO).updateStatus(101, Visit.STATUS_COMPLETED);
    }

    @Test
    @DisplayName("TC_CLINICAL_03: Record Pre-treatment Assessment saves vitals, bleeding risk, and medical clearance")
    public void testRecordPreTreatmentAssessment() {
        PreTreatmentAssessment assessment = new PreTreatmentAssessment();
        assessment.setVisitId(101);
        assessment.setPatientId(5);
        assessment.setBloodPressure("120/80");
        assessment.setPulse(72);
        assessment.setBloodSugar(new BigDecimal("5.5"));
        assessment.setBleedingRisk("Low");
        assessment.setMedicalClearance(true);

        when(assessmentDAO.createOrUpdate(assessment)).thenReturn(1);

        int result = clinicalService.recordPreTreatmentAssessment(assessment);

        assertEquals(1, result);
        verify(assessmentDAO).createOrUpdate(assessment);
    }

    @Test
    @DisplayName("TC_CLINICAL_04: Pre-treatment Assessment throws exception if visitId or patientId is invalid")
    public void testRecordPreTreatmentAssessmentInvalidIds() {
        PreTreatmentAssessment assessment = new PreTreatmentAssessment();
        assessment.setVisitId(0);
        assessment.setPatientId(5);

        assertThrows(IllegalArgumentException.class, () -> {
            clinicalService.recordPreTreatmentAssessment(assessment);
        });
    }

    @Test
    @DisplayName("TC_CLINICAL_05: Record Tooth Finding with FDI 11-48 notation and 5 surfaces (Rule 5)")
    public void testRecordToothFindingFdiValid() {
        ToothFinding finding = new ToothFinding();
        finding.setPatientId(5);
        finding.setVisitId(101);
        finding.setToothNumber(36); // FDI lower-left 1st molar
        finding.setSurface("Occlusal");
        finding.setCondition(ToothFinding.COND_CARIES);

        when(toothFindingDAO.create(finding)).thenReturn(201);

        int findingId = clinicalService.recordToothFinding(finding);

        assertEquals(201, findingId);
        verify(toothFindingDAO).create(finding);
    }

    @Test
    @DisplayName("TC_CLINICAL_06: Invariant rejection: Tooth number outside FDI standard 11-48 (Rule 5)")
    public void testRecordToothFindingInvalidToothNumber() {
        ToothFinding finding = new ToothFinding();
        finding.setPatientId(5);
        finding.setVisitId(101);
        finding.setToothNumber(99); // Invalid tooth number!
        finding.setCondition(ToothFinding.COND_CARIES);

        assertThrows(IllegalArgumentException.class, () -> {
            clinicalService.recordToothFinding(finding);
        }, "Must enforce FDI 11-48 notation");
    }

    @Test
    @DisplayName("TC_CLINICAL_07: Record Clinical Examination with Chief Complaint, extraoral, intraoral, diagnoses")
    public void testRecordClinicalExamination() {
        ClinicalExamination exam = new ClinicalExamination();
        exam.setVisitId(101);
        exam.setChiefComplaint("Đau buốt R36");
        exam.setExtraoralExam("Bình thường, không sưng");
        exam.setIntraoralExam("Sâu mặt nhai R36");
        exam.setProvisionalDiagnosis("Viêm tủy cấp R36");
        exam.setFinalDiagnosis("Sâu răng K02.1 R36");

        when(examinationDAO.createOrUpdate(exam)).thenReturn(1);

        int result = clinicalService.recordClinicalExamination(exam);

        assertEquals(1, result);
        verify(examinationDAO).createOrUpdate(exam);
    }

    @Test
    @DisplayName("TC_CLINICAL_08: Add Dental Attachment (X-ray / Intraoral image) successfully")
    public void testAddDentalAttachment() {
        DentalAttachment attachment = new DentalAttachment();
        attachment.setPatientId(5);
        attachment.setVisitId(101);
        attachment.setFileType(DentalAttachment.TYPE_XRAY);
        attachment.setFileName("xray_r36.png");
        attachment.setFilePath("assets/images/xrays/xray_r36.png");

        when(attachmentDAO.create(attachment)).thenReturn(301);

        int attachmentId = clinicalService.addAttachment(attachment);

        assertEquals(301, attachmentId);
        verify(attachmentDAO).create(attachment);
    }
}

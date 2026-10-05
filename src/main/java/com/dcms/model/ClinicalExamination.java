package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * ClinicalExamination entity representing dentist examination findings,
 * complaints, and diagnoses recorded during a visit (BF-02).
 */
public class ClinicalExamination implements Serializable {
    private static final long serialVersionUID = 1L;

    private int examinationId;
    private int visitId;
    private String chiefComplaint;
    private String extraoralExam;
    private String intraoralExam;
    private String provisionalDiagnosis;
    private String finalDiagnosis;
    private String clinicalNotes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public ClinicalExamination() {
        this.createdAt = LocalDateTime.now();
    }

    public int getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(int examinationId) {
        this.examinationId = examinationId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public String getChiefComplaint() {
        return chiefComplaint;
    }

    public void setChiefComplaint(String chiefComplaint) {
        this.chiefComplaint = chiefComplaint;
    }

    public String getExtraoralExam() {
        return extraoralExam;
    }

    public void setExtraoralExam(String extraoralExam) {
        this.extraoralExam = extraoralExam;
    }

    public String getIntraoralExam() {
        return intraoralExam;
    }

    public void setIntraoralExam(String intraoralExam) {
        this.intraoralExam = intraoralExam;
    }

    public String getProvisionalDiagnosis() {
        return provisionalDiagnosis;
    }

    public void setProvisionalDiagnosis(String provisionalDiagnosis) {
        this.provisionalDiagnosis = provisionalDiagnosis;
    }

    public String getFinalDiagnosis() {
        return finalDiagnosis;
    }

    public void setFinalDiagnosis(String finalDiagnosis) {
        this.finalDiagnosis = finalDiagnosis;
    }

    public String getClinicalNotes() {
        return clinicalNotes;
    }

    public void setClinicalNotes(String clinicalNotes) {
        this.clinicalNotes = clinicalNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

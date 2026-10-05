package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * PreTreatmentAssessment entity representing patient vitals and safety clearance
 * prior to dental examination or procedures (BF-02).
 */
public class PreTreatmentAssessment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int assessmentId;
    private int visitId;
    private int patientId;
    private String bloodPressure;   // e.g. "120/80"
    private Integer pulseRate;       // bpm e.g. 75
    private BigDecimal bloodSugar;   // mmol/L e.g. 5.4
    private String bleedingRisk;     // "Bình thường", "Thấp", "Trung bình", "Cao"
    private String anxietyLevel;     // "Thấp", "Vừa", "Rất sợ"
    private boolean medicalClearance;// true = Đủ điều kiện, false = Tạm hoãn
    private String notes;
    private LocalDateTime recordedAt;

    public PreTreatmentAssessment() {
        this.bleedingRisk = "Bình thường";
        this.anxietyLevel = "Thấp";
        this.medicalClearance = true;
        this.recordedAt = LocalDateTime.now();
    }

    public int getAssessmentId() {
        return assessmentId;
    }

    public void setAssessmentId(int assessmentId) {
        this.assessmentId = assessmentId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getBloodPressure() {
        return bloodPressure;
    }

    public void setBloodPressure(String bloodPressure) {
        this.bloodPressure = bloodPressure;
    }

    public Integer getPulseRate() {
        return pulseRate;
    }

    public void setPulseRate(Integer pulseRate) {
        this.pulseRate = pulseRate;
    }

    public BigDecimal getBloodSugar() {
        return bloodSugar;
    }

    public void setBloodSugar(BigDecimal bloodSugar) {
        this.bloodSugar = bloodSugar;
    }

    public String getBleedingRisk() {
        return bleedingRisk;
    }

    public void setBleedingRisk(String bleedingRisk) {
        this.bleedingRisk = bleedingRisk;
    }

    public String getAnxietyLevel() {
        return anxietyLevel;
    }

    public void setAnxietyLevel(String anxietyLevel) {
        this.anxietyLevel = anxietyLevel;
    }

    public boolean isMedicalClearance() {
        return medicalClearance;
    }

    public void setMedicalClearance(boolean medicalClearance) {
        this.medicalClearance = medicalClearance;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(LocalDateTime recordedAt) {
        this.recordedAt = recordedAt;
    }

    public Integer getPulse() {
        return pulseRate;
    }

    public void setPulse(Integer pulse) {
        this.pulseRate = pulse;
    }

    public String getAssessmentNotes() {
        return notes;
    }

    public void setAssessmentNotes(String assessmentNotes) {
        this.notes = assessmentNotes;
    }

    private Integer assessedBy;

    public Integer getAssessedBy() {
        return assessedBy;
    }

    public void setAssessedBy(int assessedBy) {
        this.assessedBy = assessedBy;
    }
}

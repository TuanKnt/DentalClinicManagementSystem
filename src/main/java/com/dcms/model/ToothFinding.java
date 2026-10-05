package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * ToothFinding entity representing a diagnosed condition on a specific tooth
 * and surface according to FDI Two-Digit Notation (11..48) and 5 Surfaces (BF-02).
 */
public class ToothFinding implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String SURFACE_OCCLUSAL = "Occlusal";
    public static final String SURFACE_MESIAL = "Mesial";
    public static final String SURFACE_DISTAL = "Distal";
    public static final String SURFACE_BUCCAL = "Buccal";
    public static final String SURFACE_LINGUAL = "Lingual";
    public static final String SURFACE_WHOLE_TOOTH = "WholeTooth";

    public static final String CONDITION_CARIES = "Caries";       // Sâu răng
    public static final String COND_CARIES = CONDITION_CARIES;
    public static final String CONDITION_MISSING = "Missing";     // Mất răng
    public static final String CONDITION_FILLED = "Filled";       // Đã trám
    public static final String CONDITION_CROWN = "Crown";         // Bọc răng sứ
    public static final String CONDITION_ROOT_CANAL = "RootCanal";// Điều trị tủy
    public static final String CONDITION_HEALTHY = "Healthy";     // Răng khỏe mạnh

    private int findingId;
    private int patientId;
    private int visitId;
    private int toothNumber; // 11-18, 21-28, 31-38, 41-48
    private String surface;  // Occlusal, Mesial, Distal, Buccal, Lingual, WholeTooth
    private String condition;// Caries, Missing, Filled, Crown, RootCanal, Healthy
    private String notes;
    private Integer recordedBy;
    private LocalDateTime recordedAt;

    public Integer getRecordedBy() {
        return recordedBy;
    }

    public void setRecordedBy(Integer recordedBy) {
        this.recordedBy = recordedBy;
    }

    public ToothFinding() {
        this.surface = SURFACE_WHOLE_TOOTH;
        this.condition = CONDITION_HEALTHY;
        this.recordedAt = LocalDateTime.now();
    }

    public ToothFinding(int patientId, int visitId, int toothNumber, String surface, String condition, String notes) {
        this.patientId = patientId;
        this.visitId = visitId;
        this.toothNumber = toothNumber;
        this.surface = surface != null ? surface : SURFACE_WHOLE_TOOTH;
        this.condition = condition != null ? condition : CONDITION_HEALTHY;
        this.notes = notes;
        this.recordedAt = LocalDateTime.now();
    }

    public int getFindingId() {
        return findingId;
    }

    public void setFindingId(int findingId) {
        this.findingId = findingId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getToothNumber() {
        return toothNumber;
    }

    public void setToothNumber(int toothNumber) {
        this.toothNumber = toothNumber;
    }

    public String getSurface() {
        return surface;
    }

    public void setSurface(String surface) {
        this.surface = surface;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
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

    public LocalDateTime getCreatedAt() {
        return recordedAt;
    }

    public void setRecordedAt(LocalDateTime recordedAt) {
        this.recordedAt = recordedAt;
    }
}

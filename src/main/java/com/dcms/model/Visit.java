package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Visit entity representing actual patient encounter at the clinic.
 * NON-NEGOTIABLE RULE: Appointment != Visit.
 * A Walk-in Visit has appointmentId = null.
 */
public class Visit implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_WAITING = "Waiting";
    public static final String STATUS_IN_PROGRESS = "InProgress";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_CANCELLED = "Cancelled";

    public static final String TYPE_SCHEDULED = "Scheduled";
    public static final String TYPE_WALK_IN = "WalkIn";
    public static final String TYPE_EMERGENCY = "Emergency";

    private int visitId;
    private int patientId;
    private int primaryDentistId;
    private Integer appointmentId; // NULLABLE for Walk-in / Emergency encounters
    private LocalDateTime checkInTime;
    private LocalDateTime checkOutTime;
    private String status;    // Waiting, InProgress, Completed, Cancelled
    private String visitType; // Scheduled, WalkIn, Emergency
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient joined presentation fields
    private String patientName;
    private String patientPhone;
    private String medicalAlerts;
    private String allergies;
    private String dentistName;

    public Visit() {
        this.status = STATUS_WAITING;
        this.visitType = TYPE_SCHEDULED;
    }

    public Visit(int visitId, int patientId, int primaryDentistId, Integer appointmentId, String visitType) {
        this.visitId = visitId;
        this.patientId = patientId;
        this.primaryDentistId = primaryDentistId;
        this.appointmentId = appointmentId;
        this.visitType = visitType;
        this.status = STATUS_WAITING;
        this.checkInTime = LocalDateTime.now();
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

    public int getPrimaryDentistId() {
        return primaryDentistId;
    }

    public void setPrimaryDentistId(int primaryDentistId) {
        this.primaryDentistId = primaryDentistId;
    }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }

    public LocalDateTime getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(LocalDateTime checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVisitType() {
        return visitType;
    }

    public void setVisitType(String visitType) {
        this.visitType = visitType;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientPhone() {
        return patientPhone;
    }

    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }

    public String getMedicalAlerts() {
        return medicalAlerts;
    }

    public void setMedicalAlerts(String medicalAlerts) {
        this.medicalAlerts = medicalAlerts;
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public boolean isWalkIn() {
        return this.appointmentId == null;
    }

    @Override
    public String toString() {
        return "Visit{" +
                "visitId=" + visitId +
                ", patientId=" + patientId +
                ", appointmentId=" + appointmentId +
                ", status='" + status + '\'' +
                ", type='" + visitType + '\'' +
                '}';
    }
}

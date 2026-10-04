package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * Appointment represents a scheduled intent to visit the clinic.
 * NON-NEGOTIABLE RULE: Appointment != Visit.
 */
public class Appointment implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_CONFIRMED = "Confirmed";
    public static final String STATUS_ARRIVED = "Arrived";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_CANCELLED = "Cancelled";
    public static final String STATUS_NOSHOW = "NoShow";

    private int appointmentId;
    private int patientId;
    private int dentistId;
    private LocalDate appointmentDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String reason;
    private String status; // Pending, Confirmed, Arrived, Completed, Cancelled, NoShow
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient joined presentation fields
    private String patientName;
    private String patientPhone;
    private String dentistName;

    public Appointment() {
        this.status = STATUS_PENDING;
    }

    public Appointment(int appointmentId, int patientId, int dentistId, LocalDate appointmentDate, LocalTime startTime, LocalTime endTime, String reason) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.appointmentDate = appointmentDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.reason = reason;
        this.status = STATUS_PENDING;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public LocalDate getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(LocalDate appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public boolean canBeCheckedIn() {
        return STATUS_PENDING.equalsIgnoreCase(this.status) || STATUS_CONFIRMED.equalsIgnoreCase(this.status);
    }

    public boolean canBeCancelled() {
        return !STATUS_ARRIVED.equalsIgnoreCase(this.status) &&
               !STATUS_COMPLETED.equalsIgnoreCase(this.status) &&
               !STATUS_CANCELLED.equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId=" + appointmentId +
                ", patientId=" + patientId +
                ", dentistId=" + dentistId +
                ", date=" + appointmentDate +
                ", time=" + startTime + "-" + endTime +
                ", status='" + status + '\'' +
                '}';
    }
}

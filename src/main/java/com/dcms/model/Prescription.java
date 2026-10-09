package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model representing an Electronic Prescription (Prescriptions table).
 * (UC27, UC28) - Managed by Kiên (Prescriptions & Pharmacy).
 */
public class Prescription implements Serializable {
    private static final long serialVersionUID = 1L;

    private int prescriptionId;
    private int visitId;
    private int patientId;
    private int dentistId;
    private String prescriptionCode;
    private String diagnosis;
    private String advice;
    private String status; // Draft, Issued, Cancelled
    private Timestamp issuedAt;

    // Joined fields for display & print
    private String patientName;
    private String patientPhone;
    private String patientGender;
    private String patientDob;
    private String patientAddress;
    private String patientAllergies;
    private String dentistName;
    private String dentistLicense;
    private Timestamp checkInTime;

    private List<PrescriptionItem> items = new ArrayList<>();

    public Prescription() {
        this.status = "Issued";
    }

    public Prescription(int prescriptionId, int visitId, int patientId, int dentistId,
                        String prescriptionCode, String diagnosis, String advice,
                        String status, Timestamp issuedAt) {
        this.prescriptionId = prescriptionId;
        this.visitId = visitId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.prescriptionCode = prescriptionCode;
        this.diagnosis = diagnosis;
        this.advice = advice;
        this.status = status;
        this.issuedAt = issuedAt;
    }

    public BigDecimal getTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        if (items != null) {
            for (PrescriptionItem it : items) {
                total = total.add(it.getLineTotal());
            }
        }
        return total;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
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

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public String getPrescriptionCode() {
        return prescriptionCode;
    }

    public void setPrescriptionCode(String prescriptionCode) {
        this.prescriptionCode = prescriptionCode;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getAdvice() {
        return advice;
    }

    public void setAdvice(String advice) {
        this.advice = advice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(Timestamp issuedAt) {
        this.issuedAt = issuedAt;
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

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }

    public String getPatientDob() {
        return patientDob;
    }

    public void setPatientDob(String patientDob) {
        this.patientDob = patientDob;
    }

    public String getPatientAddress() {
        return patientAddress;
    }

    public void setPatientAddress(String patientAddress) {
        this.patientAddress = patientAddress;
    }

    public String getPatientAllergies() {
        return patientAllergies;
    }

    public void setPatientAllergies(String patientAllergies) {
        this.patientAllergies = patientAllergies;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getDentistLicense() {
        return dentistLicense;
    }

    public void setDentistLicense(String dentistLicense) {
        this.dentistLicense = dentistLicense;
    }

    public Timestamp getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Timestamp checkInTime) {
        this.checkInTime = checkInTime;
    }

    public List<PrescriptionItem> getItems() {
        return items;
    }

    public void setItems(List<PrescriptionItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "Prescription{" +
                "prescriptionId=" + prescriptionId +
                ", prescriptionCode='" + prescriptionCode + '\'' +
                ", patientId=" + patientId +
                ", dentistId=" + dentistId +
                ", status='" + status + '\'' +
                '}';
    }
}

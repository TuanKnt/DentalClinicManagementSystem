package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Patient entity representing a dental clinic patient.
 */
public class Patient implements Serializable {
    private static final long serialVersionUID = 1L;

    private int patientId;
    private String fullName;
    private LocalDate dob;
    private String gender; // 'Nam', 'Nữ', 'Khác'
    private String phone;
    private String citizenId;
    private String email;
    private String address;
    private String medicalAlerts; // E.g. Hypertension, Diabetes, Hemophilia
    private String allergies;     // E.g. Lidocaine, Penicillin
    private String emergencyContact;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Patient() {
    }

    public Patient(int patientId, String fullName, LocalDate dob, String gender, String phone, String citizenId, String address) {
        this.patientId = patientId;
        this.fullName = fullName;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.citizenId = citizenId;
        this.address = address;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getDob() {
        return dob;
    }

    public LocalDate getDateOfBirth() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dob = dateOfBirth;
    }

    public String getPhoneNumber() {
        return phone;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phone = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(String citizenId) {
        this.citizenId = citizenId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public String getEmergencyContact() {
        return emergencyContact;
    }

    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
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

    @Override
    public String toString() {
        return "Patient{" +
                "patientId=" + patientId +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", gender='" + gender + '\'' +
                '}';
    }
}

package com.dcms.model;

import java.io.Serializable;

/**
 * Dentist entity representing clinical dental doctor profile.
 */
public class Dentist implements Serializable {
    private static final long serialVersionUID = 1L;

    private int dentistId;
    private String licenseNumber;
    private String specialization;
    private String roomNumber;
    private String fullName; // Joined from Users
    private String phone;    // Joined from Users

    public Dentist() {
    }

    public Dentist(int dentistId, String licenseNumber, String specialization, String roomNumber) {
        this.dentistId = dentistId;
        this.licenseNumber = licenseNumber;
        this.specialization = specialization;
        this.roomNumber = roomNumber;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "Dentist{" +
                "dentistId=" + dentistId +
                ", fullName='" + fullName + '\'' +
                ", specialization='" + specialization + '\'' +
                '}';
    }
}

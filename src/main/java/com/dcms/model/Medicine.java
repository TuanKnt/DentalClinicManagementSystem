package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model representing a Medicine in the clinic catalog (UC27, UC40).
 * Part of Iteration 2 (Kiên - Pharmacy & E-Prescriptions).
 */
public class Medicine implements Serializable {
    private static final long serialVersionUID = 1L;

    private int medicineId;
    private String medicineCode;
    private String medicineName;
    private String activeIngredient;
    private String dosageForm;
    private String unit;
    private BigDecimal unitPrice;
    private String usageInstructions;
    private boolean isActive;
    private Timestamp createdAt;

    public Medicine() {
        this.unitPrice = BigDecimal.ZERO;
        this.dosageForm = "Viên";
        this.unit = "Viên";
        this.isActive = true;
    }

    public Medicine(int medicineId, String medicineCode, String medicineName, String activeIngredient,
                    String dosageForm, String unit, BigDecimal unitPrice, String usageInstructions,
                    boolean isActive, Timestamp createdAt) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.medicineName = medicineName;
        this.activeIngredient = activeIngredient;
        this.dosageForm = dosageForm;
        this.unit = unit;
        this.unitPrice = unitPrice != null ? unitPrice : BigDecimal.ZERO;
        this.usageInstructions = usageInstructions;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineCode() {
        return medicineCode;
    }

    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getActiveIngredient() {
        return activeIngredient;
    }

    public void setActiveIngredient(String activeIngredient) {
        this.activeIngredient = activeIngredient;
    }

    public String getDosageForm() {
        return dosageForm;
    }

    public void setDosageForm(String dosageForm) {
        this.dosageForm = dosageForm;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUsageInstructions() {
        return usageInstructions;
    }

    public void setUsageInstructions(String usageInstructions) {
        this.usageInstructions = usageInstructions;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Medicine{" +
                "medicineId=" + medicineId +
                ", medicineCode='" + medicineCode + '\'' +
                ", medicineName='" + medicineName + '\'' +
                ", unitPrice=" + unitPrice +
                ", isActive=" + isActive +
                '}';
    }
}

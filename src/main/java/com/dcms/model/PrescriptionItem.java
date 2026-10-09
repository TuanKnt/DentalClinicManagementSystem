package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Model representing an item in an E-Prescription (PrescriptionDetails table).
 * (UC27, UC28) - Managed by Kiên (Prescriptions & Pharmacy).
 */
public class PrescriptionItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int detailId;
    private int prescriptionId;
    private int medicineId;
    private int quantity;
    private String dosage;
    private int durationDays;
    private String notes;

    // Joined fields from Medicines table
    private String medicineCode;
    private String medicineName;
    private String activeIngredient;
    private String unit;
    private BigDecimal unitPrice;

    public PrescriptionItem() {
        this.quantity = 1;
        this.durationDays = 5;
        this.unitPrice = BigDecimal.ZERO;
        this.unit = "Viên";
    }

    public PrescriptionItem(int detailId, int prescriptionId, int medicineId, int quantity,
                            String dosage, int durationDays, String notes) {
        this.detailId = detailId;
        this.prescriptionId = prescriptionId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.dosage = dosage;
        this.durationDays = durationDays;
        this.notes = notes;
        this.unitPrice = BigDecimal.ZERO;
    }

    public BigDecimal getLineTotal() {
        if (unitPrice == null || quantity <= 0) {
            return BigDecimal.ZERO;
        }
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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
}

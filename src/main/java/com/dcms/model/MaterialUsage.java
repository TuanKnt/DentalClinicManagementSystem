package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entity representing consumable dental materials used during a clinical procedure (UC26).
 */
public class MaterialUsage implements Serializable {
    private static final long serialVersionUID = 1L;

    private int usageId;
    private int procedureId;
    private String materialName;
    private int quantity;
    private String unit;
    private String notes;
    private LocalDateTime recordedAt;

    public MaterialUsage() {
        this.quantity = 1;
        this.unit = "Ống";
    }

    public MaterialUsage(int procedureId, String materialName, int quantity, String unit, String notes) {
        this();
        this.procedureId = procedureId;
        this.materialName = materialName;
        this.quantity = quantity > 0 ? quantity : 1;
        this.unit = (unit != null && !unit.trim().isEmpty()) ? unit.trim() : "Ống";
        this.notes = notes;
    }

    public int getUsageId() {
        return usageId;
    }

    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }

    public int getProcedureId() {
        return procedureId;
    }

    public void setProcedureId(int procedureId) {
        this.procedureId = procedureId;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity > 0 ? quantity : 1;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
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
}

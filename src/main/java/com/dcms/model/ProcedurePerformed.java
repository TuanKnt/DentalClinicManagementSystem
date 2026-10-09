package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Entity representing an actual Clinical Procedure Performed at the dental chair (UC24, UC25, UC18).
 * NON-NEGOTIABLE DOMAIN RULES:
 * 1. TreatmentPlanItem != ProcedurePerformed (Iron Rule 2).
 * 2. Invoices are ONLY generated from completed ProcedurePerformed records (Iron Rule 3).
 */
public class ProcedurePerformed implements Serializable {
    private static final long serialVersionUID = 1L;

    private int procedureId;
    private int visitId;
    private int dentistId;
    private Integer assistantId;
    private Integer planItemId;
    private int serviceId;
    private Integer toothNumber;
    private String surface;
    private int quantity;
    private BigDecimal actualPrice;
    private String status; // 'InProgress', 'Completed', 'Voided'
    private String clinicalNotes;
    private LocalDateTime performedAt;

    // Joined fields for display
    private String serviceCode;
    private String serviceName;
    private String serviceUnit;
    private String dentistName;
    private String assistantName;
    private String patientName;
    private List<MaterialUsage> materials;

    public ProcedurePerformed() {
        this.quantity = 1;
        this.actualPrice = BigDecimal.ZERO;
        this.status = "InProgress";
        this.materials = new ArrayList<>();
    }

    public ProcedurePerformed(int visitId, int dentistId, Integer assistantId, Integer planItemId,
                              int serviceId, Integer toothNumber, String surface, int quantity,
                              BigDecimal actualPrice, String clinicalNotes) {
        this();
        this.visitId = visitId;
        this.dentistId = dentistId;
        this.assistantId = assistantId;
        this.planItemId = planItemId;
        this.serviceId = serviceId;
        this.toothNumber = toothNumber;
        this.surface = (surface != null && !surface.trim().isEmpty()) ? surface.trim() : "WholeTooth";
        this.quantity = quantity > 0 ? quantity : 1;
        this.actualPrice = actualPrice != null ? actualPrice : BigDecimal.ZERO;
        this.clinicalNotes = clinicalNotes;
    }

    public int getProcedureId() {
        return procedureId;
    }

    public void setProcedureId(int procedureId) {
        this.procedureId = procedureId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public Integer getAssistantId() {
        return assistantId;
    }

    public void setAssistantId(Integer assistantId) {
        this.assistantId = assistantId;
    }

    public Integer getPlanItemId() {
        return planItemId;
    }

    public void setPlanItemId(Integer planItemId) {
        this.planItemId = planItemId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getToothNumber() {
        return toothNumber;
    }

    public void setToothNumber(Integer toothNumber) {
        this.toothNumber = toothNumber;
    }

    public String getSurface() {
        return surface;
    }

    public void setSurface(String surface) {
        this.surface = surface;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity > 0 ? quantity : 1;
    }

    public BigDecimal getActualPrice() {
        return actualPrice;
    }

    public void setActualPrice(BigDecimal actualPrice) {
        this.actualPrice = actualPrice != null ? actualPrice : BigDecimal.ZERO;
    }

    public BigDecimal getSubTotal() {
        if (actualPrice == null) return BigDecimal.ZERO;
        return actualPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getClinicalNotes() {
        return clinicalNotes;
    }

    public void setClinicalNotes(String clinicalNotes) {
        this.clinicalNotes = clinicalNotes;
    }

    public LocalDateTime getPerformedAt() {
        return performedAt;
    }

    public void setPerformedAt(LocalDateTime performedAt) {
        this.performedAt = performedAt;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceUnit() {
        return serviceUnit;
    }

    public void setServiceUnit(String serviceUnit) {
        this.serviceUnit = serviceUnit;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getAssistantName() {
        return assistantName;
    }

    public void setAssistantName(String assistantName) {
        this.assistantName = assistantName;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public List<MaterialUsage> getMaterials() {
        return materials;
    }

    public void setMaterials(List<MaterialUsage> materials) {
        this.materials = materials != null ? materials : new ArrayList<>();
    }

    public String getFormattedPrice() {
        return formatCurrency(actualPrice);
    }

    public String getFormattedSubTotal() {
        return formatCurrency(getSubTotal());
    }

    private String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(amount) + " đ";
    }

    public String getStatusDisplayName() {
        if (status == null) return "Đang làm";
        return switch (status) {
            case "InProgress" -> "Đang thực hiện";
            case "Completed" -> "Đã hoàn thành";
            case "Voided" -> "Đã hủy bỏ";
            default -> status;
        };
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-warning";
        return switch (status) {
            case "InProgress" -> "badge-warning";
            case "Completed" -> "badge-success";
            case "Voided" -> "badge-danger";
            default -> "badge-secondary";
        };
    }
}

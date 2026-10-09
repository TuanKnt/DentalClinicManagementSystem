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
 * Entity representing a multi-visit Dental Treatment Plan (UC19, UC21, UC23).
 */
public class TreatmentPlan implements Serializable {
    private static final long serialVersionUID = 1L;

    private int planId;
    private int patientId;
    private int dentistId;
    private String title;
    private String diagnosis;
    private String status; // Draft, Proposed, Accepted, PartiallyAccepted, InProgress, Completed, Declined, Cancelled
    private BigDecimal estimatedCost;
    private BigDecimal totalDiscount;
    private BigDecimal finalEstimate;
    private LocalDateTime patientConsentDate;
    private String consentNotes;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Joined information for UI rendering
    private String patientName;
    private String patientPhone;
    private String patientGender;
    private String dentistName;
    private String dentistSpecialization;
    private List<TreatmentPlanItem> items;

    public TreatmentPlan() {
        this.status = "Draft";
        this.estimatedCost = BigDecimal.ZERO;
        this.totalDiscount = BigDecimal.ZERO;
        this.finalEstimate = BigDecimal.ZERO;
        this.items = new ArrayList<>();
    }

    public TreatmentPlan(int planId, int patientId, int dentistId, String title, String diagnosis, String status) {
        this();
        this.planId = planId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.title = title;
        this.diagnosis = diagnosis;
        this.status = status != null ? status : "Draft";
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(BigDecimal estimatedCost) {
        this.estimatedCost = estimatedCost != null ? estimatedCost : BigDecimal.ZERO;
    }

    public BigDecimal getTotalDiscount() {
        return totalDiscount;
    }

    public void setTotalDiscount(BigDecimal totalDiscount) {
        this.totalDiscount = totalDiscount != null ? totalDiscount : BigDecimal.ZERO;
    }

    public BigDecimal getFinalEstimate() {
        return finalEstimate;
    }

    public void setFinalEstimate(BigDecimal finalEstimate) {
        this.finalEstimate = finalEstimate != null ? finalEstimate : BigDecimal.ZERO;
    }

    public LocalDateTime getPatientConsentDate() {
        return patientConsentDate;
    }

    public void setPatientConsentDate(LocalDateTime patientConsentDate) {
        this.patientConsentDate = patientConsentDate;
    }

    public String getConsentNotes() {
        return consentNotes;
    }

    public void setConsentNotes(String consentNotes) {
        this.consentNotes = consentNotes;
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

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getDentistSpecialization() {
        return dentistSpecialization;
    }

    public void setDentistSpecialization(String dentistSpecialization) {
        this.dentistSpecialization = dentistSpecialization;
    }

    public List<TreatmentPlanItem> getItems() {
        return items;
    }

    public void setItems(List<TreatmentPlanItem> items) {
        this.items = items != null ? items : new ArrayList<>();
    }

    // Helper formatting methods for JSP presentation
    public String getFormattedEstimatedCost() {
        return formatCurrency(estimatedCost);
    }

    public String getFormattedTotalDiscount() {
        return formatCurrency(totalDiscount);
    }

    public String getFormattedFinalEstimate() {
        return formatCurrency(finalEstimate);
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
        if (status == null) return "Bản thảo";
        return switch (status) {
            case "Draft" -> "Bản thảo";
            case "Proposed" -> "Chờ bệnh nhân duyệt";
            case "Accepted" -> "Đã đồng ý điều trị";
            case "PartiallyAccepted" -> "Đồng ý một phần";
            case "InProgress" -> "Đang thực hiện";
            case "Completed" -> "Đã hoàn thành";
            case "Declined" -> "Bệnh nhân từ chối";
            case "Cancelled" -> "Đã hủy bỏ";
            default -> status;
        };
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        return switch (status) {
            case "Draft" -> "badge-secondary";
            case "Proposed" -> "badge-warning";
            case "Accepted" -> "badge-info";
            case "PartiallyAccepted" -> "badge-warning";
            case "InProgress" -> "badge-primary";
            case "Completed" -> "badge-success";
            case "Declined", "Cancelled" -> "badge-danger";
            default -> "badge-secondary";
        };
    }
}

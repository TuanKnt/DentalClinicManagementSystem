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
 * Entity representing an Invoice (UC29, UC30, UC33).
 * Generated strictly from completed procedures (Iron Rule 3).
 * Supports multi-payment lifecycle: Unpaid -> PartiallyPaid -> Paid (Iron Rule 8).
 */
public class Invoice implements Serializable {
    private static final long serialVersionUID = 1L;

    private int invoiceId;
    private String invoiceCode;
    private int visitId;
    private int patientId;
    private int cashierId;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private BigDecimal paidAmount;
    private BigDecimal balanceAmount;
    private String status; // Unpaid, PartiallyPaid, Paid, Cancelled
    private String paymentMethod;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Joined clinical & administrative fields
    private String patientName;
    private String patientPhone;
    private String patientCitizenId;
    private String patientAddress;
    private String patientDob;
    private String cashierName;
    private String dentistName;
    private String operatory;

    // Line items (procedures performed in this visit)
    private List<ProcedureItemDTO> procedures = new ArrayList<>();
    private List<InvoicePayment> payments = new ArrayList<>();

    public Invoice() {
        this.totalAmount = BigDecimal.ZERO;
        this.discountAmount = BigDecimal.ZERO;
        this.finalAmount = BigDecimal.ZERO;
        this.paidAmount = BigDecimal.ZERO;
        this.balanceAmount = BigDecimal.ZERO;
        this.status = "Unpaid";
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
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

    public int getCashierId() {
        return cashierId;
    }

    public void setCashierId(int cashierId) {
        this.cashierId = cashierId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount != null ? discountAmount : BigDecimal.ZERO;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount != null ? finalAmount : BigDecimal.ZERO;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount != null ? paidAmount : BigDecimal.ZERO;
    }

    public BigDecimal getBalanceAmount() {
        return balanceAmount;
    }

    public void setBalanceAmount(BigDecimal balanceAmount) {
        this.balanceAmount = balanceAmount != null ? balanceAmount : BigDecimal.ZERO;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
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

    public String getPatientCitizenId() {
        return patientCitizenId;
    }

    public void setPatientCitizenId(String patientCitizenId) {
        this.patientCitizenId = patientCitizenId;
    }

    public String getPatientAddress() {
        return patientAddress;
    }

    public void setPatientAddress(String patientAddress) {
        this.patientAddress = patientAddress;
    }

    public String getPatientDob() {
        return patientDob;
    }

    public void setPatientDob(String patientDob) {
        this.patientDob = patientDob;
    }

    public String getCashierName() {
        return cashierName;
    }

    public void setCashierName(String cashierName) {
        this.cashierName = cashierName;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getOperatory() {
        return operatory;
    }

    public void setOperatory(String operatory) {
        this.operatory = operatory;
    }

    public List<ProcedureItemDTO> getProcedures() {
        return procedures;
    }

    public void setProcedures(List<ProcedureItemDTO> procedures) {
        this.procedures = procedures;
    }

    public List<InvoicePayment> getPayments() {
        return payments;
    }

    public void setPayments(List<InvoicePayment> payments) {
        this.payments = payments;
    }

    // Formatting Helpers
    public String getFormattedTotalAmount() {
        return formatCurrency(totalAmount);
    }

    public String getFormattedDiscountAmount() {
        return formatCurrency(discountAmount);
    }

    public String getFormattedFinalAmount() {
        return formatCurrency(finalAmount);
    }

    public String getFormattedPaidAmount() {
        return formatCurrency(paidAmount);
    }

    public String getFormattedBalanceAmount() {
        return formatCurrency(balanceAmount);
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
        if (status == null) return "Chưa thanh toán";
        return switch (status) {
            case "Unpaid" -> "Chưa thanh toán";
            case "PartiallyPaid" -> "Thu một phần";
            case "Paid" -> "Đã hoàn tất";
            case "Cancelled" -> "Đã hủy";
            default -> status;
        };
    }

    public String getStatusBadgeClass() {
        if (status == null) return "status-pill-danger";
        return switch (status) {
            case "Unpaid" -> "status-pill-danger";
            case "PartiallyPaid" -> "status-pill-warning";
            case "Paid" -> "status-pill-success";
            case "Cancelled" -> "status-pill-secondary";
            default -> "status-pill-info";
        };
    }
}

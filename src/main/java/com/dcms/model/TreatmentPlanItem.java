package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.util.Locale;

/**
 * Entity representing an itemized procedure in a Treatment Plan (UC20).
 * Supports FDI tooth notation (11-48) and surface specification.
 */
public class TreatmentPlanItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int itemId;
    private int planId;
    private int serviceId;
    private Integer toothNumber; // Nullable or FDI 11-18, 21-28, 31-38, 41-48
    private String surface;      // WholeTooth, Occlusal, Mesial, Distal, Buccal, Lingual
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subTotal;
    private int priorityOrder;   // Session / Phase number: 1 = Buổi 1, 2 = Buổi 2...
    private String status;       // Proposed, Accepted, InProgress, Completed, Deferred, Declined, Cancelled
    private String notes;
    private LocalDateTime createdAt;

    // Joined catalog service information
    private String serviceCode;
    private String serviceName;
    private String category;
    private String unit;

    public TreatmentPlanItem() {
        this.quantity = 1;
        this.unitPrice = BigDecimal.ZERO;
        this.subTotal = BigDecimal.ZERO;
        this.priorityOrder = 1;
        this.surface = "WholeTooth";
        this.status = "Proposed";
    }

    public TreatmentPlanItem(int planId, int serviceId, Integer toothNumber, String surface,
                             int quantity, BigDecimal unitPrice, int priorityOrder) {
        this();
        this.planId = planId;
        this.serviceId = serviceId;
        this.toothNumber = toothNumber;
        this.surface = surface != null && !surface.trim().isEmpty() ? surface : "WholeTooth";
        this.quantity = quantity > 0 ? quantity : 1;
        this.unitPrice = unitPrice != null ? unitPrice : BigDecimal.ZERO;
        this.priorityOrder = priorityOrder > 0 ? priorityOrder : 1;
        this.subTotal = this.unitPrice.multiply(BigDecimal.valueOf(this.quantity));
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
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
        this.surface = surface != null && !surface.trim().isEmpty() ? surface : "WholeTooth";
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateSubTotal();
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice != null ? unitPrice : BigDecimal.ZERO;
        calculateSubTotal();
    }

    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal != null ? subTotal : BigDecimal.ZERO;
    }

    public int getPriorityOrder() {
        return priorityOrder;
    }

    public void setPriorityOrder(int priorityOrder) {
        this.priorityOrder = priorityOrder;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public void calculateSubTotal() {
        if (this.unitPrice != null && this.quantity > 0) {
            this.subTotal = this.unitPrice.multiply(BigDecimal.valueOf(this.quantity));
        } else {
            this.subTotal = BigDecimal.ZERO;
        }
    }

    public String getFormattedUnitPrice() {
        return formatCurrency(unitPrice);
    }

    public String getFormattedSubTotal() {
        return formatCurrency(subTotal);
    }

    private String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(amount) + " đ";
    }

    public String getToothDisplay() {
        if (toothNumber == null || toothNumber <= 0) {
            return "Toàn hàm / Chung";
        }
        String surfaceText = switch (surface != null ? surface : "") {
            case "Occlusal" -> "Mặt nhai (O)";
            case "Mesial" -> "Mặt gần (M)";
            case "Distal" -> "Mặt xa (D)";
            case "Buccal" -> "Mặt ngoài (B)";
            case "Lingual" -> "Mặt trong (L)";
            default -> "Toàn răng";
        };
        return "Răng " + toothNumber + " (" + surfaceText + ")";
    }

    public String getStatusDisplayName() {
        if (status == null) return "Đề xuất";
        return switch (status) {
            case "Proposed" -> "Đề xuất";
            case "Accepted" -> "Đã đồng ý";
            case "InProgress" -> "Đang thực hiện";
            case "Completed" -> "Đã hoàn thành";
            case "Deferred" -> "Hoãn lại";
            case "Declined" -> "Từ chối";
            case "Cancelled" -> "Đã hủy";
            default -> status;
        };
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        return switch (status) {
            case "Proposed" -> "badge-warning";
            case "Accepted" -> "badge-info";
            case "InProgress" -> "badge-primary";
            case "Completed" -> "badge-success";
            case "Deferred" -> "badge-secondary";
            case "Declined", "Cancelled" -> "badge-danger";
            default -> "badge-secondary";
        };
    }
}

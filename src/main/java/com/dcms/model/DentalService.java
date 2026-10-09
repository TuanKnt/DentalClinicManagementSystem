package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.util.Locale;

/**
 * Entity representing a Dental Service / Procedure in the clinic catalog (UC40).
 */
public class DentalService implements Serializable {
    private static final long serialVersionUID = 1L;

    private int serviceId;
    private String serviceCode;
    private String serviceName;
    private String category;
    private BigDecimal price;
    private String unit;
    private String description;
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public DentalService() {
        this.unit = "Lần";
        this.active = true;
        this.price = BigDecimal.ZERO;
    }

    public DentalService(int serviceId, String serviceCode, String serviceName, String category,
                         BigDecimal price, String unit, String description, boolean active) {
        this.serviceId = serviceId;
        this.serviceCode = serviceCode;
        this.serviceName = serviceName;
        this.category = category;
        this.price = price;
        this.unit = unit != null ? unit : "Lần";
        this.description = description;
        this.active = active;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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

    /**
     * Format price into standard Vietnamese currency string (e.g., 450.000 ₫).
     */
    public String getFormattedPrice() {
        if (price == null) {
            return "0 ₫";
        }
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(price) + " ₫";
    }

    /**
     * Returns a human-friendly Vietnamese label for each service category.
     */
    public String getCategoryDisplayName() {
        if (category == null) return "Chung";
        switch (category) {
            case "KhamTongQuat":
                return "Khám & Chẩn Đoán";
            case "TramRang":
                return "Trám Răng Thẩm Mỹ";
            case "DieuTriTuy":
                return "Điều Trị Tủy Vi Phẫu";
            case "NhoRang":
                return "Nhổ Răng & Tiểu Phẫu";
            case "TayTrang":
                return "Tẩy Trắng Răng";
            case "RangSu":
                return "Răng Sứ & Veneer";
            case "Implant":
                return "Cấy Ghép Implant";
            case "ChinhNha":
                return "Chỉnh Nha - Niềng Răng";
            default:
                return category;
        }
    }
}

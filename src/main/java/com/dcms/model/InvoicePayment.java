package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.util.Locale;

/**
 * Entity representing an individual Payment transaction against an Invoice (UC31, UC32, UC34).
 */
public class InvoicePayment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int paymentId;
    private String paymentCode;
    private int invoiceId;
    private BigDecimal amount;
    private String paymentMethod; // Cash, BankTransfer, Card
    private int cashierId;
    private String cashierName;
    private String notes;
    private LocalDateTime paidAt;

    public InvoicePayment() {
        this.amount = BigDecimal.ZERO;
        this.paymentMethod = "Cash";
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount != null ? amount : BigDecimal.ZERO;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public int getCashierId() {
        return cashierId;
    }

    public void setCashierId(int cashierId) {
        this.cashierId = cashierId;
    }

    public String getCashierName() {
        return cashierName;
    }

    public void setCashierName(String cashierName) {
        this.cashierName = cashierName;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public String getPaymentMethodDisplayName() {
        if (paymentMethod == null) return "Tiền mặt";
        return switch (paymentMethod) {
            case "Cash" -> "Tiền mặt";
            case "BankTransfer" -> "Chuyển khoản QR";
            case "Card" -> "Quẹt thẻ POS";
            default -> paymentMethod;
        };
    }

    public String getFormattedAmount() {
        if (amount == null) return "0 đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(amount) + " đ";
    }
}

package com.dcms.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * Summary metrics for Cashier shift dashboard.
 */
public class CashierShiftSummary implements Serializable {
    private static final long serialVersionUID = 1L;

    private BigDecimal totalRevenueToday;
    private int totalPaidInvoices;
    private int totalWaitingInvoices;
    private BigDecimal totalPendingBalance;

    public CashierShiftSummary() {
        this.totalRevenueToday = BigDecimal.ZERO;
        this.totalPaidInvoices = 0;
        this.totalWaitingInvoices = 0;
        this.totalPendingBalance = BigDecimal.ZERO;
    }

    public BigDecimal getTotalRevenueToday() {
        return totalRevenueToday;
    }

    public void setTotalRevenueToday(BigDecimal totalRevenueToday) {
        this.totalRevenueToday = totalRevenueToday != null ? totalRevenueToday : BigDecimal.ZERO;
    }

    public int getTotalPaidInvoices() {
        return totalPaidInvoices;
    }

    public void setTotalPaidInvoices(int totalPaidInvoices) {
        this.totalPaidInvoices = totalPaidInvoices;
    }

    public int getTotalWaitingInvoices() {
        return totalWaitingInvoices;
    }

    public void setTotalWaitingInvoices(int totalWaitingInvoices) {
        this.totalWaitingInvoices = totalWaitingInvoices;
    }

    public BigDecimal getTotalPendingBalance() {
        return totalPendingBalance;
    }

    public void setTotalPendingBalance(BigDecimal totalPendingBalance) {
        this.totalPendingBalance = totalPendingBalance != null ? totalPendingBalance : BigDecimal.ZERO;
    }

    public String getFormattedRevenueToday() {
        return formatCurrency(totalRevenueToday);
    }

    public String getFormattedPendingBalance() {
        return formatCurrency(totalPendingBalance);
    }

    private String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(amount) + " đ";
    }
}

package com.dcms.service;

import com.dcms.dao.InvoiceDAO;
import com.dcms.service.exception.BusinessRuleViolationException;
import com.dcms.model.CashierShiftSummary;
import com.dcms.model.Invoice;
import com.dcms.model.InvoicePayment;

import java.math.BigDecimal;
import java.util.List;

/**
 * Service orchestrating billing and payment transactions (UC29, UC30, UC31, UC32, UC34).
 * Enforces Iron Rule 3 (Invoice from completed procedures) and Iron Rule 8 (Payment lifecycle).
 */
public class BillingService {

    private final InvoiceDAO invoiceDAO;

    public BillingService() {
        this.invoiceDAO = new InvoiceDAO();
    }

    public BillingService(InvoiceDAO invoiceDAO) {
        this.invoiceDAO = invoiceDAO;
    }

    public List<Invoice> getAllInvoices() {
        return invoiceDAO.findAllInvoices();
    }

    public Invoice getInvoiceDetail(int invoiceId) {
        if (invoiceId <= 0) {
            throw new IllegalArgumentException("Mã hóa đơn không hợp lệ");
        }
        Invoice inv = invoiceDAO.findInvoiceById(invoiceId);
        if (inv == null) {
            throw new BusinessRuleViolationException("Không tìm thấy hóa đơn viện phí #" + invoiceId);
        }
        return inv;
    }

    public CashierShiftSummary getShiftSummary() {
        return invoiceDAO.getShiftSummary();
    }

    /**
     * Records a payment against an invoice (UC31, UC34).
     * Enforces payment lifecycle: Unpaid -> PartiallyPaid -> Paid.
     */
    public boolean processPayment(int invoiceId, BigDecimal amount, String method, int cashierId, String notes) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessRuleViolationException("Số tiền thanh toán phải lớn hơn 0 đ");
        }

        Invoice invoice = getInvoiceDetail(invoiceId);
        if ("Paid".equalsIgnoreCase(invoice.getStatus())) {
            throw new BusinessRuleViolationException("Hóa đơn #" + invoice.getInvoiceCode() + " đã được thanh toán đủ 100%");
        }
        if ("Cancelled".equalsIgnoreCase(invoice.getStatus())) {
            throw new BusinessRuleViolationException("Hóa đơn #" + invoice.getInvoiceCode() + " đã bị hủy bỏ");
        }

        if (amount.compareTo(invoice.getBalanceAmount()) > 0) {
            throw new BusinessRuleViolationException("Số tiền thanh toán (" + amount + " đ) vượt quá số tiền còn nợ (" + invoice.getBalanceAmount() + " đ)");
        }

        String validMethod = (method != null && !method.trim().isEmpty()) ? method.trim() : "Cash";
        if (!validMethod.equalsIgnoreCase("Cash") && !validMethod.equalsIgnoreCase("BankTransfer") && !validMethod.equalsIgnoreCase("Card")) {
            validMethod = "Cash";
        }

        return invoiceDAO.recordPayment(invoiceId, amount, validMethod, cashierId, notes);
    }
}

package com.dcms.service;

import com.dcms.dao.InvoiceDAO;
import com.dcms.service.exception.BusinessRuleViolationException;
import com.dcms.model.Invoice;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

public class BillingServiceTest {

    private InvoiceDAO mockInvoiceDAO;
    private BillingService billingService;

    @BeforeEach
    void setUp() {
        mockInvoiceDAO = Mockito.mock(InvoiceDAO.class);
        billingService = new BillingService(mockInvoiceDAO);
    }

    @Test
    @DisplayName("Process payment throws exception when amount is null or <= 0")
    void testProcessPaymentZeroOrNegativeAmount() {
        assertThrows(BusinessRuleViolationException.class, () -> {
            billingService.processPayment(1, BigDecimal.ZERO, "Cash", 5, "Test");
        });

        assertThrows(BusinessRuleViolationException.class, () -> {
            billingService.processPayment(1, new BigDecimal("-10000"), "Cash", 5, "Test");
        });
    }

    @Test
    @DisplayName("Process payment throws exception when invoice is already fully Paid")
    void testProcessPaymentOnAlreadyPaidInvoice() {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(1);
        invoice.setInvoiceCode("HD-001");
        invoice.setStatus("Paid");
        invoice.setBalanceAmount(BigDecimal.ZERO);

        when(mockInvoiceDAO.findInvoiceById(1)).thenReturn(invoice);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () -> {
            billingService.processPayment(1, new BigDecimal("100000"), "Cash", 5, "Test");
        });
        assertTrue(ex.getMessage().contains("đã được thanh toán đủ"));
    }

    @Test
    @DisplayName("Process payment throws exception when amount exceeds balance amount")
    void testProcessPaymentExceedsBalance() {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(1);
        invoice.setInvoiceCode("HD-001");
        invoice.setStatus("Unpaid");
        invoice.setBalanceAmount(new BigDecimal("500000"));

        when(mockInvoiceDAO.findInvoiceById(1)).thenReturn(invoice);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () -> {
            billingService.processPayment(1, new BigDecimal("600000"), "Cash", 5, "Test");
        });
        assertTrue(ex.getMessage().contains("vượt quá số tiền còn nợ"));
    }

    @Test
    @DisplayName("Process payment happy path: partial payment succeeds")
    void testProcessPaymentPartialSuccess() {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(1);
        invoice.setInvoiceCode("HD-001");
        invoice.setStatus("Unpaid");
        invoice.setFinalAmount(new BigDecimal("1000000"));
        invoice.setBalanceAmount(new BigDecimal("1000000"));

        when(mockInvoiceDAO.findInvoiceById(1)).thenReturn(invoice);
        when(mockInvoiceDAO.recordPayment(eq(1), any(BigDecimal.class), eq("Cash"), eq(5), anyString()))
                .thenReturn(true);

        boolean result = billingService.processPayment(1, new BigDecimal("400000"), "Cash", 5, "Tra dot 1");
        assertTrue(result);
        verify(mockInvoiceDAO, times(1)).recordPayment(1, new BigDecimal("400000"), "Cash", 5, "Tra dot 1");
    }

    @Test
    @DisplayName("Process payment happy path: full settlement succeeds")
    void testProcessPaymentFullSettlementSuccess() {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(2);
        invoice.setInvoiceCode("HD-002");
        invoice.setStatus("PartiallyPaid");
        invoice.setBalanceAmount(new BigDecimal("300000"));

        when(mockInvoiceDAO.findInvoiceById(2)).thenReturn(invoice);
        when(mockInvoiceDAO.recordPayment(eq(2), eq(new BigDecimal("300000")), eq("BankTransfer"), eq(5), anyString()))
                .thenReturn(true);

        boolean result = billingService.processPayment(2, new BigDecimal("300000"), "BankTransfer", 5, "QR chuyen khoan");
        assertTrue(result);
    }
}

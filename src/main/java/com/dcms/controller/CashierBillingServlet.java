package com.dcms.controller;

import com.dcms.service.exception.BusinessRuleViolationException;
import com.dcms.model.CashierShiftSummary;
import com.dcms.model.Invoice;
import com.dcms.model.User;
import com.dcms.service.BillingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Controller managing Cashier Desk and Billing Operations (UC29, UC30, UC31, UC32, UC34).
 */
@WebServlet(name = "CashierBillingServlet", urlPatterns = {"/cashier/billing", "/cashier/desk", "/cashier/payment", "/cashier/receipt"})
public class CashierBillingServlet extends HttpServlet {

    private final BillingService billingService;

    public CashierBillingServlet() {
        this.billingService = new BillingService();
    }

    public CashierBillingServlet(BillingService billingService) {
        this.billingService = billingService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/cashier/receipt".equalsIgnoreCase(path)) {
            handlePrintReceipt(request, response);
            return;
        }

        handleCashierDesk(request, response);
    }

    private void handleCashierDesk(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Invoice> invoices = billingService.getAllInvoices();
        CashierShiftSummary summary = billingService.getShiftSummary();

        request.setAttribute("invoices", invoices);
        request.setAttribute("shiftSummary", summary);
        request.setAttribute("activeMenu", "cashier_billing");
        request.getRequestDispatcher("/WEB-INF/views/cashier/billing.jsp").forward(request, response);
    }

    private void handlePrintReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cashier/billing?error=ThieuMaHoaDon");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(idParam.trim());
            Invoice invoice = billingService.getInvoiceDetail(invoiceId);
            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/WEB-INF/views/cashier/receipt-print.jsp").forward(request, response);
        } catch (NumberFormatException | BusinessRuleViolationException ex) {
            response.sendRedirect(request.getContextPath() + "/cashier/billing?error=" + URLEncoder.encode(ex.getMessage(), StandardCharsets.UTF_8));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        int cashierId = (currentUser != null) ? currentUser.getUserId() : 5;

        String idParam = request.getParameter("invoiceId");
        String amountParam = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");

        if (idParam == null || amountParam == null) {
            response.sendRedirect(request.getContextPath() + "/cashier/billing?error=ThieuThongTinThanhToan");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(idParam.trim());
            // Sanitize amount string (e.g. remove commas or dots if entered formatted)
            String cleanAmount = amountParam.trim().replace(".", "").replace(",", "");
            BigDecimal amount = new BigDecimal(cleanAmount);

            boolean success = billingService.processPayment(invoiceId, amount, paymentMethod, cashierId, notes);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/cashier/billing?success=payment_recorded&invoiceId=" + invoiceId);
            } else {
                response.sendRedirect(request.getContextPath() + "/cashier/billing?error=GhiNhanThanhToanThatBai");
            }
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/cashier/billing?error=" + URLEncoder.encode("Số tiền thanh toán không hợp lệ", StandardCharsets.UTF_8));
        } catch (BusinessRuleViolationException ex) {
            response.sendRedirect(request.getContextPath() + "/cashier/billing?error=" + URLEncoder.encode(ex.getMessage(), StandardCharsets.UTF_8));
        }
    }
}

package com.dcms.dao;

import com.dcms.model.CashierShiftSummary;
import com.dcms.model.Invoice;
import com.dcms.model.InvoicePayment;
import com.dcms.model.ProcedureItemDTO;
import com.dcms.util.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Invoices and Payments (UC29, UC30, UC31, UC32, UC34).
 */
public class InvoiceDAO {

    private static final Logger LOGGER = Logger.getLogger(InvoiceDAO.class.getName());

    public List<Invoice> findAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.InvoiceId, i.InvoiceCode, i.VisitId, i.PatientId, i.CashierId, " +
                     "i.TotalAmount, i.DiscountAmount, i.FinalAmount, i.PaidAmount, i.BalanceAmount, " +
                     "i.Status, i.PaymentMethod, i.Notes, i.CreatedAt, i.UpdatedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, p.CitizenId AS PatientCitizenId, " +
                     "uCashier.FullName AS CashierName, uDentist.FullName AS DentistName, v.Operatory " +
                     "FROM dbo.Invoices i " +
                     "JOIN dbo.Patients p ON i.PatientId = p.PatientId " +
                     "JOIN dbo.Users uCashier ON i.CashierId = uCashier.UserId " +
                     "JOIN dbo.Visits v ON i.VisitId = v.VisitId " +
                     "JOIN dbo.Dentists d ON v.PrimaryDentistId = d.DentistId " +
                     "JOIN dbo.Users uDentist ON d.DentistId = uDentist.UserId " +
                     "ORDER BY i.InvoiceId DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapInvoice(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findAllInvoices", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Invoice findInvoiceById(int invoiceId) {
        String sql = "SELECT i.InvoiceId, i.InvoiceCode, i.VisitId, i.PatientId, i.CashierId, " +
                     "i.TotalAmount, i.DiscountAmount, i.FinalAmount, i.PaidAmount, i.BalanceAmount, " +
                     "i.Status, i.PaymentMethod, i.Notes, i.CreatedAt, i.UpdatedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, p.CitizenId AS PatientCitizenId, " +
                     "p.Address AS PatientAddress, CONVERT(VARCHAR, p.Dob, 103) AS PatientDob, " +
                     "uCashier.FullName AS CashierName, uDentist.FullName AS DentistName, v.Operatory " +
                     "FROM dbo.Invoices i " +
                     "JOIN dbo.Patients p ON i.PatientId = p.PatientId " +
                     "JOIN dbo.Users uCashier ON i.CashierId = uCashier.UserId " +
                     "JOIN dbo.Visits v ON i.VisitId = v.VisitId " +
                     "JOIN dbo.Dentists d ON v.PrimaryDentistId = d.DentistId " +
                     "JOIN dbo.Users uDentist ON d.DentistId = uDentist.UserId " +
                     "WHERE i.InvoiceId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Invoice inv = mapInvoice(rs);
                inv.setPatientAddress(rs.getString("PatientAddress"));
                inv.setPatientDob(rs.getString("PatientDob"));
                inv.setProcedures(findProceduresByVisitId(inv.getVisitId()));
                inv.setPayments(findPaymentsByInvoiceId(inv.getInvoiceId()));
                return inv;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findInvoiceById: " + invoiceId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<ProcedureItemDTO> findProceduresByVisitId(int visitId) {
        List<ProcedureItemDTO> list = new ArrayList<>();
        String sql = "SELECT pp.ProcedureId, pp.VisitId, pp.ServiceId, s.ServiceCode, s.ServiceName, " +
                     "pp.ToothNumber, pp.Surface, pp.Quantity, pp.ActualPrice, " +
                     "(pp.Quantity * pp.ActualPrice) AS SubTotal, pp.Status, pp.ClinicalNotes, " +
                     "pp.PerformedAt, uDentist.FullName AS DentistName " +
                     "FROM dbo.ProceduresPerformed pp " +
                     "JOIN dbo.DentalServices s ON pp.ServiceId = s.ServiceId " +
                     "JOIN dbo.Dentists d ON pp.DentistId = d.DentistId " +
                     "JOIN dbo.Users uDentist ON d.DentistId = uDentist.UserId " +
                     "WHERE pp.VisitId = ? AND pp.Status = 'Completed' " +
                     "ORDER BY pp.ProcedureId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ProcedureItemDTO item = new ProcedureItemDTO();
                item.setProcedureId(rs.getInt("ProcedureId"));
                item.setVisitId(rs.getInt("VisitId"));
                item.setServiceId(rs.getInt("ServiceId"));
                item.setServiceCode(rs.getString("ServiceCode"));
                item.setServiceName(rs.getString("ServiceName"));
                int tooth = rs.getInt("ToothNumber");
                if (!rs.wasNull()) {
                    item.setToothNumber(tooth);
                }
                item.setSurface(rs.getString("Surface"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setActualPrice(rs.getBigDecimal("ActualPrice"));
                item.setSubTotal(rs.getBigDecimal("SubTotal"));
                item.setStatus(rs.getString("Status"));
                item.setClinicalNotes(rs.getString("ClinicalNotes"));
                if (rs.getTimestamp("PerformedAt") != null) {
                    item.setPerformedAt(rs.getTimestamp("PerformedAt").toLocalDateTime());
                }
                item.setDentistName(rs.getString("DentistName"));
                list.add(item);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findProceduresByVisitId: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<InvoicePayment> findPaymentsByInvoiceId(int invoiceId) {
        List<InvoicePayment> list = new ArrayList<>();
        String sql = "SELECT p.PaymentId, p.PaymentCode, p.InvoiceId, p.Amount, p.PaymentMethod, " +
                     "p.CashierId, p.Notes, p.PaidAt, u.FullName AS CashierName " +
                     "FROM dbo.InvoicePayments p " +
                     "JOIN dbo.Users u ON p.CashierId = u.UserId " +
                     "WHERE p.InvoiceId = ? " +
                     "ORDER BY p.PaymentId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            rs = ps.executeQuery();
            while (rs.next()) {
                InvoicePayment pay = new InvoicePayment();
                pay.setPaymentId(rs.getInt("PaymentId"));
                pay.setPaymentCode(rs.getString("PaymentCode"));
                pay.setInvoiceId(rs.getInt("InvoiceId"));
                pay.setAmount(rs.getBigDecimal("Amount"));
                pay.setPaymentMethod(rs.getString("PaymentMethod"));
                pay.setCashierId(rs.getInt("CashierId"));
                pay.setNotes(rs.getString("Notes"));
                if (rs.getTimestamp("PaidAt") != null) {
                    pay.setPaidAt(rs.getTimestamp("PaidAt").toLocalDateTime());
                }
                pay.setCashierName(rs.getString("CashierName"));
                list.add(pay);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findPaymentsByInvoiceId: " + invoiceId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public boolean recordPayment(int invoiceId, BigDecimal amount, String method, int cashierId, String notes) {
        String insertPaySql = "INSERT INTO dbo.InvoicePayments (PaymentCode, InvoiceId, Amount, PaymentMethod, CashierId, Notes, PaidAt) " +
                              "VALUES (?, ?, ?, ?, ?, ?, SYSDATETIME())";

        String updateInvSql = "UPDATE dbo.Invoices SET " +
                              "PaidAmount = PaidAmount + ?, " +
                              "BalanceAmount = FinalAmount - (PaidAmount + ?), " +
                              "PaymentMethod = ?, " +
                              "Status = CASE WHEN (FinalAmount - (PaidAmount + ?)) <= 0 THEN 'Paid' ELSE 'PartiallyPaid' END, " +
                              "UpdatedAt = SYSDATETIME() " +
                              "WHERE InvoiceId = ?";

        Connection conn = null;
        PreparedStatement psPay = null;
        PreparedStatement psInv = null;

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            String payCode = "PT-" + System.currentTimeMillis() % 1000000;

            psPay = conn.prepareStatement(insertPaySql);
            psPay.setString(1, payCode);
            psPay.setInt(2, invoiceId);
            psPay.setBigDecimal(3, amount);
            psPay.setString(4, method);
            psPay.setInt(5, cashierId);
            psPay.setString(6, notes);
            psPay.executeUpdate();

            psInv = conn.prepareStatement(updateInvSql);
            psInv.setBigDecimal(1, amount);
            psInv.setBigDecimal(2, amount);
            psInv.setString(3, method);
            psInv.setBigDecimal(4, amount);
            psInv.setInt(5, invoiceId);
            psInv.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException rb) { LOGGER.log(Level.SEVERE, "Rollback failed", rb); }
            }
            LOGGER.log(Level.SEVERE, "Error recording payment for invoice: " + invoiceId, ex);
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException ignored) {}
            DBContext.close(conn, psPay, null);
            if (psInv != null) {
                try { psInv.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public CashierShiftSummary getShiftSummary() {
        CashierShiftSummary summary = new CashierShiftSummary();
        String sql = "SELECT " +
                     "ISNULL(SUM(p.Amount), 0) AS RevenueToday, " +
                     "SUM(CASE WHEN i.Status = 'Paid' THEN 1 ELSE 0 END) AS PaidCount, " +
                     "SUM(CASE WHEN i.Status IN ('Unpaid', 'PartiallyPaid') THEN 1 ELSE 0 END) AS WaitingCount, " +
                     "ISNULL(SUM(CASE WHEN i.Status IN ('Unpaid', 'PartiallyPaid') THEN i.BalanceAmount ELSE 0 END), 0) AS PendingBalance " +
                     "FROM dbo.Invoices i " +
                     "LEFT JOIN dbo.InvoicePayments p ON i.InvoiceId = p.InvoiceId";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                summary.setTotalRevenueToday(rs.getBigDecimal("RevenueToday"));
                summary.setTotalPaidInvoices(rs.getInt("PaidCount"));
                summary.setTotalWaitingInvoices(rs.getInt("WaitingCount"));
                summary.setTotalPendingBalance(rs.getBigDecimal("PendingBalance"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in getShiftSummary", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return summary;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setInvoiceId(rs.getInt("InvoiceId"));
        inv.setInvoiceCode(rs.getString("InvoiceCode"));
        inv.setVisitId(rs.getInt("VisitId"));
        inv.setPatientId(rs.getInt("PatientId"));
        inv.setCashierId(rs.getInt("CashierId"));
        inv.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        inv.setDiscountAmount(rs.getBigDecimal("DiscountAmount"));
        inv.setFinalAmount(rs.getBigDecimal("FinalAmount"));
        inv.setPaidAmount(rs.getBigDecimal("PaidAmount"));
        inv.setBalanceAmount(rs.getBigDecimal("BalanceAmount"));
        inv.setStatus(rs.getString("Status"));
        inv.setPaymentMethod(rs.getString("PaymentMethod"));
        inv.setNotes(rs.getString("Notes"));
        if (rs.getTimestamp("CreatedAt") != null) {
            inv.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        }
        if (rs.getTimestamp("UpdatedAt") != null) {
            inv.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
        }
        inv.setPatientName(rs.getString("PatientName"));
        inv.setPatientPhone(rs.getString("PatientPhone"));
        inv.setPatientCitizenId(rs.getString("PatientCitizenId"));
        inv.setCashierName(rs.getString("CashierName"));
        inv.setDentistName(rs.getString("DentistName"));
        inv.setOperatory(rs.getString("Operatory"));
        return inv;
    }
}

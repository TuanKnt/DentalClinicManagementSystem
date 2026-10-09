package com.dcms.dao;

import com.dcms.model.Medicine;
import com.dcms.model.Prescription;
import com.dcms.model.PrescriptionItem;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Medicines and Prescriptions (UC27, UC28).
 * Managed by Kiên (Pharmacy & E-Prescriptions).
 */
public class PrescriptionDAO {

    private static final Logger LOGGER = Logger.getLogger(PrescriptionDAO.class.getName());

    // =========================================================================
    // 1. MEDICINES CATALOG
    // =========================================================================

    public List<Medicine> findAllMedicines(boolean onlyActive) {
        List<Medicine> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT MedicineId, MedicineCode, MedicineName, ActiveIngredient, DosageForm, Unit, UnitPrice, UsageInstructions, IsActive, CreatedAt " +
                "FROM dbo.Medicines "
        );
        if (onlyActive) {
            sql.append("WHERE IsActive = 1 ");
        }
        sql.append("ORDER BY MedicineName ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMedicine(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing medicines", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Medicine findMedicineById(int medicineId) {
        String sql = "SELECT MedicineId, MedicineCode, MedicineName, ActiveIngredient, DosageForm, Unit, UnitPrice, UsageInstructions, IsActive, CreatedAt " +
                     "FROM dbo.Medicines WHERE MedicineId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, medicineId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToMedicine(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding medicine by id: " + medicineId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    // =========================================================================
    // 2. PRESCRIPTIONS & DETAILS (TRANSACTIONAL)
    // =========================================================================

    public String generateNextPrescriptionCode() {
        int currentYear = Year.now().getValue();
        String prefix = "RX-" + currentYear + "-";
        String sql = "SELECT COUNT(*) FROM dbo.Prescriptions WHERE PrescriptionCode LIKE ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, prefix + "%");
            rs = ps.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            return String.format("%s%04d", prefix, count + 1);
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Error generating next prescription code, falling back to timestamp", ex);
            return "RX-" + System.currentTimeMillis();
        } finally {
            DBContext.close(conn, ps, rs);
        }
    }

    public int createPrescription(Prescription rx, List<PrescriptionItem> items) {
        if (rx == null || items == null || items.isEmpty()) {
            return -1;
        }

        if (rx.getPrescriptionCode() == null || rx.getPrescriptionCode().trim().isEmpty()) {
            rx.setPrescriptionCode(generateNextPrescriptionCode());
        }

        String insertRxSql = "INSERT INTO dbo.Prescriptions (VisitId, PatientId, DentistId, PrescriptionCode, Diagnosis, Advice, Status, IssuedAt) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        String insertItemSql = "INSERT INTO dbo.PrescriptionDetails (PrescriptionId, MedicineId, Quantity, Dosage, DurationDays, Notes) " +
                              "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psRx = null;
        PreparedStatement psItem = null;
        ResultSet rsRx = null;

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            psRx = conn.prepareStatement(insertRxSql, Statement.RETURN_GENERATED_KEYS);
            psRx.setInt(1, rx.getVisitId());
            psRx.setInt(2, rx.getPatientId());
            psRx.setInt(3, rx.getDentistId());
            psRx.setString(4, rx.getPrescriptionCode());
            psRx.setString(5, rx.getDiagnosis());
            psRx.setString(6, rx.getAdvice());
            psRx.setString(7, rx.getStatus() != null ? rx.getStatus() : "Issued");

            int affected = psRx.executeUpdate();
            if (affected <= 0) {
                conn.rollback();
                return -1;
            }

            rsRx = psRx.getGeneratedKeys();
            if (!rsRx.next()) {
                conn.rollback();
                return -1;
            }
            int rxId = rsRx.getInt(1);
            rx.setPrescriptionId(rxId);

            psItem = conn.prepareStatement(insertItemSql);
            for (PrescriptionItem it : items) {
                psItem.setInt(1, rxId);
                psItem.setInt(2, it.getMedicineId());
                psItem.setInt(3, it.getQuantity());
                psItem.setString(4, it.getDosage());
                psItem.setInt(5, it.getDurationDays() > 0 ? it.getDurationDays() : 5);
                psItem.setString(6, it.getNotes());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
            return rxId;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException rbEx) {
                    LOGGER.log(Level.WARNING, "Failed to rollback prescription creation", rbEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error creating prescription for visit: " + rx.getVisitId(), ex);
            return -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            DBContext.close(null, psItem, null);
            DBContext.close(conn, psRx, rsRx);
        }
    }

    public Prescription findById(int prescriptionId) {
        String sql = "SELECT pr.PrescriptionId, pr.VisitId, pr.PatientId, pr.DentistId, pr.PrescriptionCode, " +
                     "pr.Diagnosis, pr.Advice, pr.Status, pr.IssuedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender AS PatientGender, " +
                     "CAST(p.Dob AS NVARCHAR(20)) AS PatientDob, p.Address AS PatientAddress, p.Allergies AS PatientAllergies, " +
                     "du.FullName AS DentistName, d.LicenseNumber AS DentistLicense, v.CheckInTime " +
                     "FROM dbo.Prescriptions pr " +
                     "JOIN dbo.Patients p ON pr.PatientId = p.PatientId " +
                     "JOIN dbo.Dentists d ON pr.DentistId = d.DentistId " +
                     "JOIN dbo.Users du ON d.DentistId = du.UserId " +
                     "JOIN dbo.Visits v ON pr.VisitId = v.VisitId " +
                     "WHERE pr.PrescriptionId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, prescriptionId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Prescription rx = mapResultSetToPrescription(rs);
                rx.setItems(findItemsByPrescriptionId(prescriptionId));
                return rx;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding prescription by id: " + prescriptionId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Prescription findByVisitId(int visitId) {
        String sql = "SELECT pr.PrescriptionId, pr.VisitId, pr.PatientId, pr.DentistId, pr.PrescriptionCode, " +
                     "pr.Diagnosis, pr.Advice, pr.Status, pr.IssuedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender AS PatientGender, " +
                     "CAST(p.Dob AS NVARCHAR(20)) AS PatientDob, p.Address AS PatientAddress, p.Allergies AS PatientAllergies, " +
                     "du.FullName AS DentistName, d.LicenseNumber AS DentistLicense, v.CheckInTime " +
                     "FROM dbo.Prescriptions pr " +
                     "JOIN dbo.Patients p ON pr.PatientId = p.PatientId " +
                     "JOIN dbo.Dentists d ON pr.DentistId = d.DentistId " +
                     "JOIN dbo.Users du ON d.DentistId = du.UserId " +
                     "JOIN dbo.Visits v ON pr.VisitId = v.VisitId " +
                     "WHERE pr.VisitId = ? ORDER BY pr.IssuedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Prescription rx = mapResultSetToPrescription(rs);
                rx.setItems(findItemsByPrescriptionId(rx.getPrescriptionId()));
                return rx;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding prescription by visitId: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<Prescription> findByPatientId(int patientId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT pr.PrescriptionId, pr.VisitId, pr.PatientId, pr.DentistId, pr.PrescriptionCode, " +
                     "pr.Diagnosis, pr.Advice, pr.Status, pr.IssuedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender AS PatientGender, " +
                     "CAST(p.Dob AS NVARCHAR(20)) AS PatientDob, p.Address AS PatientAddress, p.Allergies AS PatientAllergies, " +
                     "du.FullName AS DentistName, d.LicenseNumber AS DentistLicense, v.CheckInTime " +
                     "FROM dbo.Prescriptions pr " +
                     "JOIN dbo.Patients p ON pr.PatientId = p.PatientId " +
                     "JOIN dbo.Dentists d ON pr.DentistId = d.DentistId " +
                     "JOIN dbo.Users du ON d.DentistId = du.UserId " +
                     "JOIN dbo.Visits v ON pr.VisitId = v.VisitId " +
                     "WHERE pr.PatientId = ? ORDER BY pr.IssuedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Prescription rx = mapResultSetToPrescription(rs);
                rx.setItems(findItemsByPrescriptionId(rx.getPrescriptionId()));
                list.add(rx);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding prescriptions by patientId: " + patientId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<PrescriptionItem> findItemsByPrescriptionId(int prescriptionId) {
        List<PrescriptionItem> list = new ArrayList<>();
        String sql = "SELECT pd.DetailId, pd.PrescriptionId, pd.MedicineId, pd.Quantity, pd.Dosage, pd.DurationDays, pd.Notes, " +
                     "m.MedicineCode, m.MedicineName, m.ActiveIngredient, m.Unit, m.UnitPrice " +
                     "FROM dbo.PrescriptionDetails pd " +
                     "JOIN dbo.Medicines m ON pd.MedicineId = m.MedicineId " +
                     "WHERE pd.PrescriptionId = ? ORDER BY pd.DetailId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, prescriptionId);
            rs = ps.executeQuery();
            while (rs.next()) {
                PrescriptionItem it = new PrescriptionItem();
                it.setDetailId(rs.getInt("DetailId"));
                it.setPrescriptionId(rs.getInt("PrescriptionId"));
                it.setMedicineId(rs.getInt("MedicineId"));
                it.setQuantity(rs.getInt("Quantity"));
                it.setDosage(rs.getString("Dosage"));
                it.setDurationDays(rs.getInt("DurationDays"));
                it.setNotes(rs.getString("Notes"));

                it.setMedicineCode(rs.getString("MedicineCode"));
                it.setMedicineName(rs.getString("MedicineName"));
                it.setActiveIngredient(rs.getString("ActiveIngredient"));
                it.setUnit(rs.getString("Unit"));
                it.setUnitPrice(rs.getBigDecimal("UnitPrice"));

                list.add(it);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing items for prescription: " + prescriptionId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public boolean updateStatus(int prescriptionId, String status) {
        String sql = "UPDATE dbo.Prescriptions SET Status = ? WHERE PrescriptionId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, prescriptionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating status for prescription: " + prescriptionId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    // =========================================================================
    // 3. MAPPERS
    // =========================================================================

    private Medicine mapResultSetToMedicine(ResultSet rs) throws SQLException {
        Medicine m = new Medicine();
        m.setMedicineId(rs.getInt("MedicineId"));
        m.setMedicineCode(rs.getString("MedicineCode"));
        m.setMedicineName(rs.getString("MedicineName"));
        m.setActiveIngredient(rs.getString("ActiveIngredient"));
        m.setDosageForm(rs.getString("DosageForm"));
        m.setUnit(rs.getString("Unit"));
        m.setUnitPrice(rs.getBigDecimal("UnitPrice"));
        m.setUsageInstructions(rs.getString("UsageInstructions"));
        m.setActive(rs.getBoolean("IsActive"));
        m.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return m;
    }

    private Prescription mapResultSetToPrescription(ResultSet rs) throws SQLException {
        Prescription rx = new Prescription();
        rx.setPrescriptionId(rs.getInt("PrescriptionId"));
        rx.setVisitId(rs.getInt("VisitId"));
        rx.setPatientId(rs.getInt("PatientId"));
        rx.setDentistId(rs.getInt("DentistId"));
        rx.setPrescriptionCode(rs.getString("PrescriptionCode"));
        rx.setDiagnosis(rs.getString("Diagnosis"));
        rx.setAdvice(rs.getString("Advice"));
        rx.setStatus(rs.getString("Status"));
        rx.setIssuedAt(rs.getTimestamp("IssuedAt"));

        rx.setPatientName(rs.getString("PatientName"));
        rx.setPatientPhone(rs.getString("PatientPhone"));
        rx.setPatientGender(rs.getString("PatientGender"));
        rx.setPatientDob(rs.getString("PatientDob"));
        rx.setPatientAddress(rs.getString("PatientAddress"));
        rx.setPatientAllergies(rs.getString("PatientAllergies"));
        rx.setDentistName(rs.getString("DentistName"));
        rx.setDentistLicense(rs.getString("DentistLicense"));
        rx.setCheckInTime(rs.getTimestamp("CheckInTime"));

        return rx;
    }
}

package com.dcms.dao;

import com.dcms.model.MaterialUsage;
import com.dcms.model.ProcedurePerformed;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for chairside ProceduresPerformed & MaterialUsages (UC24, UC25, UC26).
 * Managed by Wolf (Clinical Treatment & Chairside Procedures).
 */
public class ProcedurePerformedDAO {

    private static final Logger LOGGER = Logger.getLogger(ProcedurePerformedDAO.class.getName());

    private static final String SELECT_PROCEDURE_BASE =
            "SELECT pp.ProcedureId, pp.VisitId, pp.DentistId, pp.AssistantId, pp.PlanItemId, " +
            "       pp.ServiceId, pp.ToothNumber, pp.Surface, pp.Quantity, pp.ActualPrice, " +
            "       pp.Status, pp.ClinicalNotes, pp.PerformedAt, " +
            "       s.ServiceCode, s.ServiceName, s.Unit AS ServiceUnit, " +
            "       uDentist.FullName AS DentistName, " +
            "       uAssistant.FullName AS AssistantName, " +
            "       p.FullName AS PatientName " +
            "FROM dbo.ProceduresPerformed pp " +
            "JOIN dbo.DentalServices s ON pp.ServiceId = s.ServiceId " +
            "JOIN dbo.Dentists d ON pp.DentistId = d.DentistId " +
            "JOIN dbo.Users uDentist ON d.DentistId = uDentist.UserId " +
            "LEFT JOIN dbo.Users uAssistant ON pp.AssistantId = uAssistant.UserId " +
            "JOIN dbo.Visits v ON pp.VisitId = v.VisitId " +
            "JOIN dbo.Patients p ON v.PatientId = p.PatientId ";

    /**
     * Insert a new procedure performed record at the dental chair (UC24).
     */
    public int insert(ProcedurePerformed proc) {
        String sql = "INSERT INTO dbo.ProceduresPerformed (VisitId, DentistId, AssistantId, PlanItemId, " +
                     "ServiceId, ToothNumber, Surface, Quantity, ActualPrice, Status, ClinicalNotes, PerformedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, proc.getVisitId());
            ps.setInt(2, proc.getDentistId());
            if (proc.getAssistantId() != null && proc.getAssistantId() > 0) {
                ps.setInt(3, proc.getAssistantId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            if (proc.getPlanItemId() != null && proc.getPlanItemId() > 0) {
                ps.setInt(4, proc.getPlanItemId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, proc.getServiceId());
            if (proc.getToothNumber() != null && proc.getToothNumber() > 0) {
                ps.setInt(6, proc.getToothNumber());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, proc.getSurface() != null ? proc.getSurface() : "WholeTooth");
            ps.setInt(8, proc.getQuantity() > 0 ? proc.getQuantity() : 1);
            ps.setBigDecimal(9, proc.getActualPrice());
            ps.setString(10, proc.getStatus() != null ? proc.getStatus() : "InProgress");
            ps.setString(11, proc.getClinicalNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    proc.setProcedureId(generatedId);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting procedure performed", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return generatedId;
    }

    /**
     * Find procedure performed by its primary key.
     */
    public ProcedurePerformed findById(int procedureId) {
        String sql = SELECT_PROCEDURE_BASE + "WHERE pp.ProcedureId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ProcedurePerformed proc = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, procedureId);
            rs = ps.executeQuery();
            if (rs.next()) {
                proc = mapResultSetToProcedure(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding procedure by ID: " + procedureId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        if (proc != null) {
            proc.setMaterials(findMaterialsByProcedureId(procedureId));
        }
        return proc;
    }

    /**
     * Find all procedures performed within a dental visit.
     */
    public List<ProcedurePerformed> findByVisitId(int visitId) {
        List<ProcedurePerformed> list = new ArrayList<>();
        String sql = SELECT_PROCEDURE_BASE + "WHERE pp.VisitId = ? ORDER BY pp.ProcedureId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProcedure(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error querying procedures for visit ID: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        for (ProcedurePerformed proc : list) {
            proc.setMaterials(findMaterialsByProcedureId(proc.getProcedureId()));
        }
        return list;
    }

    /**
     * Update procedure status and clinical notes (UC25).
     */
    public boolean updateStatus(int procedureId, String status, String clinicalNotes) {
        String sql = "UPDATE dbo.ProceduresPerformed SET Status = ?, ClinicalNotes = ? WHERE ProcedureId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, clinicalNotes);
            ps.setInt(3, procedureId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating status for procedure ID: " + procedureId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Insert consumable material usage for a procedure (UC26).
     */
    public int insertMaterial(MaterialUsage usage) {
        String sql = "INSERT INTO dbo.MaterialUsages (ProcedureId, MaterialName, Quantity, Unit, Notes, RecordedAt) " +
                     "VALUES (?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, usage.getProcedureId());
            ps.setString(2, usage.getMaterialName());
            ps.setInt(3, usage.getQuantity() > 0 ? usage.getQuantity() : 1);
            ps.setString(4, usage.getUnit() != null ? usage.getUnit() : "Ống");
            ps.setString(5, usage.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    usage.setUsageId(generatedId);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting material usage", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return generatedId;
    }

    /**
     * Find materials used for a specific procedure.
     */
    public List<MaterialUsage> findMaterialsByProcedureId(int procedureId) {
        List<MaterialUsage> list = new ArrayList<>();
        String sql = "SELECT UsageId, ProcedureId, MaterialName, Quantity, Unit, Notes, RecordedAt " +
                     "FROM dbo.MaterialUsages WHERE ProcedureId = ? ORDER BY UsageId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, procedureId);
            rs = ps.executeQuery();
            while (rs.next()) {
                MaterialUsage u = new MaterialUsage();
                u.setUsageId(rs.getInt("UsageId"));
                u.setProcedureId(rs.getInt("ProcedureId"));
                u.setMaterialName(rs.getString("MaterialName"));
                u.setQuantity(rs.getInt("Quantity"));
                u.setUnit(rs.getString("Unit"));
                u.setNotes(rs.getString("Notes"));
                Timestamp ts = rs.getTimestamp("RecordedAt");
                if (ts != null) {
                    u.setRecordedAt(ts.toLocalDateTime());
                }
                list.add(u);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding materials for procedure ID: " + procedureId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * Delete a material usage record.
     */
    public boolean deleteMaterial(int usageId) {
        String sql = "DELETE FROM dbo.MaterialUsages WHERE UsageId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, usageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting material usage: " + usageId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private ProcedurePerformed mapResultSetToProcedure(ResultSet rs) throws SQLException {
        ProcedurePerformed proc = new ProcedurePerformed();
        proc.setProcedureId(rs.getInt("ProcedureId"));
        proc.setVisitId(rs.getInt("VisitId"));
        proc.setDentistId(rs.getInt("DentistId"));

        int asst = rs.getInt("AssistantId");
        if (!rs.wasNull()) {
            proc.setAssistantId(asst);
        }

        int item = rs.getInt("PlanItemId");
        if (!rs.wasNull()) {
            proc.setPlanItemId(item);
        }

        proc.setServiceId(rs.getInt("ServiceId"));

        int tooth = rs.getInt("ToothNumber");
        if (!rs.wasNull()) {
            proc.setToothNumber(tooth);
        }

        proc.setSurface(rs.getString("Surface"));
        proc.setQuantity(rs.getInt("Quantity"));
        proc.setActualPrice(rs.getBigDecimal("ActualPrice"));
        proc.setStatus(rs.getString("Status"));
        proc.setClinicalNotes(rs.getString("ClinicalNotes"));

        Timestamp perfTs = rs.getTimestamp("PerformedAt");
        if (perfTs != null) {
            proc.setPerformedAt(perfTs.toLocalDateTime());
        }

        proc.setServiceCode(rs.getString("ServiceCode"));
        proc.setServiceName(rs.getString("ServiceName"));
        proc.setServiceUnit(rs.getString("ServiceUnit"));
        proc.setDentistName(rs.getString("DentistName"));
        proc.setAssistantName(rs.getString("AssistantName"));
        proc.setPatientName(rs.getString("PatientName"));

        return proc;
    }
}

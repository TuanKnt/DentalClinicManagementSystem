package com.dcms.dao;

import com.dcms.model.ToothFinding;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for ToothFindings table (Odontogram records by tooth & surface).
 */
public class ToothFindingDAO {
    private static final Logger LOGGER = Logger.getLogger(ToothFindingDAO.class.getName());

    public int create(ToothFinding f) {
        String sql = "INSERT INTO dbo.ToothFindings (PatientId, VisitId, ToothNumber, Surface, Condition, Notes, RecordedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, f.getPatientId());
            ps.setInt(2, f.getVisitId());
            ps.setInt(3, f.getToothNumber());
            ps.setString(4, f.getSurface() != null ? f.getSurface() : ToothFinding.SURFACE_WHOLE_TOOTH);
            ps.setString(5, f.getCondition() != null ? f.getCondition() : ToothFinding.CONDITION_HEALTHY);
            ps.setString(6, f.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    f.setFindingId(id);
                    return id;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error creating ToothFinding for patient: " + f.getPatientId(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public List<ToothFinding> findByPatientId(int patientId) {
        List<ToothFinding> list = new ArrayList<>();
        String sql = "SELECT FindingId, PatientId, VisitId, ToothNumber, Surface, Condition, Notes, RecordedAt " +
                     "FROM dbo.ToothFindings WHERE PatientId = ? ORDER BY ToothNumber ASC, RecordedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToToothFinding(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByPatientId for patient: " + patientId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<ToothFinding> findByVisitId(int visitId) {
        List<ToothFinding> list = new ArrayList<>();
        String sql = "SELECT FindingId, PatientId, VisitId, ToothNumber, Surface, Condition, Notes, RecordedAt " +
                     "FROM dbo.ToothFindings WHERE VisitId = ? ORDER BY ToothNumber ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToToothFinding(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByVisitId for visit: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public boolean deleteByFindingId(int findingId) {
        String sql = "DELETE FROM dbo.ToothFindings WHERE FindingId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, findingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting ToothFinding: " + findingId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private ToothFinding mapResultSetToToothFinding(ResultSet rs) throws SQLException {
        ToothFinding f = new ToothFinding();
        f.setFindingId(rs.getInt("FindingId"));
        f.setPatientId(rs.getInt("PatientId"));
        f.setVisitId(rs.getInt("VisitId"));
        f.setToothNumber(rs.getInt("ToothNumber"));
        f.setSurface(rs.getString("Surface"));
        f.setCondition(rs.getString("Condition"));
        f.setNotes(rs.getString("Notes"));

        Timestamp ts = rs.getTimestamp("RecordedAt");
        if (ts != null) f.setRecordedAt(ts.toLocalDateTime());

        return f;
    }
}

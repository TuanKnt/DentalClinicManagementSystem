package com.dcms.dao;

import com.dcms.model.DentalAttachment;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for DentalAttachments table (X-rays, intraoral photos, documents).
 */
public class DentalAttachmentDAO {
    private static final Logger LOGGER = Logger.getLogger(DentalAttachmentDAO.class.getName());

    public int create(DentalAttachment a) {
        String sql = "INSERT INTO dbo.DentalAttachments (PatientId, VisitId, FileName, FileType, FilePath, Notes, UploadedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, a.getPatientId());

            if (a.getVisitId() != null && a.getVisitId() > 0) {
                ps.setInt(2, a.getVisitId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, a.getFileName());
            ps.setString(4, a.getFileType());
            ps.setString(5, a.getFilePath());
            ps.setString(6, a.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    a.setAttachmentId(id);
                    return id;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error creating DentalAttachment for patient: " + a.getPatientId(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public List<DentalAttachment> findByPatientId(int patientId) {
        List<DentalAttachment> list = new ArrayList<>();
        String sql = "SELECT AttachmentId, PatientId, VisitId, FileName, FileType, FilePath, Notes, UploadedAt " +
                     "FROM dbo.DentalAttachments WHERE PatientId = ? ORDER BY UploadedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAttachment(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByPatientId for patient: " + patientId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<DentalAttachment> findByVisitId(int visitId) {
        List<DentalAttachment> list = new ArrayList<>();
        String sql = "SELECT AttachmentId, PatientId, VisitId, FileName, FileType, FilePath, Notes, UploadedAt " +
                     "FROM dbo.DentalAttachments WHERE VisitId = ? ORDER BY UploadedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAttachment(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByVisitId for visit: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public boolean deleteById(int attachmentId) {
        String sql = "DELETE FROM dbo.DentalAttachments WHERE AttachmentId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attachmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting attachment: " + attachmentId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private DentalAttachment mapResultSetToAttachment(ResultSet rs) throws SQLException {
        DentalAttachment a = new DentalAttachment();
        a.setAttachmentId(rs.getInt("AttachmentId"));
        a.setPatientId(rs.getInt("PatientId"));

        int vId = rs.getInt("VisitId");
        if (!rs.wasNull()) {
            a.setVisitId(vId);
        } else {
            a.setVisitId(null);
        }

        a.setFileName(rs.getString("FileName"));
        a.setFileType(rs.getString("FileType"));
        a.setFilePath(rs.getString("FilePath"));
        a.setNotes(rs.getString("Notes"));

        Timestamp ts = rs.getTimestamp("UploadedAt");
        if (ts != null) a.setUploadedAt(ts.toLocalDateTime());

        return a;
    }
}

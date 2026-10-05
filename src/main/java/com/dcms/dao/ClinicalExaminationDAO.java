package com.dcms.dao;

import com.dcms.model.ClinicalExamination;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for ClinicalExaminations table (BF-02 Dental Examination & Diagnoses).
 */
public class ClinicalExaminationDAO {
    private static final Logger LOGGER = Logger.getLogger(ClinicalExaminationDAO.class.getName());

    public int createOrUpdate(ClinicalExamination exam) {
        ClinicalExamination existing = findByVisitId(exam.getVisitId());
        if (existing != null) {
            update(exam);
            return existing.getExaminationId();
        }

        String sql = "INSERT INTO dbo.ClinicalExaminations (VisitId, ChiefComplaint, ExtraoralExam, IntraoralExam, ProvisionalDiagnosis, FinalDiagnosis, ClinicalNotes, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, exam.getVisitId());
            ps.setString(2, exam.getChiefComplaint());
            ps.setString(3, exam.getExtraoralExam());
            ps.setString(4, exam.getIntraoralExam());
            ps.setString(5, exam.getProvisionalDiagnosis());
            ps.setString(6, exam.getFinalDiagnosis());
            ps.setString(7, exam.getClinicalNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    exam.setExaminationId(id);
                    return id;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error creating ClinicalExamination for visit: " + exam.getVisitId(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public boolean update(ClinicalExamination exam) {
        String sql = "UPDATE dbo.ClinicalExaminations SET ChiefComplaint = ?, ExtraoralExam = ?, IntraoralExam = ?, " +
                     "ProvisionalDiagnosis = ?, FinalDiagnosis = ?, ClinicalNotes = ?, UpdatedAt = SYSDATETIME() " +
                     "WHERE VisitId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, exam.getChiefComplaint());
            ps.setString(2, exam.getExtraoralExam());
            ps.setString(3, exam.getIntraoralExam());
            ps.setString(4, exam.getProvisionalDiagnosis());
            ps.setString(5, exam.getFinalDiagnosis());
            ps.setString(6, exam.getClinicalNotes());
            ps.setInt(7, exam.getVisitId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating ClinicalExamination for visit: " + exam.getVisitId(), ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public ClinicalExamination findByVisitId(int visitId) {
        String sql = "SELECT ExaminationId, VisitId, ChiefComplaint, ExtraoralExam, IntraoralExam, " +
                     "ProvisionalDiagnosis, FinalDiagnosis, ClinicalNotes, CreatedAt, UpdatedAt " +
                     "FROM dbo.ClinicalExaminations WHERE VisitId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, visitId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ClinicalExamination exam = new ClinicalExamination();
                exam.setExaminationId(rs.getInt("ExaminationId"));
                exam.setVisitId(rs.getInt("VisitId"));
                exam.setChiefComplaint(rs.getString("ChiefComplaint"));
                exam.setExtraoralExam(rs.getString("ExtraoralExam"));
                exam.setIntraoralExam(rs.getString("IntraoralExam"));
                exam.setProvisionalDiagnosis(rs.getString("ProvisionalDiagnosis"));
                exam.setFinalDiagnosis(rs.getString("FinalDiagnosis"));
                exam.setClinicalNotes(rs.getString("ClinicalNotes"));

                Timestamp ct = rs.getTimestamp("CreatedAt");
                if (ct != null) exam.setCreatedAt(ct.toLocalDateTime());
                Timestamp ut = rs.getTimestamp("UpdatedAt");
                if (ut != null) exam.setUpdatedAt(ut.toLocalDateTime());

                return exam;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error findByVisitId in ClinicalExaminationDAO: " + visitId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }
}

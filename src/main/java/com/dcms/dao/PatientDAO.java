package com.dcms.dao;

import com.dcms.model.Patient;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.Date;
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
 * Data Access Object for Patients table in SQL Server.
 */
public class PatientDAO {

    private static final Logger LOGGER = Logger.getLogger(PatientDAO.class.getName());

    public Patient findById(int patientId) {
        String sql = "SELECT PatientId, FullName, Dob, Gender, Phone, CitizenId, Address, " +
                     "MedicalAlerts, Allergies, EmergencyContact, CreatedAt, UpdatedAt " +
                     "FROM dbo.Patients WHERE PatientId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findById for patientId: " + patientId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public Patient findByPhone(String phone) {
        String sql = "SELECT PatientId, FullName, Dob, Gender, Phone, CitizenId, Address, " +
                     "MedicalAlerts, Allergies, EmergencyContact, CreatedAt, UpdatedAt " +
                     "FROM dbo.Patients WHERE Phone = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByPhone: " + phone, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public List<Patient> search(String keyword, int offset, int limit) {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT PatientId, FullName, Dob, Gender, Phone, CitizenId, Address, " +
                     "MedicalAlerts, Allergies, EmergencyContact, CreatedAt, UpdatedAt " +
                     "FROM dbo.Patients " +
                     "WHERE ? IS NULL OR ? = '' OR FullName LIKE ? OR Phone LIKE ? OR CitizenId LIKE ? " +
                     "ORDER BY PatientId DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            String searchPattern = (keyword != null && !keyword.trim().isEmpty()) ? "%" + keyword.trim() + "%" : "";
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            ps.setInt(6, offset);
            ps.setInt(7, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in search patients: " + keyword, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public int countSearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM dbo.Patients " +
                     "WHERE ? IS NULL OR ? = '' OR FullName LIKE ? OR Phone LIKE ? OR CitizenId LIKE ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            String searchPattern = (keyword != null && !keyword.trim().isEmpty()) ? "%" + keyword.trim() + "%" : "";
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in countSearch patients: " + keyword, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public int create(Patient patient) {
        String sql = "INSERT INTO dbo.Patients (FullName, Dob, Gender, Phone, CitizenId, Address, " +
                     "MedicalAlerts, Allergies, EmergencyContact, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, patient.getFullName());
            ps.setDate(2, patient.getDob() != null ? Date.valueOf(patient.getDob()) : null);
            ps.setString(3, patient.getGender());
            ps.setString(4, patient.getPhone());
            ps.setString(5, patient.getCitizenId());
            ps.setString(6, patient.getAddress());
            ps.setString(7, patient.getMedicalAlerts());
            ps.setString(8, patient.getAllergies());
            ps.setString(9, patient.getEmergencyContact());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    patient.setPatientId(generatedId);
                    return generatedId;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting patient: " + patient.getFullName(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public boolean update(Patient patient) {
        String sql = "UPDATE dbo.Patients SET FullName = ?, Dob = ?, Gender = ?, Phone = ?, " +
                     "CitizenId = ?, Address = ?, MedicalAlerts = ?, Allergies = ?, " +
                     "EmergencyContact = ?, UpdatedAt = SYSDATETIME() " +
                     "WHERE PatientId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getFullName());
            ps.setDate(2, patient.getDob() != null ? Date.valueOf(patient.getDob()) : null);
            ps.setString(3, patient.getGender());
            ps.setString(4, patient.getPhone());
            ps.setString(5, patient.getCitizenId());
            ps.setString(6, patient.getAddress());
            ps.setString(7, patient.getMedicalAlerts());
            ps.setString(8, patient.getAllergies());
            ps.setString(9, patient.getEmergencyContact());
            ps.setInt(10, patient.getPatientId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating patient: " + patient.getPatientId(), ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setPatientId(rs.getInt("PatientId"));
        p.setFullName(rs.getString("FullName"));

        Date dob = rs.getDate("Dob");
        if (dob != null) {
            p.setDob(dob.toLocalDate());
        }

        p.setGender(rs.getString("Gender"));
        p.setPhone(rs.getString("Phone"));
        p.setCitizenId(rs.getString("CitizenId"));
        p.setAddress(rs.getString("Address"));
        p.setMedicalAlerts(rs.getString("MedicalAlerts"));
        p.setAllergies(rs.getString("Allergies"));
        p.setEmergencyContact(rs.getString("EmergencyContact"));

        Timestamp createdTs = rs.getTimestamp("CreatedAt");
        if (createdTs != null) {
            p.setCreatedAt(createdTs.toLocalDateTime());
        }

        Timestamp updatedTs = rs.getTimestamp("UpdatedAt");
        if (updatedTs != null) {
            p.setUpdatedAt(updatedTs.toLocalDateTime());
        }

        return p;
    }
}

package com.dcms.dao;

import com.dcms.model.Dentist;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Dentists table joined with Users in SQL Server.
 */
public class DentistDAO {

    private static final Logger LOGGER = Logger.getLogger(DentistDAO.class.getName());

    public List<Dentist> findAll() {
        return listAllDentists();
    }

    public List<Dentist> listAllDentists() {
        List<Dentist> list = new ArrayList<>();
        String sql = "SELECT d.DentistId, d.LicenseNumber, d.Specialization, d.RoomNumber, " +
                     "u.FullName, u.Phone, u.Email " +
                     "FROM dbo.Dentists d " +
                     "JOIN dbo.Users u ON d.DentistId = u.UserId " +
                     "WHERE u.IsActive = 1 " +
                     "ORDER BY u.FullName ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Dentist d = new Dentist();
                d.setDentistId(rs.getInt("DentistId"));
                d.setLicenseNumber(rs.getString("LicenseNumber"));
                d.setSpecialization(rs.getString("Specialization"));
                d.setRoomNumber(rs.getString("RoomNumber"));
                d.setFullName(rs.getString("FullName"));
                d.setPhone(rs.getString("Phone"));
                d.setEmail(rs.getString("Email"));
                list.add(d);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing all dentists", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public Dentist findById(int dentistId) {
        String sql = "SELECT d.DentistId, d.LicenseNumber, d.Specialization, d.RoomNumber, " +
                     "u.FullName, u.Phone " +
                     "FROM dbo.Dentists d " +
                     "JOIN dbo.Users u ON d.DentistId = u.UserId " +
                     "WHERE d.DentistId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dentistId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Dentist d = new Dentist();
                d.setDentistId(rs.getInt("DentistId"));
                d.setLicenseNumber(rs.getString("LicenseNumber"));
                d.setSpecialization(rs.getString("Specialization"));
                d.setRoomNumber(rs.getString("RoomNumber"));
                d.setFullName(rs.getString("FullName"));
                d.setPhone(rs.getString("Phone"));
                return d;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findById for dentistId: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }
}

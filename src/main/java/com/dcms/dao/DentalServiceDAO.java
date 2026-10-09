package com.dcms.dao;

import com.dcms.model.DentalService;
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
 * Data Access Object for DentalServices catalog table.
 */
public class DentalServiceDAO {

    private static final Logger LOGGER = Logger.getLogger(DentalServiceDAO.class.getName());

    public List<DentalService> findAllActive() {
        return findAll(true);
    }

    public List<DentalService> findAll(boolean onlyActive) {
        List<DentalService> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT ServiceId, ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive, CreatedAt, UpdatedAt FROM dbo.DentalServices ");
        if (onlyActive) {
            sql.append("WHERE IsActive = 1 ");
        }
        sql.append("ORDER BY Category ASC, Price ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing dental services", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<DentalService> findByCategory(String category, boolean onlyActive) {
        List<DentalService> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT ServiceId, ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive, CreatedAt, UpdatedAt FROM dbo.DentalServices WHERE Category = ? ");
        if (onlyActive) {
            sql.append("AND IsActive = 1 ");
        }
        sql.append("ORDER BY Price ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, category);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding dental services by category: " + category, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public DentalService findById(int serviceId) {
        String sql = "SELECT ServiceId, ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive, CreatedAt, UpdatedAt FROM dbo.DentalServices WHERE ServiceId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding dental service by ID: " + serviceId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public DentalService findByCode(String serviceCode) {
        if (serviceCode == null) return null;
        String sql = "SELECT ServiceId, ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive, CreatedAt, UpdatedAt FROM dbo.DentalServices WHERE LOWER(ServiceCode) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, serviceCode.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding dental service by code: " + serviceCode, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public int insert(DentalService service) {
        String sql = "INSERT INTO dbo.DentalServices (ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, service.getServiceCode().trim());
            ps.setString(2, service.getServiceName().trim());
            ps.setString(3, service.getCategory());
            ps.setBigDecimal(4, service.getPrice());
            ps.setString(5, service.getUnit() != null ? service.getUnit().trim() : "Lần");
            ps.setString(6, service.getDescription());
            ps.setBoolean(7, service.isActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting dental service: " + service.getServiceCode(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public boolean update(DentalService service) {
        String sql = "UPDATE dbo.DentalServices SET ServiceCode = ?, ServiceName = ?, Category = ?, Price = ?, Unit = ?, Description = ?, IsActive = ?, UpdatedAt = SYSDATETIME() WHERE ServiceId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, service.getServiceCode().trim());
            ps.setString(2, service.getServiceName().trim());
            ps.setString(3, service.getCategory());
            ps.setBigDecimal(4, service.getPrice());
            ps.setString(5, service.getUnit() != null ? service.getUnit().trim() : "Lần");
            ps.setString(6, service.getDescription());
            ps.setBoolean(7, service.isActive());
            ps.setInt(8, service.getServiceId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating dental service ID: " + service.getServiceId(), ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean toggleStatus(int serviceId) {
        String sql = "UPDATE dbo.DentalServices SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END, UpdatedAt = SYSDATETIME() WHERE ServiceId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error toggling status for dental service ID: " + serviceId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private DentalService mapResultSetToService(ResultSet rs) throws SQLException {
        DentalService s = new DentalService();
        s.setServiceId(rs.getInt("ServiceId"));
        s.setServiceCode(rs.getString("ServiceCode"));
        s.setServiceName(rs.getString("ServiceName"));
        s.setCategory(rs.getString("Category"));
        s.setPrice(rs.getBigDecimal("Price"));
        s.setUnit(rs.getString("Unit"));
        s.setDescription(rs.getString("Description"));
        s.setActive(rs.getBoolean("IsActive"));
        Timestamp ct = rs.getTimestamp("CreatedAt");
        if (ct != null) s.setCreatedAt(ct.toLocalDateTime());
        Timestamp ut = rs.getTimestamp("UpdatedAt");
        if (ut != null) s.setUpdatedAt(ut.toLocalDateTime());
        return s;
    }
}

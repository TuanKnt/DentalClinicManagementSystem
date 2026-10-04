package com.dcms.dao;

import com.dcms.model.User;
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
 * Data Access Object for Users table in SQL Server.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Find user by unique username, joining Roles to retrieve role name.
     */
    public User findByUsername(String username) {
        String sql = "SELECT u.UserId, u.Username, u.PasswordHash, u.FullName, u.Email, u.Phone, " +
                     "u.RoleId, r.RoleName, u.IsActive, u.CreatedAt, u.UpdatedAt " +
                     "FROM dbo.Users u " +
                     "JOIN dbo.Roles r ON u.RoleId = r.RoleId " +
                     "WHERE u.Username = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findByUsername for user: " + username, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * Find user by primary key ID.
     */
    public User findById(int userId) {
        String sql = "SELECT u.UserId, u.Username, u.PasswordHash, u.FullName, u.Email, u.Phone, " +
                     "u.RoleId, r.RoleName, u.IsActive, u.CreatedAt, u.UpdatedAt " +
                     "FROM dbo.Users u " +
                     "JOIN dbo.Roles r ON u.RoleId = r.RoleId " +
                     "WHERE u.UserId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findById for userId: " + userId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * Insert a new user into Users table.
     */
    public int createUser(User user) {
        String sql = "INSERT INTO dbo.Users (Username, PasswordHash, FullName, Email, Phone, RoleId, IsActive, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRoleId());
            ps.setBoolean(7, user.isActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    user.setUserId(generatedId);
                    return generatedId;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting new user: " + user.getUsername(), ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    /**
     * Update password hash for user.
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE dbo.Users SET PasswordHash = ?, UpdatedAt = SYSDATETIME() WHERE UserId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating password for userId: " + userId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserId"));
        user.setUsername(rs.getString("Username"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setFullName(rs.getString("FullName"));
        user.setEmail(rs.getString("Email"));
        user.setPhone(rs.getString("Phone"));
        user.setRoleId(rs.getInt("RoleId"));
        user.setRoleName(rs.getString("RoleName"));
        user.setActive(rs.getBoolean("IsActive"));

        Timestamp createdTs = rs.getTimestamp("CreatedAt");
        if (createdTs != null) {
            user.setCreatedAt(createdTs.toLocalDateTime());
        }

        Timestamp updatedTs = rs.getTimestamp("UpdatedAt");
        if (updatedTs != null) {
            user.setUpdatedAt(updatedTs.toLocalDateTime());
        }

        return user;
    }
}

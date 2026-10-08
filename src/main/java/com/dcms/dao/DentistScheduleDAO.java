package com.dcms.dao;

import com.dcms.model.DentistSchedule;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for DentistSchedules in SQL Server.
 */
public class DentistScheduleDAO {

    private static final Logger LOGGER = Logger.getLogger(DentistScheduleDAO.class.getName());

    /**
     * Checks if dentist has an active working shift covering [start, end] on specified day of week.
     */
    public boolean isDentistWorking(int dentistId, int dayOfWeek, LocalTime start, LocalTime end) {
        String sql = "SELECT COUNT(*) FROM dbo.DentistSchedules " +
                     "WHERE DentistId = ? AND DayOfWeek = ? AND IsAvailable = 1 " +
                     "AND ShiftStart <= ? AND ShiftEnd >= ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dentistId);
            ps.setInt(2, dayOfWeek);
            ps.setTime(3, Time.valueOf(start));
            ps.setTime(4, Time.valueOf(end));

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking isDentistWorking for dentist: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return false;
    }

    public List<DentistSchedule> listSchedulesByDentist(int dentistId) {
        List<DentistSchedule> list = new ArrayList<>();
        String sql = "SELECT ds.ScheduleId, ds.DentistId, ds.DayOfWeek, ds.ShiftStart, ds.ShiftEnd, ds.IsAvailable, " +
                     "u.FullName AS DentistName, d.Specialization, d.RoomNumber " +
                     "FROM dbo.DentistSchedules ds " +
                     "JOIN dbo.Dentists d ON ds.DentistId = d.DentistId " +
                     "JOIN dbo.Users u ON d.DentistId = u.UserId " +
                     "WHERE ds.DentistId = ? ORDER BY ds.DayOfWeek ASC, ds.ShiftStart ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dentistId);
            rs = ps.executeQuery();
            while (rs.next()) {
                DentistSchedule s = mapResultSetToSchedule(rs);
                list.add(s);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing schedules for dentist: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public List<DentistSchedule> listAllSchedulesWithDentist(Integer dentistId) {
        List<DentistSchedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ds.ScheduleId, ds.DentistId, ds.DayOfWeek, ds.ShiftStart, ds.ShiftEnd, ds.IsAvailable, " +
                "u.FullName AS DentistName, d.Specialization, d.RoomNumber " +
                "FROM dbo.DentistSchedules ds " +
                "JOIN dbo.Dentists d ON ds.DentistId = d.DentistId " +
                "JOIN dbo.Users u ON d.DentistId = u.UserId "
        );
        if (dentistId != null && dentistId > 0) {
            sql.append("WHERE ds.DentistId = ? ");
        }
        sql.append("ORDER BY ds.DayOfWeek ASC, ds.ShiftStart ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            if (dentistId != null && dentistId > 0) {
                ps.setInt(1, dentistId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                DentistSchedule s = mapResultSetToSchedule(rs);
                list.add(s);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing all schedules with dentist", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    public int createSchedule(DentistSchedule schedule) {
        String sql = "INSERT INTO dbo.DentistSchedules (DentistId, DayOfWeek, ShiftStart, ShiftEnd, IsAvailable) " +
                     "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, schedule.getDentistId());
            ps.setInt(2, schedule.getDayOfWeek());
            ps.setTime(3, Time.valueOf(schedule.getShiftStart()));
            ps.setTime(4, Time.valueOf(schedule.getShiftEnd()));
            ps.setBoolean(5, schedule.isAvailable());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting dentist schedule", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM dbo.DentistSchedules WHERE ScheduleId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting dentist schedule: " + scheduleId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean toggleAvailability(int scheduleId, boolean isAvailable) {
        String sql = "UPDATE dbo.DentistSchedules SET IsAvailable = ? WHERE ScheduleId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error toggling schedule availability: " + scheduleId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean checkScheduleOverlap(int dentistId, int dayOfWeek, LocalTime start, LocalTime end, Integer excludeScheduleId) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM dbo.DentistSchedules " +
                "WHERE DentistId = ? AND DayOfWeek = ? " +
                "AND ShiftStart < ? AND ShiftEnd > ? "
        );
        if (excludeScheduleId != null && excludeScheduleId > 0) {
            sql.append("AND ScheduleId <> ?");
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, dentistId);
            ps.setInt(2, dayOfWeek);
            ps.setTime(3, Time.valueOf(end));
            ps.setTime(4, Time.valueOf(start));
            if (excludeScheduleId != null && excludeScheduleId > 0) {
                ps.setInt(5, excludeScheduleId);
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking schedule overlap for dentist: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return false;
    }

    private DentistSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        DentistSchedule s = new DentistSchedule();
        s.setScheduleId(rs.getInt("ScheduleId"));
        s.setDentistId(rs.getInt("DentistId"));
        s.setDayOfWeek(rs.getInt("DayOfWeek"));
        s.setShiftStart(rs.getTime("ShiftStart").toLocalTime());
        s.setShiftEnd(rs.getTime("ShiftEnd").toLocalTime());
        s.setAvailable(rs.getBoolean("IsAvailable"));

        try {
            s.setDentistName(rs.getString("DentistName"));
            s.setSpecialization(rs.getString("Specialization"));
            s.setRoomNumber(rs.getString("RoomNumber"));
        } catch (SQLException ignored) {
            // In case columns not in query
        }
        return s;
    }
}

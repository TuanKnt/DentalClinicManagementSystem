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
        String sql = "SELECT ScheduleId, DentistId, DayOfWeek, ShiftStart, ShiftEnd, IsAvailable " +
                     "FROM dbo.DentistSchedules WHERE DentistId = ? ORDER BY DayOfWeek ASC, ShiftStart ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dentistId);
            rs = ps.executeQuery();
            while (rs.next()) {
                DentistSchedule s = new DentistSchedule();
                s.setScheduleId(rs.getInt("ScheduleId"));
                s.setDentistId(rs.getInt("DentistId"));
                s.setDayOfWeek(rs.getInt("DayOfWeek"));
                s.setShiftStart(rs.getTime("ShiftStart").toLocalTime());
                s.setShiftEnd(rs.getTime("ShiftEnd").toLocalTime());
                s.setAvailable(rs.getBoolean("IsAvailable"));
                list.add(s);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing schedules for dentist: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }
}

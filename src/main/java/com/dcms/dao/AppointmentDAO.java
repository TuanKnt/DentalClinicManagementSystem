package com.dcms.dao;

import com.dcms.model.Appointment;
import com.dcms.util.DBContext;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Appointments table in SQL Server.
 */
public class AppointmentDAO {

    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());

    public int create(Appointment appt) {
        String sql = "INSERT INTO dbo.Appointments (PatientId, DentistId, AppointmentDate, StartTime, EndTime, Reason, Status, Notes, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getDentistId());
            ps.setDate(3, Date.valueOf(appt.getAppointmentDate()));
            ps.setTime(4, Time.valueOf(appt.getStartTime()));
            ps.setTime(5, Time.valueOf(appt.getEndTime()));
            ps.setString(6, appt.getReason());
            ps.setString(7, appt.getStatus());
            ps.setString(8, appt.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    appt.setAppointmentId(id);
                    return id;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error creating appointment", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return -1;
    }

    public Appointment findById(int appointmentId) {
        String sql = "SELECT a.AppointmentId, a.PatientId, a.DentistId, a.AppointmentDate, a.StartTime, a.EndTime, " +
                     "a.Reason, a.Status, a.Notes, a.CreatedAt, a.UpdatedAt, " +
                     "p.FullName AS PatientName, p.Phone AS PatientPhone, du.FullName AS DentistName " +
                     "FROM dbo.Appointments a " +
                     "JOIN dbo.Patients p ON a.PatientId = p.PatientId " +
                     "JOIN dbo.Dentists d ON a.DentistId = d.DentistId " +
                     "JOIN dbo.Users du ON d.DentistId = du.UserId " +
                     "WHERE a.AppointmentId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in findById for appointmentId: " + appointmentId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * Checks if there are conflicting appointments for the same dentist on the same date.
     * Considers statuses: 'Pending', 'Confirmed', 'Arrived'.
     * Overlap condition: StartTime < TargetEndTime AND EndTime > TargetStartTime
     */
    public int countConflicts(int dentistId, LocalDate date, LocalTime start, LocalTime end, Integer excludeAppointmentId) {
        String sql = "SELECT COUNT(*) FROM dbo.Appointments " +
                     "WHERE DentistId = ? AND AppointmentDate = ? " +
                     "AND Status IN ('Pending', 'Confirmed', 'Arrived') " +
                     "AND (StartTime < ? AND EndTime > ?) " +
                     "AND (? IS NULL OR AppointmentId <> ?)";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dentistId);
            ps.setDate(2, Date.valueOf(date));
            ps.setTime(3, Time.valueOf(end));
            ps.setTime(4, Time.valueOf(start));

            if (excludeAppointmentId != null) {
                ps.setInt(5, excludeAppointmentId);
                ps.setInt(6, excludeAppointmentId);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
                ps.setNull(6, java.sql.Types.INTEGER);
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting conflicts for dentist: " + dentistId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public boolean updateStatus(int appointmentId, String newStatus) {
        String sql = "UPDATE dbo.Appointments SET Status = ?, UpdatedAt = SYSDATETIME() WHERE AppointmentId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status: " + appointmentId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean cancelWithReason(int appointmentId, String reason) {
        String sql = "UPDATE dbo.Appointments SET Status = 'Cancelled', " +
                     "Notes = ISNULL(Notes + ' | ', '') + 'Lý do hủy: ' + ?, " +
                     "UpdatedAt = SYSDATETIME() WHERE AppointmentId = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error cancelling appointment: " + appointmentId, ex);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public List<Appointment> listAppointmentsByDate(LocalDate date, Integer dentistId) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.AppointmentId, a.PatientId, a.DentistId, a.AppointmentDate, a.StartTime, a.EndTime, " +
            "a.Reason, a.Status, a.Notes, a.CreatedAt, a.UpdatedAt, " +
            "p.FullName AS PatientName, p.Phone AS PatientPhone, du.FullName AS DentistName " +
            "FROM dbo.Appointments a " +
            "JOIN dbo.Patients p ON a.PatientId = p.PatientId " +
            "JOIN dbo.Dentists d ON a.DentistId = d.DentistId " +
            "JOIN dbo.Users du ON d.DentistId = du.UserId " +
            "WHERE a.AppointmentDate = ? "
        );

        if (dentistId != null && dentistId > 0) {
            sql.append("AND a.DentistId = ? ");
        }
        sql.append("ORDER BY a.StartTime ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setDate(1, Date.valueOf(date));
            if (dentistId != null && dentistId > 0) {
                ps.setInt(2, dentistId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing appointments by date: " + date, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("AppointmentId"));
        a.setPatientId(rs.getInt("PatientId"));
        a.setDentistId(rs.getInt("DentistId"));
        a.setAppointmentDate(rs.getDate("AppointmentDate").toLocalDate());
        a.setStartTime(rs.getTime("StartTime").toLocalTime());
        a.setEndTime(rs.getTime("EndTime").toLocalTime());
        a.setReason(rs.getString("Reason"));
        a.setStatus(rs.getString("Status"));
        a.setNotes(rs.getString("Notes"));

        a.setPatientName(rs.getString("PatientName"));
        a.setPatientPhone(rs.getString("PatientPhone"));
        a.setDentistName(rs.getString("DentistName"));

        Timestamp createdTs = rs.getTimestamp("CreatedAt");
        if (createdTs != null) a.setCreatedAt(createdTs.toLocalDateTime());
        Timestamp updatedTs = rs.getTimestamp("UpdatedAt");
        if (updatedTs != null) a.setUpdatedAt(updatedTs.toLocalDateTime());

        return a;
    }
}

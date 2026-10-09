package com.dcms.dao;

import com.dcms.model.TreatmentPlan;
import com.dcms.model.TreatmentPlanItem;
import com.dcms.util.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for TreatmentPlans and TreatmentPlanItems (UC19, UC20, UC21, UC23).
 */
public class TreatmentPlanDAO {

    private static final Logger LOGGER = Logger.getLogger(TreatmentPlanDAO.class.getName());

    private static final String SELECT_PLAN_BASE =
            "SELECT tp.PlanId, tp.PatientId, tp.DentistId, tp.Title, tp.Diagnosis, tp.Status, " +
            "       tp.EstimatedCost, tp.TotalDiscount, tp.FinalEstimate, tp.PatientConsentDate, " +
            "       tp.ConsentNotes, tp.Notes, tp.CreatedAt, tp.UpdatedAt, " +
            "       p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender AS PatientGender, " +
            "       du.FullName AS DentistName, d.Specialization AS DentistSpecialization " +
            "FROM dbo.TreatmentPlans tp " +
            "JOIN dbo.Patients p ON tp.PatientId = p.PatientId " +
            "JOIN dbo.Dentists d ON tp.DentistId = d.DentistId " +
            "JOIN dbo.Users du ON d.DentistId = du.UserId ";

    private static final String SELECT_ITEM_BASE =
            "SELECT tpi.ItemId, tpi.PlanId, tpi.ServiceId, tpi.ToothNumber, tpi.Surface, " +
            "       tpi.Quantity, tpi.UnitPrice, tpi.SubTotal, tpi.PriorityOrder, tpi.Status, " +
            "       tpi.Notes, tpi.CreatedAt, " +
            "       s.ServiceCode, s.ServiceName, s.Category, s.Unit " +
            "FROM dbo.TreatmentPlanItems tpi " +
            "JOIN dbo.DentalServices s ON tpi.ServiceId = s.ServiceId ";

    /**
     * Retrieve all treatment plans ordered by creation date descending.
     */
    public List<TreatmentPlan> findAll() {
        List<TreatmentPlan> list = new ArrayList<>();
        String sql = SELECT_PLAN_BASE + "ORDER BY tp.CreatedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPlan(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error querying all treatment plans", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * Find treatment plans for a specific patient.
     */
    public List<TreatmentPlan> findByPatientId(int patientId) {
        List<TreatmentPlan> list = new ArrayList<>();
        String sql = SELECT_PLAN_BASE + "WHERE tp.PatientId = ? ORDER BY tp.CreatedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPlan(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error querying treatment plans by patient ID: " + patientId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * Find treatment plan by primary key, including itemized procedure list.
     */
    public TreatmentPlan findById(int planId) {
        String sql = SELECT_PLAN_BASE + "WHERE tp.PlanId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        TreatmentPlan plan = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, planId);
            rs = ps.executeQuery();
            if (rs.next()) {
                plan = mapResultSetToPlan(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding treatment plan by ID: " + planId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        if (plan != null) {
            plan.setItems(findItemsByPlanId(planId));
        }
        return plan;
    }

    /**
     * Insert a new treatment plan and return the generated planId.
     */
    public int insert(TreatmentPlan plan) {
        String sql = "INSERT INTO dbo.TreatmentPlans (PatientId, DentistId, Title, Diagnosis, Status, " +
                     "EstimatedCost, TotalDiscount, FinalEstimate, Notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, plan.getPatientId());
            ps.setInt(2, plan.getDentistId());
            ps.setString(3, plan.getTitle());
            ps.setString(4, plan.getDiagnosis());
            ps.setString(5, plan.getStatus() != null ? plan.getStatus() : "Draft");
            ps.setBigDecimal(6, plan.getEstimatedCost() != null ? plan.getEstimatedCost() : BigDecimal.ZERO);
            ps.setBigDecimal(7, plan.getTotalDiscount() != null ? plan.getTotalDiscount() : BigDecimal.ZERO);
            ps.setBigDecimal(8, plan.getFinalEstimate() != null ? plan.getFinalEstimate() : BigDecimal.ZERO);
            ps.setString(9, plan.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    plan.setPlanId(generatedId);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting treatment plan", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return generatedId;
    }

    /**
     * Update treatment plan information and cost totals.
     */
    public boolean update(TreatmentPlan plan) {
        String sql = "UPDATE dbo.TreatmentPlans SET Title = ?, Diagnosis = ?, Status = ?, " +
                     "EstimatedCost = ?, TotalDiscount = ?, FinalEstimate = ?, Notes = ?, UpdatedAt = SYSDATETIME() " +
                     "WHERE PlanId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, plan.getTitle());
            ps.setString(2, plan.getDiagnosis());
            ps.setString(3, plan.getStatus());
            ps.setBigDecimal(4, plan.getEstimatedCost());
            ps.setBigDecimal(5, plan.getTotalDiscount());
            ps.setBigDecimal(6, plan.getFinalEstimate());
            ps.setString(7, plan.getNotes());
            ps.setInt(8, plan.getPlanId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating treatment plan: " + plan.getPlanId(), ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Update plan status and record patient consent if accepted.
     */
    public boolean updateStatus(int planId, String status, String consentNotes) {
        String sql;
        boolean isAcceptance = "Accepted".equalsIgnoreCase(status) || "PartiallyAccepted".equalsIgnoreCase(status);

        if (isAcceptance) {
            sql = "UPDATE dbo.TreatmentPlans SET Status = ?, PatientConsentDate = SYSDATETIME(), " +
                  "ConsentNotes = ?, UpdatedAt = SYSDATETIME() WHERE PlanId = ?";
        } else {
            sql = "UPDATE dbo.TreatmentPlans SET Status = ?, ConsentNotes = ?, UpdatedAt = SYSDATETIME() WHERE PlanId = ?";
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, consentNotes);
            ps.setInt(3, planId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating plan status for planId: " + planId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Get all procedure items belonging to a treatment plan.
     */
    public List<TreatmentPlanItem> findItemsByPlanId(int planId) {
        List<TreatmentPlanItem> list = new ArrayList<>();
        String sql = SELECT_ITEM_BASE + "WHERE tpi.PlanId = ? ORDER BY tpi.PriorityOrder ASC, tpi.ItemId ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, planId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToItem(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error querying items for plan ID: " + planId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * Find a single treatment plan item by ID.
     */
    public TreatmentPlanItem findItemById(int itemId) {
        String sql = SELECT_ITEM_BASE + "WHERE tpi.ItemId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        TreatmentPlanItem item = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            rs = ps.executeQuery();
            if (rs.next()) {
                item = mapResultSetToItem(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding treatment plan item by ID: " + itemId, ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return item;
    }

    /**
     * Insert a new procedure item into a treatment plan and return generated itemId.
     */
    public int insertItem(TreatmentPlanItem item) {
        String sql = "INSERT INTO dbo.TreatmentPlanItems (PlanId, ServiceId, ToothNumber, Surface, " +
                     "Quantity, UnitPrice, SubTotal, PriorityOrder, Status, Notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, item.getPlanId());
            ps.setInt(2, item.getServiceId());
            if (item.getToothNumber() != null && item.getToothNumber() > 0) {
                ps.setInt(3, item.getToothNumber());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, item.getSurface() != null ? item.getSurface() : "WholeTooth");
            ps.setInt(5, item.getQuantity() > 0 ? item.getQuantity() : 1);
            ps.setBigDecimal(6, item.getUnitPrice());
            item.calculateSubTotal();
            ps.setBigDecimal(7, item.getSubTotal());
            ps.setInt(8, item.getPriorityOrder() > 0 ? item.getPriorityOrder() : 1);
            ps.setString(9, item.getStatus() != null ? item.getStatus() : "Proposed");
            ps.setString(10, item.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    item.setItemId(generatedId);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting treatment plan item", ex);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        if (generatedId > 0) {
            recalculatePlanEstimates(item.getPlanId());
        }
        return generatedId;
    }

    /**
     * Delete an item from a treatment plan and recalculate estimates.
     */
    public boolean deleteItem(int itemId, int planId) {
        String sql = "DELETE FROM dbo.TreatmentPlanItems WHERE ItemId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            boolean success = ps.executeUpdate() > 0;
            if (success && planId > 0) {
                recalculatePlanEstimates(planId);
            }
            return success;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting treatment plan item: " + itemId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Update the progress status of a treatment plan item.
     */
    public boolean updateItemStatus(int itemId, String status) {
        String sql = "UPDATE dbo.TreatmentPlanItems SET Status = ? WHERE ItemId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, itemId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating item status for itemId: " + itemId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Recalculate plan estimatedCost and finalEstimate based on current items.
     */
    public void recalculatePlanEstimates(int planId) {
        String sumSql = "SELECT ISNULL(SUM(SubTotal), 0) FROM dbo.TreatmentPlanItems WHERE PlanId = ? AND Status != 'Cancelled'";
        String updateSql = "UPDATE dbo.TreatmentPlans SET EstimatedCost = ?, " +
                           "FinalEstimate = CASE WHEN ? - TotalDiscount < 0 THEN 0 ELSE ? - TotalDiscount END, " +
                           "UpdatedAt = SYSDATETIME() WHERE PlanId = ?";

        Connection conn = null;
        PreparedStatement psSum = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            psSum = conn.prepareStatement(sumSql);
            psSum.setInt(1, planId);
            rs = psSum.executeQuery();
            BigDecimal estimatedCost = BigDecimal.ZERO;
            if (rs.next()) {
                estimatedCost = rs.getBigDecimal(1);
            }

            psUpdate = conn.prepareStatement(updateSql);
            psUpdate.setBigDecimal(1, estimatedCost);
            psUpdate.setBigDecimal(2, estimatedCost);
            psUpdate.setBigDecimal(3, estimatedCost);
            psUpdate.setInt(4, planId);
            psUpdate.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error recalculating estimates for planId: " + planId, ex);
        } finally {
            DBContext.close(null, psSum, rs);
            DBContext.close(conn, psUpdate, null);
        }
    }

    /**
     * Record patient acceptance/consent with timestamp and notes (UC22).
     */
    public boolean recordConsent(int planId, String status, String consentNotes, LocalDateTime consentDate) {
        String sql = "UPDATE dbo.TreatmentPlans SET Status = ?, PatientConsentDate = ?, " +
                     "ConsentNotes = ?, UpdatedAt = SYSDATETIME() WHERE PlanId = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            if (consentDate != null) {
                ps.setTimestamp(2, Timestamp.valueOf(consentDate));
            } else {
                ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            }
            ps.setString(3, consentNotes);
            ps.setInt(4, planId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error recording patient consent for planId: " + planId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    /**
     * Update status of all items in a treatment plan (e.g. to Accepted or Declined upon consent).
     */
    public boolean updateItemsStatusByPlanId(int planId, String newStatus) {
        String sql = "UPDATE dbo.TreatmentPlanItems SET Status = ? WHERE PlanId = ? AND Status != 'Cancelled'";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, planId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating item status for planId: " + planId, ex);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    private TreatmentPlan mapResultSetToPlan(ResultSet rs) throws SQLException {
        TreatmentPlan plan = new TreatmentPlan();
        plan.setPlanId(rs.getInt("PlanId"));
        plan.setPatientId(rs.getInt("PatientId"));
        plan.setDentistId(rs.getInt("DentistId"));
        plan.setTitle(rs.getString("Title"));
        plan.setDiagnosis(rs.getString("Diagnosis"));
        plan.setStatus(rs.getString("Status"));
        plan.setEstimatedCost(rs.getBigDecimal("EstimatedCost"));
        plan.setTotalDiscount(rs.getBigDecimal("TotalDiscount"));
        plan.setFinalEstimate(rs.getBigDecimal("FinalEstimate"));

        Timestamp consentTs = rs.getTimestamp("PatientConsentDate");
        if (consentTs != null) {
            plan.setPatientConsentDate(consentTs.toLocalDateTime());
        }
        plan.setConsentNotes(rs.getString("ConsentNotes"));
        plan.setNotes(rs.getString("Notes"));

        Timestamp createdTs = rs.getTimestamp("CreatedAt");
        if (createdTs != null) {
            plan.setCreatedAt(createdTs.toLocalDateTime());
        }
        Timestamp updatedTs = rs.getTimestamp("UpdatedAt");
        if (updatedTs != null) {
            plan.setUpdatedAt(updatedTs.toLocalDateTime());
        }

        plan.setPatientName(rs.getString("PatientName"));
        plan.setPatientPhone(rs.getString("PatientPhone"));
        plan.setPatientGender(rs.getString("PatientGender"));
        plan.setDentistName(rs.getString("DentistName"));
        plan.setDentistSpecialization(rs.getString("DentistSpecialization"));

        return plan;
    }

    private TreatmentPlanItem mapResultSetToItem(ResultSet rs) throws SQLException {
        TreatmentPlanItem item = new TreatmentPlanItem();
        item.setItemId(rs.getInt("ItemId"));
        item.setPlanId(rs.getInt("PlanId"));
        item.setServiceId(rs.getInt("ServiceId"));

        int tooth = rs.getInt("ToothNumber");
        if (!rs.wasNull()) {
            item.setToothNumber(tooth);
        } else {
            item.setToothNumber(null);
        }

        item.setSurface(rs.getString("Surface"));
        item.setQuantity(rs.getInt("Quantity"));
        item.setUnitPrice(rs.getBigDecimal("UnitPrice"));
        item.setSubTotal(rs.getBigDecimal("SubTotal"));
        item.setPriorityOrder(rs.getInt("PriorityOrder"));
        item.setStatus(rs.getString("Status"));
        item.setNotes(rs.getString("Notes"));

        Timestamp createdTs = rs.getTimestamp("CreatedAt");
        if (createdTs != null) {
            item.setCreatedAt(createdTs.toLocalDateTime());
        }

        item.setServiceCode(rs.getString("ServiceCode"));
        item.setServiceName(rs.getString("ServiceName"));
        item.setCategory(rs.getString("Category"));
        item.setUnit(rs.getString("Unit"));

        return item;
    }
}

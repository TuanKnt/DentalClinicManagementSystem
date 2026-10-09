package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.dao.ProcedurePerformedDAO;
import com.dcms.dao.TreatmentPlanDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.DentalService;
import com.dcms.model.MaterialUsage;
import com.dcms.model.ProcedurePerformed;
import com.dcms.model.TreatmentPlan;
import com.dcms.model.TreatmentPlanItem;
import com.dcms.model.Visit;
import com.dcms.service.exception.BusinessRuleViolationException;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Service encapsulating chairside procedure execution, status lifecycle and material tracking (UC24, UC25, UC26).
 * Managed by Wolf (Clinical Treatment & Chairside Procedures).
 * NON-NEGOTIABLE RULES:
 * 1. Appointment != Visit (Procedures are strictly performed inside a Visit).
 * 2. TreatmentPlanItem != ProcedurePerformed (Chairside execution syncs item progress).
 * 3. Invoices are ONLY generated from completed ProcedurePerformed records.
 */
public class ClinicalProcedureService {

    private static final Set<String> VALID_SURFACES = new HashSet<>(Arrays.asList(
            "WholeTooth", "Occlusal", "Mesial", "Distal", "Buccal", "Lingual"
    ));

    private final ProcedurePerformedDAO procedureDAO;
    private final DentalServiceDAO serviceDAO;
    private final VisitDAO visitDAO;
    private final TreatmentPlanDAO planDAO;

    public ClinicalProcedureService() {
        this.procedureDAO = new ProcedurePerformedDAO();
        this.serviceDAO = new DentalServiceDAO();
        this.visitDAO = new VisitDAO();
        this.planDAO = new TreatmentPlanDAO();
    }

    public ClinicalProcedureService(ProcedurePerformedDAO procedureDAO, DentalServiceDAO serviceDAO,
                                   VisitDAO visitDAO, TreatmentPlanDAO planDAO) {
        this.procedureDAO = procedureDAO;
        this.serviceDAO = serviceDAO;
        this.visitDAO = visitDAO;
        this.planDAO = planDAO;
    }

    /**
     * Record a clinical procedure performed at the dental chair (UC24).
     */
    public ProcedurePerformed recordProcedure(int visitId, int dentistId, Integer assistantId,
                                              Integer planItemId, int serviceId, Integer toothNumber,
                                              String surface, int quantity, BigDecimal actualPrice,
                                              String clinicalNotes) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã buổi khám (Visit) không hợp lệ.");
        }
        Visit visit = visitDAO.getVisitById(visitId);
        if (visit == null) {
            throw new BusinessRuleViolationException("Buổi khám #" + visitId + " không tồn tại trong hệ thống.");
        }
        if ("CheckedOut".equalsIgnoreCase(visit.getStatus()) || "Cancelled".equalsIgnoreCase(visit.getStatus())) {
            throw new BusinessRuleViolationException("Không thể thực hiện thủ thuật cho buổi khám đã hoàn tất xuất viện hoặc đã hủy.");
        }

        if (dentistId <= 0) {
            throw new IllegalArgumentException("Bác sĩ thực hiện không hợp lệ.");
        }

        DentalService service = serviceDAO.findById(serviceId);
        if (service == null || !service.isActive()) {
            throw new BusinessRuleViolationException("Dịch vụ nha khoa được chọn không tồn tại hoặc đã tạm ngưng hoạt động.");
        }

        // Validate FDI Tooth Number if given
        if (toothNumber != null && toothNumber > 0) {
            TreatmentPlanService.validateFdiToothNumber(toothNumber);
        } else {
            toothNumber = null;
        }

        // Validate surface
        String cleanSurface = "WholeTooth";
        if (surface != null && !surface.trim().isEmpty()) {
            if (!VALID_SURFACES.contains(surface.trim())) {
                throw new IllegalArgumentException("Mặt răng không hợp lệ: '" + surface + "'. Hỗ trợ: Occlusal, Mesial, Distal, Buccal, Lingual, WholeTooth.");
            }
            cleanSurface = surface.trim();
        }

        if (quantity <= 0) {
            quantity = 1;
        }

        BigDecimal effectivePrice = actualPrice;
        if (effectivePrice == null || effectivePrice.compareTo(BigDecimal.ZERO) < 0) {
            effectivePrice = service.getPrice();
        }

        ProcedurePerformed proc = new ProcedurePerformed(visitId, dentistId, assistantId, planItemId,
                serviceId, toothNumber, cleanSurface, quantity, effectivePrice, clinicalNotes);
        proc.setStatus("Completed"); // Default to completed upon doctor execution

        int procedureId = procedureDAO.insert(proc);
        if (procedureId <= 0) {
            throw new RuntimeException("Lỗi hệ thống khi lưu thủ thuật lâm sàng.");
        }
        proc.setProcedureId(procedureId);
        proc.setServiceCode(service.getServiceCode());
        proc.setServiceName(service.getServiceName());
        proc.setServiceUnit(service.getUnit());

        // Synchronize TreatmentPlanItem if linked (Iron Rule 2)
        if (planItemId != null && planItemId > 0) {
            TreatmentPlanItem item = planDAO.findItemById(planItemId);
            if (item != null) {
                item.setStatus("Completed");
                planDAO.updateItemStatus(planItemId, "Completed");
                syncTreatmentPlanProgress(item.getPlanId());
            }
        }

        return proc;
    }

    /**
     * Complete an in-progress procedure (UC25).
     */
    public boolean completeProcedure(int procedureId, String clinicalNotes) {
        ProcedurePerformed proc = procedureDAO.findById(procedureId);
        if (proc == null) {
            throw new IllegalArgumentException("Thủ thuật lâm sàng #" + procedureId + " không tồn tại.");
        }
        if ("Completed".equalsIgnoreCase(proc.getStatus())) {
            return true;
        }

        boolean success = procedureDAO.updateStatus(procedureId, "Completed", clinicalNotes);
        if (success && proc.getPlanItemId() != null && proc.getPlanItemId() > 0) {
            TreatmentPlanItem item = planDAO.findItemById(proc.getPlanItemId());
            if (item != null) {
                planDAO.updateItemStatus(proc.getPlanItemId(), "Completed");
                syncTreatmentPlanProgress(item.getPlanId());
            }
        }
        return success;
    }

    /**
     * Record consumable material used during a procedure (UC26).
     */
    public MaterialUsage recordMaterialUsage(int procedureId, String materialName, int quantity,
                                             String unit, String notes) {
        if (procedureId <= 0) {
            throw new IllegalArgumentException("Mã thủ thuật không hợp lệ.");
        }
        ProcedurePerformed proc = procedureDAO.findById(procedureId);
        if (proc == null) {
            throw new IllegalArgumentException("Thủ thuật lâm sàng #" + procedureId + " không tồn tại.");
        }
        if (materialName == null || materialName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên vật tư tiêu hao không được để trống.");
        }
        if (quantity <= 0) {
            quantity = 1;
        }

        MaterialUsage usage = new MaterialUsage(procedureId, materialName.trim(), quantity, unit, notes);
        int generatedId = procedureDAO.insertMaterial(usage);
        if (generatedId <= 0) {
            throw new RuntimeException("Lỗi hệ thống khi ghi nhận vật tư tiêu hao.");
        }
        usage.setUsageId(generatedId);
        return usage;
    }

    /**
     * Remove a recorded material usage.
     */
    public boolean removeMaterialUsage(int usageId) {
        if (usageId <= 0) {
            throw new IllegalArgumentException("Mã vật tư không hợp lệ.");
        }
        return procedureDAO.deleteMaterial(usageId);
    }

    /**
     * Retrieve all procedures performed in a visit.
     */
    public List<ProcedurePerformed> getProceduresByVisit(int visitId) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã buổi khám không hợp lệ.");
        }
        return procedureDAO.findByVisitId(visitId);
    }

    /**
     * Retrieve a specific procedure by ID with materials.
     */
    public ProcedurePerformed getProcedureDetail(int procedureId) {
        if (procedureId <= 0) {
            throw new IllegalArgumentException("Mã thủ thuật không hợp lệ.");
        }
        return procedureDAO.findById(procedureId);
    }

    private void syncTreatmentPlanProgress(int planId) {
        if (planId <= 0) return;
        TreatmentPlan plan = planDAO.findById(planId);
        if (plan == null) return;

        List<TreatmentPlanItem> items = planDAO.findItemsByPlanId(planId);
        if (items == null || items.isEmpty()) return;

        boolean allCompleted = true;
        boolean anyInProgress = false;

        for (TreatmentPlanItem it : items) {
            if (!"Completed".equalsIgnoreCase(it.getStatus()) && !"Cancelled".equalsIgnoreCase(it.getStatus())) {
                allCompleted = false;
            }
            if ("InProgress".equalsIgnoreCase(it.getStatus()) || "Completed".equalsIgnoreCase(it.getStatus())) {
                anyInProgress = true;
            }
        }

        if (allCompleted) {
            planDAO.updateStatus(planId, "Completed", "Toàn bộ các thủ thuật trong kế hoạch điều trị đã hoàn tất.");
        } else if (anyInProgress && !"InProgress".equalsIgnoreCase(plan.getStatus())) {
            planDAO.updateStatus(planId, "InProgress", "Kế hoạch điều trị đang trong quá trình thực hiện tại ghế khám.");
        }
    }
}

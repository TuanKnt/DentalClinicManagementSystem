package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.dao.TreatmentPlanDAO;
import com.dcms.model.DentalService;
import com.dcms.model.TreatmentPlan;
import com.dcms.model.TreatmentPlanItem;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Service encapsulating business logic for Treatment Planning & Cost Estimation (UC19, UC20, UC21, UC23).
 * Adheres strictly to the 10 Iron Rules:
 * - Multi-visit treatment planning support
 * - FDI tooth notation 11-48 with 5 surface levels
 * - Invoices are NEVER generated from TreatmentPlan / TreatmentPlanItem (Iron Rule 3)
 */
public class TreatmentPlanService {

    private static final Set<String> VALID_SURFACES = new HashSet<>(Arrays.asList(
            "WholeTooth", "Occlusal", "Mesial", "Distal", "Buccal", "Lingual"
    ));

    private final TreatmentPlanDAO planDAO;
    private final DentalServiceDAO serviceDAO;

    public TreatmentPlanService() {
        this.planDAO = new TreatmentPlanDAO();
        this.serviceDAO = new DentalServiceDAO();
    }

    public TreatmentPlanService(TreatmentPlanDAO planDAO, DentalServiceDAO serviceDAO) {
        this.planDAO = planDAO;
        this.serviceDAO = serviceDAO;
    }

    /**
     * Create a new Treatment Plan (UC19).
     */
    public TreatmentPlan createTreatmentPlan(int patientId, int dentistId, String title, String diagnosis, String notes) {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Mã bệnh nhân không hợp lệ.");
        }
        if (dentistId <= 0) {
            throw new IllegalArgumentException("Mã bác sĩ phụ trách không hợp lệ.");
        }
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên kế hoạch điều trị không được để trống.");
        }

        TreatmentPlan plan = new TreatmentPlan();
        plan.setPatientId(patientId);
        plan.setDentistId(dentistId);
        plan.setTitle(title.trim());
        plan.setDiagnosis(diagnosis != null ? diagnosis.trim() : null);
        plan.setNotes(notes != null ? notes.trim() : null);
        plan.setStatus("Draft");
        plan.setEstimatedCost(BigDecimal.ZERO);
        plan.setTotalDiscount(BigDecimal.ZERO);
        plan.setFinalEstimate(BigDecimal.ZERO);

        int generatedId = planDAO.insert(plan);
        if (generatedId <= 0) {
            throw new RuntimeException("Không thể lưu kế hoạch điều trị vào cơ sở dữ liệu.");
        }
        plan.setPlanId(generatedId);
        return plan;
    }

    /**
     * Add a procedure item to an existing Treatment Plan (UC20).
     */
    public TreatmentPlanItem addPlanItem(int planId, int serviceId, Integer toothNumber, String surface,
                                         int quantity, BigDecimal unitPrice, int priorityOrder, String notes) {
        if (planId <= 0) {
            throw new IllegalArgumentException("Mã kế hoạch điều trị không hợp lệ.");
        }
        TreatmentPlan plan = planDAO.findById(planId);
        if (plan == null) {
            throw new IllegalArgumentException("Kế hoạch điều trị #" + planId + " không tồn tại.");
        }

        // Invariant: Cannot add items to completed or cancelled plans
        if ("Completed".equalsIgnoreCase(plan.getStatus()) || "Cancelled".equalsIgnoreCase(plan.getStatus())) {
            throw new IllegalStateException("Không thể thêm thủ thuật vào kế hoạch đã hoàn thành hoặc đã hủy.");
        }

        // Validate Service
        DentalService service = serviceDAO.findById(serviceId);
        if (service == null || !service.isActive()) {
            throw new IllegalArgumentException("Dịch vụ nha khoa được chọn không tồn tại hoặc đã tạm ngưng.");
        }

        // Validate FDI Tooth Number if specified
        if (toothNumber != null && toothNumber > 0) {
            validateFdiToothNumber(toothNumber);
        } else {
            toothNumber = null;
        }

        // Validate Surface
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

        // If unit price not provided or negative, use catalog price
        BigDecimal effectivePrice = unitPrice;
        if (effectivePrice == null || effectivePrice.compareTo(BigDecimal.ZERO) < 0) {
            effectivePrice = service.getPrice();
        }

        int effectivePriority = priorityOrder > 0 ? priorityOrder : 1;

        TreatmentPlanItem item = new TreatmentPlanItem(planId, serviceId, toothNumber, cleanSurface,
                quantity, effectivePrice, effectivePriority);
        item.setNotes(notes != null ? notes.trim() : null);
        item.setStatus("Proposed");

        int itemId = planDAO.insertItem(item);
        if (itemId <= 0) {
            throw new RuntimeException("Không thể lưu thủ thuật vào kế hoạch điều trị.");
        }
        item.setItemId(itemId);
        item.setServiceCode(service.getServiceCode());
        item.setServiceName(service.getServiceName());
        item.setCategory(service.getCategory());
        item.setUnit(service.getUnit());

        return item;
    }

    /**
     * Remove an item from a treatment plan.
     */
    public boolean removePlanItem(int itemId, int planId) {
        TreatmentPlanItem item = planDAO.findItemById(itemId);
        if (item == null) {
            throw new IllegalArgumentException("Mục thủ thuật #" + itemId + " không tồn tại.");
        }
        if ("Completed".equalsIgnoreCase(item.getStatus()) || "InProgress".equalsIgnoreCase(item.getStatus())) {
            throw new IllegalStateException("Không thể xóa thủ thuật đang thực hiện hoặc đã hoàn thành.");
        }
        return planDAO.deleteItem(itemId, planId);
    }

    /**
     * Update discount and recalculate treatment estimate (UC21).
     */
    public TreatmentPlan updateEstimateDiscount(int planId, BigDecimal totalDiscount) {
        TreatmentPlan plan = planDAO.findById(planId);
        if (plan == null) {
            throw new IllegalArgumentException("Kế hoạch điều trị #" + planId + " không tồn tại.");
        }
        if (totalDiscount == null || totalDiscount.compareTo(BigDecimal.ZERO) < 0) {
            totalDiscount = BigDecimal.ZERO;
        }

        // Discount cannot exceed estimated cost
        if (totalDiscount.compareTo(plan.getEstimatedCost()) > 0) {
            totalDiscount = plan.getEstimatedCost();
        }

        plan.setTotalDiscount(totalDiscount);
        BigDecimal finalEst = plan.getEstimatedCost().subtract(totalDiscount);
        plan.setFinalEstimate(finalEst.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : finalEst);

        planDAO.update(plan);
        return plan;
    }

    /**
     * Submit plan for patient review (Draft -> Proposed) (UC23).
     */
    public TreatmentPlan submitPlanForReview(int planId) {
        TreatmentPlan plan = planDAO.findById(planId);
        if (plan == null) {
            throw new IllegalArgumentException("Kế hoạch điều trị #" + planId + " không tồn tại.");
        }
        if (plan.getItems() == null || plan.getItems().isEmpty()) {
            throw new IllegalStateException("Kế hoạch điều trị phải có ít nhất 1 thủ thuật trước khi gửi bệnh nhân duyệt.");
        }
        planDAO.updateStatus(planId, "Proposed", "Kế hoạch đã được bác sĩ hoàn thiện và gửi bệnh nhân tư vấn.");
        plan.setStatus("Proposed");
        return plan;
    }

    /**
     * Record Patient Acceptance / Informed Consent for a Treatment Plan (UC22).
     * Supports:
     * - 'Accepted': Patient agrees to complete treatment plan.
     * - 'PartiallyAccepted': Patient accepts specific initial stages/priority items.
     * - 'Declined': Patient declines the recommended clinical treatment.
     */
    public TreatmentPlan recordPatientConsent(int planId, String consentType, String consentNotes, LocalDateTime consentDate) {
        if (planId <= 0) {
            throw new IllegalArgumentException("Mã kế hoạch điều trị không hợp lệ.");
        }
        TreatmentPlan plan = planDAO.findById(planId);
        if (plan == null) {
            throw new IllegalArgumentException("Kế hoạch điều trị #" + planId + " không tồn tại.");
        }

        if ("Completed".equalsIgnoreCase(plan.getStatus()) || "Cancelled".equalsIgnoreCase(plan.getStatus())) {
            throw new IllegalStateException("Không thể ghi nhận cam kết cho kế hoạch điều trị đã hoàn thành hoặc đã hủy.");
        }

        if (consentType == null || consentType.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn loại chấp thuận điều trị (Accepted, PartiallyAccepted, Declined).");
        }

        String normalizedType = consentType.trim();
        if (!"Accepted".equalsIgnoreCase(normalizedType) &&
            !"PartiallyAccepted".equalsIgnoreCase(normalizedType) &&
            !"Declined".equalsIgnoreCase(normalizedType)) {
            throw new IllegalArgumentException("Loại chấp thuận điều trị '" + consentType + "' không hợp lệ. Chỉ chấp nhận: Accepted, PartiallyAccepted, Declined.");
        }

        LocalDateTime effectiveDate = (consentDate != null) ? consentDate : LocalDateTime.now();
        String notes = (consentNotes != null && !consentNotes.trim().isEmpty()) ? consentNotes.trim() : null;

        boolean updated = planDAO.recordConsent(planId, normalizedType, notes, effectiveDate);
        if (!updated) {
            throw new RuntimeException("Lỗi hệ thống khi lưu biên bản cam kết điều trị vào cơ sở dữ liệu.");
        }

        // Synchronize item status
        if ("Accepted".equalsIgnoreCase(normalizedType)) {
            planDAO.updateItemsStatusByPlanId(planId, "Accepted");
        } else if ("Declined".equalsIgnoreCase(normalizedType)) {
            planDAO.updateItemsStatusByPlanId(planId, "Declined");
        }

        plan.setStatus(normalizedType);
        plan.setPatientConsentDate(effectiveDate);
        plan.setConsentNotes(notes);
        return plan;
    }

    /**
     * Retrieve plan details by ID with all items (UC23).
     */
    public TreatmentPlan getPlanDetails(int planId) {
        return planDAO.findById(planId);
    }

    /**
     * List all treatment plans for clinic review.
     */
    public List<TreatmentPlan> getAllPlans() {
        return planDAO.findAll();
    }

    /**
     * List plans for a specific patient.
     */
    public List<TreatmentPlan> getPlansByPatient(int patientId) {
        return planDAO.findByPatientId(patientId);
    }

    /**
     * Validate tooth number against FDI two-digit standard:
     * Quadrant 1 (Upper Right): 11 - 18
     * Quadrant 2 (Upper Left):  21 - 28
     * Quadrant 3 (Lower Left):  31 - 38
     * Quadrant 4 (Lower Right): 41 - 48
     */
    public static void validateFdiToothNumber(int toothNumber) {
        boolean valid = (toothNumber >= 11 && toothNumber <= 18) ||
                        (toothNumber >= 21 && toothNumber <= 28) ||
                        (toothNumber >= 31 && toothNumber <= 38) ||
                        (toothNumber >= 41 && toothNumber <= 48);
        if (!valid) {
            throw new IllegalArgumentException("Mã số răng (" + toothNumber + ") không hợp lệ. Chuẩn quốc tế FDI bao gồm 4 cung răng: 11-18, 21-28, 31-38, 41-48.");
        }
    }
}

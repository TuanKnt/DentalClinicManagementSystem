package com.dcms.service;

import com.dcms.dao.PatientDAO;
import com.dcms.dao.PrescriptionDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Medicine;
import com.dcms.model.Patient;
import com.dcms.model.Prescription;
import com.dcms.model.PrescriptionItem;
import com.dcms.model.Visit;
import com.dcms.service.exception.BusinessRuleViolationException;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service managing Electronic Prescriptions & Pharmacy Validation (UC27, UC28).
 * Managed by Kiên (Prescriptions & Pharmacy).
 */
public class PrescriptionService {

    private static final Logger LOGGER = Logger.getLogger(PrescriptionService.class.getName());

    private final PrescriptionDAO prescriptionDAO;
    private final VisitDAO visitDAO;
    private final PatientDAO patientDAO;

    public PrescriptionService() {
        this.prescriptionDAO = new PrescriptionDAO();
        this.visitDAO = new VisitDAO();
        this.patientDAO = new PatientDAO();
    }

    public PrescriptionService(PrescriptionDAO prescriptionDAO, VisitDAO visitDAO, PatientDAO patientDAO) {
        this.prescriptionDAO = prescriptionDAO;
        this.visitDAO = visitDAO;
        this.patientDAO = patientDAO;
    }

    /**
     * Retrieve all active medicines available for prescribing (UC27).
     */
    public List<Medicine> getActiveMedicines() {
        return prescriptionDAO.findAllMedicines(true);
    }

    /**
     * Retrieve medicine details by ID.
     */
    public Medicine getMedicineById(int medicineId) {
        if (medicineId <= 0) {
            throw new IllegalArgumentException("Mã thuốc không hợp lệ.");
        }
        return prescriptionDAO.findMedicineById(medicineId);
    }

    /**
     * Issue an Electronic Prescription for a clinical visit (UC27).
     */
    public Prescription issuePrescription(int visitId, int dentistId, String diagnosis,
                                          String advice, List<PrescriptionItem> items) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã buổi khám không hợp lệ.");
        }
        Visit visit = visitDAO.findById(visitId);
        if (visit == null) {
            throw new BusinessRuleViolationException("Buổi khám #" + visitId + " không tồn tại trong hệ thống.");
        }
        if ("Cancelled".equalsIgnoreCase(visit.getStatus())) {
            throw new BusinessRuleViolationException("Không thể kê đơn thuốc cho buổi khám đã bị hủy.");
        }

        if (dentistId <= 0) {
            throw new IllegalArgumentException("Bác sĩ chỉ định kê đơn không hợp lệ.");
        }

        if (items == null || items.isEmpty()) {
            throw new BusinessRuleViolationException("Đơn thuốc điện tử phải có ít nhất 1 loại thuốc.");
        }

        Patient patient = patientDAO.findById(visit.getPatientId());
        String allergies = (patient != null && patient.getAllergies() != null)
                ? patient.getAllergies().toLowerCase() : "";

        // Validate each prescribed item and check patient allergies
        for (PrescriptionItem it : items) {
            if (it.getMedicineId() <= 0) {
                throw new BusinessRuleViolationException("Thuốc kê đơn không hợp lệ.");
            }
            Medicine med = prescriptionDAO.findMedicineById(it.getMedicineId());
            if (med == null || !med.isActive()) {
                throw new BusinessRuleViolationException("Thuốc #" + it.getMedicineId() + " không tồn tại hoặc đã tạm dừng lưu hành.");
            }
            if (it.getQuantity() <= 0) {
                throw new BusinessRuleViolationException("Số lượng thuốc '" + med.getMedicineName() + "' phải lớn hơn 0.");
            }
            if (it.getDosage() == null || it.getDosage().trim().isEmpty()) {
                throw new BusinessRuleViolationException("Vui lòng ghi rõ hướng dẫn liều dùng cho thuốc '" + med.getMedicineName() + "'.");
            }

            // Clinical Allergy Invariant Check
            if (!allergies.isEmpty() && med.getActiveIngredient() != null) {
                String activeIng = med.getActiveIngredient().toLowerCase();
                if (allergies.contains("penicillin") && (activeIng.contains("amoxicillin") || activeIng.contains("penicillin") || activeIng.contains("ampicillin"))) {
                    throw new BusinessRuleViolationException("CẢNH BÁO NGUY HIỂM: Bệnh nhân có tiền sử dị ứng (" + patient.getAllergies()
                            + "). Chống chỉ định kê thuốc nhóm Penicillin: " + med.getMedicineName() + " (" + med.getActiveIngredient() + ")!");
                }
            }
        }

        Prescription rx = new Prescription();
        rx.setVisitId(visitId);
        rx.setPatientId(visit.getPatientId());
        rx.setDentistId(dentistId);
        rx.setDiagnosis(diagnosis != null && !diagnosis.trim().isEmpty() ? diagnosis.trim() : "Viêm quanh chóp răng / Sau thủ thuật nha khoa");
        rx.setAdvice(advice != null && !advice.trim().isEmpty() ? advice.trim() : "Uống thuốc đúng giờ, đúng liều lượng. Tái khám ngay nếu có dấu hiệu bất thường hoặc sốt, dị ứng.");
        rx.setStatus("Issued");

        int rxId = prescriptionDAO.createPrescription(rx, items);
        if (rxId <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể lưu đơn thuốc điện tử.");
        }

        return prescriptionDAO.findById(rxId);
    }

    /**
     * Get prescription details by ID (UC28).
     */
    public Prescription getPrescriptionDetail(int prescriptionId) {
        if (prescriptionId <= 0) {
            throw new IllegalArgumentException("Mã đơn thuốc không hợp lệ.");
        }
        Prescription rx = prescriptionDAO.findById(prescriptionId);
        if (rx == null) {
            throw new BusinessRuleViolationException("Không tìm thấy đơn thuốc #" + prescriptionId);
        }
        return rx;
    }

    /**
     * Get prescription issued for a visit.
     */
    public Prescription getPrescriptionByVisit(int visitId) {
        if (visitId <= 0) {
            throw new IllegalArgumentException("Mã buổi khám không hợp lệ.");
        }
        return prescriptionDAO.findByVisitId(visitId);
    }

    /**
     * Get prescription history for a patient.
     */
    public List<Prescription> getPrescriptionsByPatient(int patientId) {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Mã bệnh nhân không hợp lệ.");
        }
        return prescriptionDAO.findByPatientId(patientId);
    }

    /**
     * Cancel an issued prescription.
     */
    public boolean cancelPrescription(int prescriptionId, String reason) {
        if (prescriptionId <= 0) {
            throw new IllegalArgumentException("Mã đơn thuốc không hợp lệ.");
        }
        Prescription rx = prescriptionDAO.findById(prescriptionId);
        if (rx == null) {
            throw new BusinessRuleViolationException("Đơn thuốc #" + prescriptionId + " không tồn tại.");
        }
        if ("Cancelled".equalsIgnoreCase(rx.getStatus())) {
            throw new BusinessRuleViolationException("Đơn thuốc này đã bị hủy trước đó.");
        }
        return prescriptionDAO.updateStatus(prescriptionId, "Cancelled");
    }
}

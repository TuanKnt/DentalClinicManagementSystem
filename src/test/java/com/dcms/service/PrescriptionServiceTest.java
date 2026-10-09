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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit Test Suite for E-Prescription Management (UC27, UC28).
 * Managed by Kiên (Pharmacy & E-Prescriptions).
 */
@ExtendWith(MockitoExtension.class)
public class PrescriptionServiceTest {

    @Mock
    private PrescriptionDAO prescriptionDAO;

    @Mock
    private VisitDAO visitDAO;

    @Mock
    private PatientDAO patientDAO;

    private PrescriptionService prescriptionService;

    @BeforeEach
    void setUp() {
        prescriptionService = new PrescriptionService(prescriptionDAO, visitDAO, patientDAO);
    }

    private Visit createSampleVisit(int visitId, String status, int patientId, int dentistId) {
        Visit v = new Visit();
        v.setVisitId(visitId);
        v.setStatus(status);
        v.setPatientId(patientId);
        v.setPrimaryDentistId(dentistId);
        v.setOperatory("Ghế 1 - P.101");
        return v;
    }

    private Patient createSamplePatient(int patientId, String allergies) {
        Patient p = new Patient();
        p.setPatientId(patientId);
        p.setFullName("Nguyễn Văn Bệnh Nhân");
        p.setPhone("0988776655");
        p.setAllergies(allergies);
        return p;
    }

    private Medicine createSampleMedicine(int medId, String code, String name, String ingredient, boolean active) {
        Medicine m = new Medicine();
        m.setMedicineId(medId);
        m.setMedicineCode(code);
        m.setMedicineName(name);
        m.setActiveIngredient(ingredient);
        m.setUnit("Viên");
        m.setUnitPrice(new BigDecimal("15000"));
        m.setActive(active);
        return m;
    }

    @Test
    @DisplayName("UC27-01: Kê đơn thuốc điện tử thành công với đầy đủ thuốc và liều lượng")
    void testIssuePrescription_Success() {
        Visit visit = createSampleVisit(1, "InProgress", 10, 3);
        Patient patient = createSamplePatient(10, null);
        Medicine med = createSampleMedicine(1, "MED-AUG625", "Augmentin 625mg", "Amoxicillin + Clavulanic", true);

        when(visitDAO.findById(1)).thenReturn(visit);
        when(patientDAO.findById(10)).thenReturn(patient);
        when(prescriptionDAO.findMedicineById(1)).thenReturn(med);
        when(prescriptionDAO.createPrescription(any(Prescription.class), anyList())).thenReturn(101);

        Prescription createdRx = new Prescription();
        createdRx.setPrescriptionId(101);
        createdRx.setPrescriptionCode("RX-2026-0001");
        createdRx.setStatus("Issued");
        when(prescriptionDAO.findById(101)).thenReturn(createdRx);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(14);
        it.setDosage("Uống 1 viên x 2 lần/ngày sau khi ăn");
        it.setDurationDays(7);
        items.add(it);

        Prescription result = prescriptionService.issuePrescription(
                1, 3, "Viêm quanh cuống răng", "Uống thuốc sau ăn, tránh đồ cay nóng", items
        );

        assertNotNull(result);
        assertEquals(101, result.getPrescriptionId());
        assertEquals("RX-2026-0001", result.getPrescriptionCode());
        assertEquals("Issued", result.getStatus());
        verify(prescriptionDAO).createPrescription(any(Prescription.class), eq(items));
    }

    @Test
    @DisplayName("UC27-02: Chặn kê đơn khi buổi khám không tồn tại")
    void testIssuePrescription_ThrowsWhenVisitNotFound() {
        when(visitDAO.findById(999)).thenReturn(null);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(10);
        it.setDosage("Uống 1 viên/ngày");
        items.add(it);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(999, 3, "Chẩn đoán", "Lời dặn", items)
        );
        verify(prescriptionDAO, never()).createPrescription(any(), any());
    }

    @Test
    @DisplayName("UC27-03: Chặn kê đơn khi buổi khám đã bị hủy")
    void testIssuePrescription_ThrowsWhenVisitCancelled() {
        Visit visit = createSampleVisit(2, "Cancelled", 10, 3);
        when(visitDAO.findById(2)).thenReturn(visit);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(10);
        it.setDosage("Uống 1 viên/ngày");
        items.add(it);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(2, 3, "Chẩn đoán", "Lời dặn", items)
        );
        verify(prescriptionDAO, never()).createPrescription(any(), any());
    }

    @Test
    @DisplayName("UC27-04: Chặn kê đơn khi danh sách thuốc rỗng")
    void testIssuePrescription_ThrowsWhenNoItems() {
        Visit visit = createSampleVisit(3, "InProgress", 10, 3);
        when(visitDAO.findById(3)).thenReturn(visit);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(3, 3, "Chẩn đoán", "Lời dặn", Collections.emptyList())
        );
    }

    @Test
    @DisplayName("UC27-05: Chặn kê đơn khi thuốc đã bị tạm ngưng lưu hành")
    void testIssuePrescription_ThrowsWhenMedicineNotActive() {
        Visit visit = createSampleVisit(4, "InProgress", 10, 3);
        Patient patient = createSamplePatient(10, null);
        Medicine inactiveMed = createSampleMedicine(2, "MED-OLD", "Thuốc ngưng", "Old Ingredient", false);

        when(visitDAO.findById(4)).thenReturn(visit);
        when(patientDAO.findById(10)).thenReturn(patient);
        when(prescriptionDAO.findMedicineById(2)).thenReturn(inactiveMed);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(2);
        it.setQuantity(10);
        it.setDosage("Uống 1 viên");
        items.add(it);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(4, 3, "Chẩn đoán", "Lời dặn", items)
        );
    }

    @Test
    @DisplayName("UC27-06: Chặn kê đơn khi số lượng thuốc <= 0")
    void testIssuePrescription_ThrowsWhenQuantityZeroOrNegative() {
        Visit visit = createSampleVisit(5, "InProgress", 10, 3);
        Patient patient = createSamplePatient(10, null);
        Medicine med = createSampleMedicine(1, "MED-AUG625", "Augmentin", "Amoxicillin", true);

        when(visitDAO.findById(5)).thenReturn(visit);
        when(patientDAO.findById(10)).thenReturn(patient);
        when(prescriptionDAO.findMedicineById(1)).thenReturn(med);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(0); // Invalid
        it.setDosage("Uống 1 viên");
        items.add(it);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(5, 3, "Chẩn đoán", "Lời dặn", items)
        );
    }

    @Test
    @DisplayName("UC27-07: Chặn kê đơn khi liều lượng/hướng dẫn sử dụng bị bỏ trống")
    void testIssuePrescription_ThrowsWhenDosageEmpty() {
        Visit visit = createSampleVisit(6, "InProgress", 10, 3);
        Patient patient = createSamplePatient(10, null);
        Medicine med = createSampleMedicine(1, "MED-AUG625", "Augmentin", "Amoxicillin", true);

        when(visitDAO.findById(6)).thenReturn(visit);
        when(patientDAO.findById(10)).thenReturn(patient);
        when(prescriptionDAO.findMedicineById(1)).thenReturn(med);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(10);
        it.setDosage("   "); // Blank dosage
        items.add(it);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(6, 3, "Chẩn đoán", "Lời dặn", items)
        );
    }

    @Test
    @DisplayName("UC27-08: CẢNH BÁO AN TOÀN LÂM SÀNG: Chặn kê kháng sinh Penicillin khi bệnh nhân có tiền sử dị ứng Penicillin")
    void testIssuePrescription_ThrowsWhenPatientAllergicToPenicillin() {
        Visit visit = createSampleVisit(7, "InProgress", 20, 3);
        Patient allergicPatient = createSamplePatient(20, "Dị ứng Penicillin nặng, nổi mề đay");
        Medicine penicillinMed = createSampleMedicine(1, "MED-AUG625", "Augmentin 625mg", "Amoxicillin + Clavulanic Acid", true);

        when(visitDAO.findById(7)).thenReturn(visit);
        when(patientDAO.findById(20)).thenReturn(allergicPatient);
        when(prescriptionDAO.findMedicineById(1)).thenReturn(penicillinMed);

        List<PrescriptionItem> items = new ArrayList<>();
        PrescriptionItem it = new PrescriptionItem();
        it.setMedicineId(1);
        it.setQuantity(10);
        it.setDosage("Uống 1 viên x 2 lần/ngày");
        items.add(it);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.issuePrescription(7, 3, "Viêm chóp", "Uống thuốc", items)
        );

        assertTrue(ex.getMessage().contains("CẢNH BÁO NGUY HIỂM"));
        assertTrue(ex.getMessage().contains("Penicillin"));
        verify(prescriptionDAO, never()).createPrescription(any(), any());
    }

    @Test
    @DisplayName("UC28-01: Truy vấn chi tiết đơn thuốc thành công để in ấn")
    void testGetPrescriptionDetail_Success() {
        Prescription rx = new Prescription();
        rx.setPrescriptionId(50);
        rx.setPrescriptionCode("RX-2026-0050");
        rx.setStatus("Issued");

        when(prescriptionDAO.findById(50)).thenReturn(rx);

        Prescription result = prescriptionService.getPrescriptionDetail(50);
        assertNotNull(result);
        assertEquals("RX-2026-0050", result.getPrescriptionCode());
    }

    @Test
    @DisplayName("UC28-02: Báo lỗi khi đơn thuốc cần in không tồn tại")
    void testGetPrescriptionDetail_ThrowsWhenNotFound() {
        when(prescriptionDAO.findById(999)).thenReturn(null);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.getPrescriptionDetail(999)
        );
    }

    @Test
    @DisplayName("UC27-09: Hủy đơn thuốc đã phát hành thành công")
    void testCancelPrescription_Success() {
        Prescription rx = new Prescription();
        rx.setPrescriptionId(12);
        rx.setStatus("Issued");

        when(prescriptionDAO.findById(12)).thenReturn(rx);
        when(prescriptionDAO.updateStatus(12, "Cancelled")).thenReturn(true);

        boolean ok = prescriptionService.cancelPrescription(12, "Bệnh nhân đổi phác đồ");
        assertTrue(ok);
        verify(prescriptionDAO).updateStatus(12, "Cancelled");
    }

    @Test
    @DisplayName("UC27-10: Chặn hủy đơn thuốc khi đã ở trạng thái Cancelled")
    void testCancelPrescription_ThrowsWhenAlreadyCancelled() {
        Prescription rx = new Prescription();
        rx.setPrescriptionId(15);
        rx.setStatus("Cancelled");

        when(prescriptionDAO.findById(15)).thenReturn(rx);

        assertThrows(BusinessRuleViolationException.class, () ->
                prescriptionService.cancelPrescription(15, "Hủy lần hai")
        );
        verify(prescriptionDAO, never()).updateStatus(eq(15), anyString());
    }
}

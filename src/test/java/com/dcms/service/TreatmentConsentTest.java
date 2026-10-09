package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.dao.TreatmentPlanDAO;
import com.dcms.model.TreatmentPlan;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Unit Test Suite for Treatment Acceptance & Informed Patient Consent (UC22).
 * Managed by Thai (Appointment & Consent Module).
 */
@ExtendWith(MockitoExtension.class)
public class TreatmentConsentTest {

    @Mock
    private TreatmentPlanDAO planDAO;

    @Mock
    private DentalServiceDAO serviceDAO;

    private TreatmentPlanService planService;

    @BeforeEach
    void setUp() {
        planService = new TreatmentPlanService(planDAO, serviceDAO);
    }

    private TreatmentPlan createSamplePlan(int planId, String status) {
        TreatmentPlan plan = new TreatmentPlan();
        plan.setPlanId(planId);
        plan.setPatientId(1);
        plan.setDentistId(3);
        plan.setTitle("Phác đồ điều trị tủy và bọc sứ");
        plan.setStatus(status);
        return plan;
    }

    @Test
    @DisplayName("UC22-01: Ghi nhận đồng thuận toàn bộ (Accepted) thành công và đồng bộ trạng thái thủ thuật")
    void testRecordConsent_Accepted_Success() {
        TreatmentPlan plan = createSamplePlan(10, "Proposed");
        when(planDAO.findById(10)).thenReturn(plan);
        when(planDAO.recordConsent(eq(10), eq("Accepted"), anyString(), any(LocalDateTime.class))).thenReturn(true);
        when(planDAO.updateItemsStatusByPlanId(10, "Accepted")).thenReturn(true);

        LocalDateTime now = LocalDateTime.now();
        TreatmentPlan result = planService.recordPatientConsent(10, "Accepted", "Bệnh nhân đồng ý 100% phác đồ", now);

        assertNotNull(result);
        assertEquals("Accepted", result.getStatus());
        assertEquals(now, result.getPatientConsentDate());
        assertEquals("Bệnh nhân đồng ý 100% phác đồ", result.getConsentNotes());

        verify(planDAO).recordConsent(eq(10), eq("Accepted"), eq("Bệnh nhân đồng ý 100% phác đồ"), eq(now));
        verify(planDAO).updateItemsStatusByPlanId(10, "Accepted");
    }

    @Test
    @DisplayName("UC22-02: Ghi nhận đồng thuận một phần (PartiallyAccepted) thành công")
    void testRecordConsent_PartiallyAccepted_Success() {
        TreatmentPlan plan = createSamplePlan(12, "Proposed");
        when(planDAO.findById(12)).thenReturn(plan);
        when(planDAO.recordConsent(eq(12), eq("PartiallyAccepted"), anyString(), any(LocalDateTime.class))).thenReturn(true);

        TreatmentPlan result = planService.recordPatientConsent(12, "PartiallyAccepted", "Bệnh nhân đồng ý giai đoạn 1", null);

        assertNotNull(result);
        assertEquals("PartiallyAccepted", result.getStatus());
        assertNotNull(result.getPatientConsentDate());

        verify(planDAO).recordConsent(eq(12), eq("PartiallyAccepted"), eq("Bệnh nhân đồng ý giai đoạn 1"), any(LocalDateTime.class));
        verify(planDAO, never()).updateItemsStatusByPlanId(eq(12), anyString());
    }

    @Test
    @DisplayName("UC22-03: Ghi nhận từ chối điều trị (Declined) và chuyển thủ thuật sang Declined")
    void testRecordConsent_Declined_Success() {
        TreatmentPlan plan = createSamplePlan(15, "Proposed");
        when(planDAO.findById(15)).thenReturn(plan);
        when(planDAO.recordConsent(eq(15), eq("Declined"), anyString(), any(LocalDateTime.class))).thenReturn(true);
        when(planDAO.updateItemsStatusByPlanId(15, "Declined")).thenReturn(true);

        TreatmentPlan result = planService.recordPatientConsent(15, "Declined", "Bệnh nhân chưa có nhu cầu điều trị", null);

        assertNotNull(result);
        assertEquals("Declined", result.getStatus());

        verify(planDAO).recordConsent(eq(15), eq("Declined"), eq("Bệnh nhân chưa có nhu cầu điều trị"), any(LocalDateTime.class));
        verify(planDAO).updateItemsStatusByPlanId(15, "Declined");
    }

    @Test
    @DisplayName("UC22-04: Ném ngoại lệ khi mã kế hoạch không hợp lệ (<= 0)")
    void testRecordConsent_InvalidPlanId_ThrowsException() {
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                planService.recordPatientConsent(0, "Accepted", "Notes", null));
        assertTrue(ex.getMessage().contains("không hợp lệ"));
    }

    @Test
    @DisplayName("UC22-05: Ném ngoại lệ khi kế hoạch không tồn tại trong hệ thống")
    void testRecordConsent_NonExistentPlan_ThrowsException() {
        when(planDAO.findById(999)).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                planService.recordPatientConsent(999, "Accepted", "Notes", null));
        assertTrue(ex.getMessage().contains("không tồn tại"));
    }

    @Test
    @DisplayName("UC22-06: Chặn ghi nhận cam kết cho kế hoạch đã hoàn thành (Completed)")
    void testRecordConsent_CompletedPlan_ThrowsIllegalStateException() {
        TreatmentPlan plan = createSamplePlan(20, "Completed");
        when(planDAO.findById(20)).thenReturn(plan);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                planService.recordPatientConsent(20, "Accepted", "Notes", null));
        assertTrue(ex.getMessage().contains("đã hoàn thành"));
    }

    @Test
    @DisplayName("UC22-07: Chặn ghi nhận cam kết cho kế hoạch đã hủy (Cancelled)")
    void testRecordConsent_CancelledPlan_ThrowsIllegalStateException() {
        TreatmentPlan plan = createSamplePlan(21, "Cancelled");
        when(planDAO.findById(21)).thenReturn(plan);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                planService.recordPatientConsent(21, "Accepted", "Notes", null));
        assertTrue(ex.getMessage().contains("đã hủy"));
    }

    @Test
    @DisplayName("UC22-08: Ném ngoại lệ khi loại chấp thuận điều trị rỗng hoặc sai chuẩn")
    void testRecordConsent_InvalidConsentType_ThrowsException() {
        TreatmentPlan plan = createSamplePlan(22, "Draft");
        when(planDAO.findById(22)).thenReturn(plan);

        assertThrows(IllegalArgumentException.class, () ->
                planService.recordPatientConsent(22, null, "Notes", null));

        assertThrows(IllegalArgumentException.class, () ->
                planService.recordPatientConsent(22, "   ", "Notes", null));

        assertThrows(IllegalArgumentException.class, () ->
                planService.recordPatientConsent(22, "UnknownType", "Notes", null));
    }
}

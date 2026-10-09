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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Unit Test Suite for Chairside Procedures Performed & Material Tracking (UC24, UC25, UC26).
 * Managed by Wolf (Clinical Treatment & Chairside Procedures).
 */
@ExtendWith(MockitoExtension.class)
public class ClinicalProcedureServiceTest {

    @Mock
    private ProcedurePerformedDAO procedureDAO;

    @Mock
    private DentalServiceDAO serviceDAO;

    @Mock
    private VisitDAO visitDAO;

    @Mock
    private TreatmentPlanDAO planDAO;

    private ClinicalProcedureService procedureService;

    @BeforeEach
    void setUp() {
        procedureService = new ClinicalProcedureService(procedureDAO, serviceDAO, visitDAO, planDAO);
    }

    private Visit createSampleVisit(int visitId, String status) {
        Visit visit = new Visit();
        visit.setVisitId(visitId);
        visit.setPatientId(1);
        visit.setPrimaryDentistId(3);
        visit.setStatus(status);
        return visit;
    }

    private DentalService createSampleService(int serviceId, boolean active, BigDecimal price) {
        DentalService svc = new DentalService();
        svc.setServiceId(serviceId);
        svc.setServiceCode("SR-TRAM-01");
        svc.setServiceName("Trám răng thẩm mỹ Composite");
        svc.setActive(active);
        svc.setPrice(price);
        svc.setUnit("Răng");
        return svc;
    }

    @Test
    @DisplayName("UC24-01: Ghi nhận thủ thuật tại ghế thành công và đồng bộ hoàn tất hạng mục kế hoạch điều trị")
    void testRecordProcedure_Success_WithPlanItemSync() {
        Visit visit = createSampleVisit(1, "InProgress");
        DentalService service = createSampleService(3, true, new BigDecimal("450000"));
        TreatmentPlanItem item = new TreatmentPlanItem();
        item.setItemId(10);
        item.setPlanId(5);
        item.setStatus("Accepted");

        TreatmentPlan plan = new TreatmentPlan();
        plan.setPlanId(5);
        plan.setStatus("Accepted");

        when(visitDAO.getVisitById(1)).thenReturn(visit);
        when(serviceDAO.findById(3)).thenReturn(service);
        when(procedureDAO.insert(any(ProcedurePerformed.class))).thenReturn(101);
        when(planDAO.findItemById(10)).thenReturn(item);
        when(planDAO.findById(5)).thenReturn(plan);
        when(planDAO.findItemsByPlanId(5)).thenReturn(Collections.singletonList(item));

        ProcedurePerformed result = procedureService.recordProcedure(
                1, 3, null, 10, 3, 46, "Occlusal", 1, new BigDecimal("450000"), "Trám composite xoang I răng 46"
        );

        assertNotNull(result);
        assertEquals(101, result.getProcedureId());
        assertEquals("Completed", result.getStatus());
        assertEquals(46, result.getToothNumber());
        assertEquals("Occlusal", result.getSurface());

        verify(procedureDAO).insert(any(ProcedurePerformed.class));
        verify(planDAO).updateItemStatus(10, "Completed");
        verify(planDAO).updateStatus(eq(5), eq("Completed"), anyString());
    }

    @Test
    @DisplayName("UC24-02: Ghi nhận thủ thuật phát sinh tại ghế không liên kết phác đồ (Walk-in / Impromptu)")
    void testRecordProcedure_Success_DirectWithoutPlanItem() {
        Visit visit = createSampleVisit(2, "InProgress");
        DentalService service = createSampleService(2, true, new BigDecimal("250000"));

        when(visitDAO.getVisitById(2)).thenReturn(visit);
        when(serviceDAO.findById(2)).thenReturn(service);
        when(procedureDAO.insert(any(ProcedurePerformed.class))).thenReturn(102);

        ProcedurePerformed result = procedureService.recordProcedure(
                2, 3, null, null, 2, null, "WholeTooth", 1, null, "Lấy cao răng toàn hàm"
        );

        assertNotNull(result);
        assertEquals(102, result.getProcedureId());
        assertNull(result.getToothNumber());
        assertEquals(new BigDecimal("250000"), result.getActualPrice());

        verify(procedureDAO).insert(any(ProcedurePerformed.class));
        verify(planDAO, never()).updateItemStatus(anyInt(), anyString());
    }

    @Test
    @DisplayName("UC24-03: Chặn ghi nhận thủ thuật khi buổi khám không tồn tại")
    void testRecordProcedure_NonExistentVisit_ThrowsException() {
        when(visitDAO.getVisitById(999)).thenReturn(null);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () ->
                procedureService.recordProcedure(999, 3, null, null, 1, null, null, 1, null, null));
        assertTrue(ex.getMessage().contains("không tồn tại"));
    }

    @Test
    @DisplayName("UC24-04: Chặn ghi nhận thủ thuật cho buổi khám đã hoàn tất xuất viện (CheckedOut)")
    void testRecordProcedure_CheckedOutVisit_ThrowsException() {
        Visit visit = createSampleVisit(3, "CheckedOut");
        when(visitDAO.getVisitById(3)).thenReturn(visit);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () ->
                procedureService.recordProcedure(3, 3, null, null, 1, null, null, 1, null, null));
        assertTrue(ex.getMessage().contains("hoàn tất xuất viện"));
    }

    @Test
    @DisplayName("UC24-05: Chặn ghi nhận dịch vụ đã tạm ngưng hoạt động")
    void testRecordProcedure_InactiveService_ThrowsException() {
        Visit visit = createSampleVisit(4, "InProgress");
        DentalService service = createSampleService(4, false, new BigDecimal("100000"));

        when(visitDAO.getVisitById(4)).thenReturn(visit);
        when(serviceDAO.findById(4)).thenReturn(service);

        BusinessRuleViolationException ex = assertThrows(BusinessRuleViolationException.class, () ->
                procedureService.recordProcedure(4, 3, null, null, 4, null, null, 1, null, null));
        assertTrue(ex.getMessage().contains("tạm ngưng"));
    }

    @Test
    @DisplayName("UC24-06: Chặn số hiệu răng không tuân thủ chuẩn FDI 11-48")
    void testRecordProcedure_InvalidFdiToothNumber_ThrowsException() {
        Visit visit = createSampleVisit(5, "InProgress");
        DentalService service = createSampleService(5, true, new BigDecimal("300000"));

        when(visitDAO.getVisitById(5)).thenReturn(visit);
        when(serviceDAO.findById(5)).thenReturn(service);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                procedureService.recordProcedure(5, 3, null, null, 5, 99, null, 1, null, null));
        assertTrue(ex.getMessage().contains("FDI"));
    }

    @Test
    @DisplayName("UC24-07: Chặn mặt răng lâm sàng không hợp lệ")
    void testRecordProcedure_InvalidSurface_ThrowsException() {
        Visit visit = createSampleVisit(6, "InProgress");
        DentalService service = createSampleService(6, true, new BigDecimal("300000"));

        when(visitDAO.getVisitById(6)).thenReturn(visit);
        when(serviceDAO.findById(6)).thenReturn(service);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                procedureService.recordProcedure(6, 3, null, null, 6, 11, "InvalidSurface", 1, null, null));
        assertTrue(ex.getMessage().contains("Mặt răng không hợp lệ"));
    }

    @Test
    @DisplayName("UC25: Cập nhật hoàn tất thủ thuật đang thực hiện (InProgress -> Completed)")
    void testCompleteProcedure_Success() {
        ProcedurePerformed proc = new ProcedurePerformed();
        proc.setProcedureId(50);
        proc.setStatus("InProgress");
        proc.setPlanItemId(15);

        TreatmentPlanItem item = new TreatmentPlanItem();
        item.setItemId(15);
        item.setPlanId(8);

        TreatmentPlan plan = new TreatmentPlan();
        plan.setPlanId(8);

        when(procedureDAO.findById(50)).thenReturn(proc);
        when(procedureDAO.updateStatus(50, "Completed", "Hoàn tất trám")).thenReturn(true);
        when(planDAO.findItemById(15)).thenReturn(item);
        when(planDAO.findById(8)).thenReturn(plan);
        when(planDAO.findItemsByPlanId(8)).thenReturn(Collections.singletonList(item));

        boolean result = procedureService.completeProcedure(50, "Hoàn tất trám");

        assertTrue(result);
        verify(procedureDAO).updateStatus(50, "Completed", "Hoàn tất trám");
        verify(planDAO).updateItemStatus(15, "Completed");
    }

    @Test
    @DisplayName("UC26-01: Ghi nhận vật tư y tế tiêu hao thành công")
    void testRecordMaterialUsage_Success() {
        ProcedurePerformed proc = new ProcedurePerformed();
        proc.setProcedureId(60);

        when(procedureDAO.findById(60)).thenReturn(proc);
        when(procedureDAO.insertMaterial(any(MaterialUsage.class))).thenReturn(201);

        MaterialUsage result = procedureService.recordMaterialUsage(60, "Thuốc tê Lidocaine 2%", 2, "Ống", "Gây tê tại chỗ");

        assertNotNull(result);
        assertEquals(201, result.getUsageId());
        assertEquals("Thuốc tê Lidocaine 2%", result.getMaterialName());
        assertEquals(2, result.getQuantity());

        verify(procedureDAO).insertMaterial(any(MaterialUsage.class));
    }

    @Test
    @DisplayName("UC26-02: Ném ngoại lệ khi tên vật tư tiêu hao để trống")
    void testRecordMaterialUsage_BlankName_ThrowsException() {
        ProcedurePerformed proc = new ProcedurePerformed();
        proc.setProcedureId(61);
        when(procedureDAO.findById(61)).thenReturn(proc);

        assertThrows(IllegalArgumentException.class, () ->
                procedureService.recordMaterialUsage(61, "", 1, "Ống", null));
    }
}

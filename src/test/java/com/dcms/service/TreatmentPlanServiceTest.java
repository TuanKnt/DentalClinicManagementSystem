package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.dao.TreatmentPlanDAO;
import com.dcms.model.DentalService;
import com.dcms.model.TreatmentPlan;
import com.dcms.model.TreatmentPlanItem;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class TreatmentPlanServiceTest {

    private TreatmentPlanDAO planDAO;
    private DentalServiceDAO serviceDAO;
    private TreatmentPlanService service;

    @BeforeEach
    void setUp() {
        planDAO = mock(TreatmentPlanDAO.class);
        serviceDAO = mock(DentalServiceDAO.class);
        service = new TreatmentPlanService(planDAO, serviceDAO);
    }

    @Test
    @DisplayName("Tạo kế hoạch điều trị thành công với trạng thái mặc định là Draft")
    void createTreatmentPlan_Success() {
        when(planDAO.insert(any(TreatmentPlan.class))).thenReturn(101);

        TreatmentPlan plan = service.createTreatmentPlan(1, 3, "Kế hoạch phục hình răng sứ", "Sâu vỡ thân răng", "Cần bảo tồn tủy");

        assertNotNull(plan);
        assertEquals(101, plan.getPlanId());
        assertEquals(1, plan.getPatientId());
        assertEquals(3, plan.getDentistId());
        assertEquals("Kế hoạch phục hình răng sứ", plan.getTitle());
        assertEquals("Draft", plan.getStatus());
        assertEquals(BigDecimal.ZERO, plan.getEstimatedCost());
        assertEquals(BigDecimal.ZERO, plan.getFinalEstimate());
        verify(planDAO, times(1)).insert(any(TreatmentPlan.class));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi mã bệnh nhân không hợp lệ (<= 0)")
    void createTreatmentPlan_InvalidPatient_ThrowsException() {
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.createTreatmentPlan(0, 3, "Kế hoạch", "Chẩn đoán", null));
        assertTrue(ex.getMessage().contains("bệnh nhân"));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi mã bác sĩ không hợp lệ (<= 0)")
    void createTreatmentPlan_InvalidDentist_ThrowsException() {
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.createTreatmentPlan(1, 0, "Kế hoạch", "Chẩn đoán", null));
        assertTrue(ex.getMessage().contains("bác sĩ"));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi tiêu đề kế hoạch bị để trống")
    void createTreatmentPlan_EmptyTitle_ThrowsException() {
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.createTreatmentPlan(1, 3, "   ", "Chẩn đoán", null));
        assertTrue(ex.getMessage().contains("Tên kế hoạch"));
    }

    @Test
    @DisplayName("Thêm thủ thuật vào kế hoạch thành công với răng FDI và mặt răng hợp lệ")
    void addPlanItem_Success_WithFdiToothAndSurface() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch trám răng", "Sâu răng", "Draft");
        when(planDAO.findById(101)).thenReturn(plan);

        DentalService catalogSrv = new DentalService(5, "SR-TRAM-01", "Trám răng thẩm mỹ Composite", "TramRang",
                new BigDecimal("500000"), "Răng", "Trám xoang sâu", true);
        when(serviceDAO.findById(5)).thenReturn(catalogSrv);
        when(planDAO.insertItem(any(TreatmentPlanItem.class))).thenReturn(201);

        TreatmentPlanItem item = service.addPlanItem(101, 5, 46, "Occlusal", 2, null, 1, "Trám mặt nhai");

        assertNotNull(item);
        assertEquals(201, item.getItemId());
        assertEquals(46, item.getToothNumber());
        assertEquals("Occlusal", item.getSurface());
        assertEquals(2, item.getQuantity());
        assertEquals(new BigDecimal("500000"), item.getUnitPrice());
        assertEquals(new BigDecimal("1000000"), item.getSubTotal());
        assertEquals("Proposed", item.getStatus());
        verify(planDAO, times(1)).insertItem(any(TreatmentPlanItem.class));
    }

    @ParameterizedTest
    @ValueSource(ints = {9, 10, 19, 20, 29, 30, 39, 40, 49, 50, 99})
    @DisplayName("Ném ngoại lệ khi số hiệu răng không thuộc chuẩn quốc tế FDI")
    void addPlanItem_InvalidFdiTooth_ThrowsException(int invalidTooth) {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch", "Chẩn đoán", "Draft");
        when(planDAO.findById(101)).thenReturn(plan);

        DentalService catalogSrv = new DentalService(5, "SR-01", "Dịch vụ", "NhaKhoa",
                new BigDecimal("100000"), "Răng", null, true);
        when(serviceDAO.findById(5)).thenReturn(catalogSrv);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.addPlanItem(101, 5, invalidTooth, "Occlusal", 1, null, 1, null));
        assertTrue(ex.getMessage().contains("FDI"));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi mặt răng không hợp lệ")
    void addPlanItem_InvalidSurface_ThrowsException() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch", "Chẩn đoán", "Draft");
        when(planDAO.findById(101)).thenReturn(plan);

        DentalService catalogSrv = new DentalService(5, "SR-01", "Dịch vụ", "NhaKhoa",
                new BigDecimal("100000"), "Răng", null, true);
        when(serviceDAO.findById(5)).thenReturn(catalogSrv);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.addPlanItem(101, 5, 46, "KhongHopLe", 1, null, 1, null));
        assertTrue(ex.getMessage().contains("Mặt răng không hợp lệ"));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi chọn dịch vụ đã tạm ngưng hoạt động")
    void addPlanItem_InactiveService_ThrowsException() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch", "Chẩn đoán", "Draft");
        when(planDAO.findById(101)).thenReturn(plan);

        DentalService catalogSrv = new DentalService(5, "SR-01", "Dịch vụ ngưng", "NhaKhoa",
                new BigDecimal("100000"), "Răng", null, false);
        when(serviceDAO.findById(5)).thenReturn(catalogSrv);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.addPlanItem(101, 5, 46, "WholeTooth", 1, null, 1, null));
        assertTrue(ex.getMessage().contains("tạm ngưng"));
    }

    @Test
    @DisplayName("Chặn không cho thêm thủ thuật vào kế hoạch đã Hoàn Thành (Completed)")
    void addPlanItem_CompletedPlan_ThrowsException() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch cũ", "Chẩn đoán", "Completed");
        when(planDAO.findById(101)).thenReturn(plan);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                service.addPlanItem(101, 5, 46, "WholeTooth", 1, null, 1, null));
        assertTrue(ex.getMessage().contains("đã hoàn thành"));
    }

    @Test
    @DisplayName("Ném ngoại lệ khi gửi duyệt kế hoạch trống không có thủ thuật nào")
    void submitPlanForReview_NoItems_ThrowsException() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch trống", "Chẩn đoán", "Draft");
        plan.setItems(new ArrayList<>());
        when(planDAO.findById(101)).thenReturn(plan);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                service.submitPlanForReview(101));
        assertTrue(ex.getMessage().contains("ít nhất 1 thủ thuật"));
    }

    @Test
    @DisplayName("Gửi duyệt kế hoạch thành công chuyển trạng thái sang Proposed")
    void submitPlanForReview_Success() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch đầy đủ", "Chẩn đoán", "Draft");
        List<TreatmentPlanItem> items = new ArrayList<>();
        items.add(new TreatmentPlanItem(101, 1, 11, "WholeTooth", 1, new BigDecimal("1000000"), 1));
        plan.setItems(items);
        when(planDAO.findById(101)).thenReturn(plan);
        when(planDAO.updateStatus(eq(101), eq("Proposed"), anyString())).thenReturn(true);

        TreatmentPlan submitted = service.submitPlanForReview(101);

        assertNotNull(submitted);
        assertEquals("Proposed", submitted.getStatus());
        verify(planDAO, times(1)).updateStatus(eq(101), eq("Proposed"), anyString());
    }

    @Test
    @DisplayName("Tính toán chiết khấu và tổng dự toán chi phí chính xác (UC21)")
    void updateEstimateDiscount_CalculatesCorrectFinalEstimate() {
        TreatmentPlan plan = new TreatmentPlan(101, 1, 3, "Kế hoạch", "Chẩn đoán", "Draft");
        plan.setEstimatedCost(new BigDecimal("10000000")); // 10 triệu
        when(planDAO.findById(101)).thenReturn(plan);
        when(planDAO.update(any(TreatmentPlan.class))).thenReturn(true);

        // Chiết khấu 1.5 triệu -> Dự toán cuối = 8.5 triệu
        TreatmentPlan result = service.updateEstimateDiscount(101, new BigDecimal("1500000"));

        assertEquals(new BigDecimal("1500000"), result.getTotalDiscount());
        assertEquals(new BigDecimal("8500000"), result.getFinalEstimate());

        // Chiết khấu vượt quá tổng chi phí -> Tự động chặn bằng mức tối đa
        TreatmentPlan capped = service.updateEstimateDiscount(101, new BigDecimal("12000000"));
        assertEquals(new BigDecimal("10000000"), capped.getTotalDiscount());
        assertEquals(BigDecimal.ZERO, capped.getFinalEstimate());
    }

    @Test
    @DisplayName("Chặn xóa thủ thuật đang thực hiện hoặc đã hoàn thành")
    void removePlanItem_CompletedItem_ThrowsException() {
        TreatmentPlanItem item = new TreatmentPlanItem();
        item.setItemId(201);
        item.setStatus("Completed");
        when(planDAO.findItemById(201)).thenReturn(item);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                service.removePlanItem(201, 101));
        assertTrue(ex.getMessage().contains("đang thực hiện hoặc đã hoàn thành"));
    }
}

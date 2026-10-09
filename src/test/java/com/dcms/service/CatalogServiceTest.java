package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.model.DentalService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CatalogServiceTest {

    @Mock
    private DentalServiceDAO serviceDAO;

    private CatalogService catalogService;

    @BeforeEach
    public void setUp() {
        catalogService = new CatalogService(serviceDAO);
    }

    @Test
    @DisplayName("TC_CAT_01: List All Services Success")
    public void testListAllServices() {
        DentalService s1 = new DentalService(1, "SR-01", "Trám răng", "TramRang", new BigDecimal("450000"), "Răng", "Mô tả", true);
        DentalService s2 = new DentalService(2, "SR-02", "Lấy cao răng", "KhamTongQuat", new BigDecimal("250000"), "Lần", "Mô tả", true);

        when(serviceDAO.findAll(true)).thenReturn(Arrays.asList(s1, s2));

        List<DentalService> result = catalogService.listAllServices(true);
        assertEquals(2, result.size());
        verify(serviceDAO, times(1)).findAll(true);
    }

    @Test
    @DisplayName("TC_CAT_02: List Services By Category")
    public void testListServicesByCategory() {
        DentalService s1 = new DentalService(1, "SR-01", "Trám răng", "TramRang", new BigDecimal("450000"), "Răng", "Mô tả", true);

        when(serviceDAO.findByCategory("TramRang", true)).thenReturn(List.of(s1));

        List<DentalService> result = catalogService.listServicesByCategory("TramRang", true);
        assertEquals(1, result.size());
        assertEquals("TramRang", result.get(0).getCategory());
        verify(serviceDAO, times(1)).findByCategory("TramRang", true);
    }

    @Test
    @DisplayName("TC_CAT_03: Create Service Success")
    public void testCreateService_Success() {
        DentalService newService = new DentalService();
        newService.setServiceCode("SR-TRAM-03");
        newService.setServiceName("Trám xoang V Composite");
        newService.setCategory("TramRang");
        newService.setPrice(new BigDecimal("500000"));
        newService.setUnit("Răng");
        newService.setActive(true);

        when(serviceDAO.findByCode("SR-TRAM-03")).thenReturn(null);
        when(serviceDAO.insert(any(DentalService.class))).thenReturn(20);

        DentalService created = catalogService.createService(newService);
        assertNotNull(created);
        assertEquals(20, created.getServiceId());
        verify(serviceDAO, times(1)).insert(newService);
    }

    @Test
    @DisplayName("TC_CAT_04: Reject Create Service When Code Exists")
    public void testCreateService_DuplicateCode_ThrowsException() {
        DentalService newService = new DentalService();
        newService.setServiceCode("SR-KHAM");
        newService.setServiceName("Khám răng trùng mã");
        newService.setCategory("KhamTongQuat");
        newService.setPrice(new BigDecimal("100000"));

        DentalService existing = new DentalService(1, "SR-KHAM", "Khám cũ", "KhamTongQuat", new BigDecimal("100000"), "Lần", "", true);
        when(serviceDAO.findByCode("SR-KHAM")).thenReturn(existing);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            catalogService.createService(newService);
        });

        assertTrue(ex.getMessage().contains("đã tồn tại"));
        verify(serviceDAO, never()).insert(any());
    }

    @Test
    @DisplayName("TC_CAT_05: Reject Negative Price Invariant")
    public void testCreateService_NegativePrice_ThrowsException() {
        DentalService newService = new DentalService();
        newService.setServiceCode("SR-FAIL");
        newService.setServiceName("Dịch vụ giá âm");
        newService.setCategory("TramRang");
        newService.setPrice(new BigDecimal("-10000"));

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            catalogService.createService(newService);
        });

        assertTrue(ex.getMessage().contains("không được âm"));
    }

    @Test
    @DisplayName("TC_CAT_06: Reject Blank Service Name")
    public void testCreateService_BlankName_ThrowsException() {
        DentalService newService = new DentalService();
        newService.setServiceCode("SR-VALID");
        newService.setServiceName("   ");
        newService.setCategory("TramRang");
        newService.setPrice(new BigDecimal("100000"));

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            catalogService.createService(newService);
        });

        assertTrue(ex.getMessage().contains("không được để trống"));
    }

    @Test
    @DisplayName("TC_CAT_07: Update Service Success")
    public void testUpdateService_Success() {
        DentalService existing = new DentalService(5, "SR-IMP-01", "Implant Biotem", "Implant", new BigDecimal("14000000"), "Trụ", "", true);
        when(serviceDAO.findById(5)).thenReturn(existing);
        when(serviceDAO.findByCode("SR-IMP-01")).thenReturn(existing);
        when(serviceDAO.update(any(DentalService.class))).thenReturn(true);

        existing.setPrice(new BigDecimal("14500000"));
        DentalService updated = catalogService.updateService(existing);

        assertNotNull(updated);
        assertEquals(new BigDecimal("14500000"), updated.getPrice());
        verify(serviceDAO, times(1)).update(existing);
    }

    @Test
    @DisplayName("TC_CAT_08: Toggle Service Status Success")
    public void testToggleServiceStatus_Success() {
        DentalService existing = new DentalService(1, "SR-KHAM", "Khám", "KhamTongQuat", new BigDecimal("100000"), "Lần", "", true);
        when(serviceDAO.findById(1)).thenReturn(existing);
        when(serviceDAO.toggleStatus(1)).thenReturn(true);

        boolean result = catalogService.toggleServiceStatus(1);
        assertTrue(result);
        verify(serviceDAO, times(1)).toggleStatus(1);
    }

    @Test
    @DisplayName("TC_CAT_09: Get Non-Existent Service Throws Exception")
    public void testGetInvalidServiceId_ThrowsException() {
        assertThrows(IllegalArgumentException.class, () -> {
            catalogService.getServiceById(0);
        });
    }
}

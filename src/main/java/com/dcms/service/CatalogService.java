package com.dcms.service;

import com.dcms.dao.DentalServiceDAO;
import com.dcms.model.DentalService;

import java.math.BigDecimal;
import java.util.List;

/**
 * Business service handling Dental Procedure & Fee Catalog management (UC40).
 * Implements non-negotiable validation and business invariant enforcement.
 */
public class CatalogService {

    private final DentalServiceDAO serviceDAO;

    public CatalogService() {
        this.serviceDAO = new DentalServiceDAO();
    }

    public CatalogService(DentalServiceDAO serviceDAO) {
        this.serviceDAO = serviceDAO;
    }

    public List<DentalService> listAllServices(boolean onlyActive) {
        return serviceDAO.findAll(onlyActive);
    }

    public List<DentalService> listServicesByCategory(String category, boolean onlyActive) {
        if (category == null || category.trim().isEmpty() || "all".equalsIgnoreCase(category)) {
            return serviceDAO.findAll(onlyActive);
        }
        return serviceDAO.findByCategory(category.trim(), onlyActive);
    }

    public DentalService getServiceById(int serviceId) {
        if (serviceId <= 0) {
            throw new IllegalArgumentException("Mã dịch vụ không hợp lệ: " + serviceId);
        }
        return serviceDAO.findById(serviceId);
    }

    public DentalService getServiceByCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã định danh dịch vụ không được để trống");
        }
        return serviceDAO.findByCode(code.trim());
    }

    public DentalService createService(DentalService service) {
        validateServiceInput(service, true);

        // Enforce uniqueness of ServiceCode
        DentalService existing = serviceDAO.findByCode(service.getServiceCode());
        if (existing != null) {
            throw new IllegalArgumentException("Mã dịch vụ '" + service.getServiceCode() + "' đã tồn tại trong danh mục hệ thống!");
        }

        int generatedId = serviceDAO.insert(service);
        if (generatedId <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể khởi tạo dịch vụ nha khoa mới vào cơ sở dữ liệu");
        }
        service.setServiceId(generatedId);
        return service;
    }

    public DentalService updateService(DentalService service) {
        if (service == null || service.getServiceId() <= 0) {
            throw new IllegalArgumentException("Dịch vụ cần cập nhật không tồn tại hoặc ID không hợp lệ");
        }
        validateServiceInput(service, false);

        DentalService existing = serviceDAO.findById(service.getServiceId());
        if (existing == null) {
            throw new IllegalArgumentException("Không tìm thấy dịch vụ nha khoa với mã ID #" + service.getServiceId());
        }

        // Check if code was modified to another existing service's code
        DentalService duplicateCode = serviceDAO.findByCode(service.getServiceCode());
        if (duplicateCode != null && duplicateCode.getServiceId() != service.getServiceId()) {
            throw new IllegalArgumentException("Mã dịch vụ '" + service.getServiceCode() + "' đã được sử dụng bởi dịch vụ khác!");
        }

        boolean updated = serviceDAO.update(service);
        if (!updated) {
            throw new RuntimeException("Lỗi hệ thống: Không thể cập nhật thông tin dịch vụ nha khoa ID #" + service.getServiceId());
        }
        return service;
    }

    public boolean toggleServiceStatus(int serviceId) {
        if (serviceId <= 0) {
            throw new IllegalArgumentException("Mã dịch vụ không hợp lệ: " + serviceId);
        }
        DentalService existing = serviceDAO.findById(serviceId);
        if (existing == null) {
            throw new IllegalArgumentException("Không tìm thấy dịch vụ nha khoa với mã ID #" + serviceId);
        }
        return serviceDAO.toggleStatus(serviceId);
    }

    private void validateServiceInput(DentalService service, boolean isNew) {
        if (service == null) {
            throw new IllegalArgumentException("Dữ liệu dịch vụ nha khoa không được null");
        }

        if (service.getServiceCode() == null || service.getServiceCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Mã dịch vụ (Service Code) là bắt buộc và không được để trống");
        }

        String code = service.getServiceCode().trim();
        if (code.length() < 2 || code.length() > 50) {
            throw new IllegalArgumentException("Mã dịch vụ phải có độ dài từ 2 đến 50 ký tự");
        }

        if (!code.matches("^[A-Za-z0-9-_]+$")) {
            throw new IllegalArgumentException("Mã dịch vụ chỉ được chứa chữ cái, chữ số, dấu gạch nối (-) hoặc gạch dưới (_)");
        }

        if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên dịch vụ nha khoa là bắt buộc và không được để trống");
        }

        String name = service.getServiceName().trim();
        if (name.length() < 2 || name.length() > 255) {
            throw new IllegalArgumentException("Tên dịch vụ phải có độ dài từ 2 đến 255 ký tự");
        }

        if (service.getCategory() == null || service.getCategory().trim().isEmpty()) {
            throw new IllegalArgumentException("Phân nhóm chuyên khoa dịch vụ là bắt buộc");
        }

        if (service.getPrice() == null) {
            throw new IllegalArgumentException("Đơn giá niêm yết của dịch vụ không được để trống");
        }

        if (service.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Đơn giá dịch vụ không được âm (>= 0 VNĐ)");
        }

        if (service.getUnit() == null || service.getUnit().trim().isEmpty()) {
            service.setUnit("Lần");
        }
    }
}

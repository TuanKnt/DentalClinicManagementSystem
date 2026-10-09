<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activeMenu" value="services" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Mục Dịch Vụ & Biểu Phí — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.0">
    <style>
        .category-filter-chips {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding: 4px 0 16px 0;
            margin-bottom: 8px;
            scrollbar-width: thin;
        }
        .cat-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: 9999px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            background: #ffffff;
            color: var(--text-primary);
            border: 1px solid var(--border);
            white-space: nowrap;
            transition: all var(--transition-fast);
        }
        .cat-chip:hover {
            border-color: var(--drsmile-cyan);
            color: var(--drsmile-navy);
            transform: translateY(-1px);
        }
        .cat-chip.active {
            background: var(--drsmile-navy);
            color: #ffffff;
            border-color: var(--drsmile-navy);
            box-shadow: 0 2px 6px rgba(0, 51, 102, 0.25);
        }
        .cat-chip-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 1px 7px;
            border-radius: 9999px;
            font-size: 11px;
            background: rgba(0, 0, 0, 0.08);
        }
        .cat-chip.active .cat-chip-count {
            background: rgba(255, 255, 255, 0.25);
            color: #ffffff;
        }

        /* Modal backdrop & container */
        .dcms-modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(10, 37, 64, 0.55);
            backdrop-filter: blur(4px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .dcms-modal-backdrop.open {
            display: flex;
        }
        .dcms-modal-dialog {
            background: #ffffff;
            border-radius: 14px;
            width: 100%;
            max-width: 580px;
            box-shadow: 0 20px 40px rgba(0, 51, 102, 0.2);
            border: 1px solid var(--border);
            animation: modalFadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96) translateY(-10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .dcms-modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(135deg, #f0f7fd 0%, #f8fafc 100%);
        }
        .dcms-modal-header h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 700;
            color: var(--drsmile-navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .dcms-modal-close {
            background: none;
            border: none;
            font-size: 24px;
            line-height: 1;
            color: var(--text-muted);
            cursor: pointer;
            padding: 0;
        }
        .dcms-modal-close:hover {
            color: var(--drsmile-navy);
        }
        .dcms-modal-body {
            padding: 22px 24px;
        }
        .dcms-modal-footer {
            padding: 14px 24px;
            background: #f8fafc;
            border-top: 1px solid var(--border-light);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    </style>
</head>
<body>

<div class="app-shell">
    <!-- Reusable Sidebar -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <div class="app-main">
        <!-- Reusable Header -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <main class="page-content">
            <!-- Breadcrumb Trail -->
            <div class="breadcrumb-trail">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span class="breadcrumb-separator">/</span>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Quản Trị</a>
                <span class="breadcrumb-separator">/</span>
                <span>Danh Mục Dịch Vụ & Biểu Phí Niêm Yết</span>
            </div>

<c:set var="u" value="${sessionScope.currentUser}" />
<c:set var="userRole" value="${not empty u.roleName ? u.roleName : (not empty sessionScope.role ? sessionScope.role : '')}" />
<c:set var="isAdmin" value="${userRole eq 'Admin'}" />

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Danh Mục Dịch Vụ Nha Khoa & Biểu Phí Niêm Yết</h1>
                    <p>Chuẩn hóa phác đồ thủ thuật, đơn giá niêm yết theo nhóm chuyên khoa lâm sàng Dr.Smile</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <c:if test="${isAdmin}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                            &larr; Tổng Quan Quản Trị
                        </a>
                        <button type="button" class="btn btn-primary" onclick="openAddModal()">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm Dịch Vụ Mới
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- Flash Notifications -->
            <c:if test="${not empty param.successMessage}">
                <div class="alert alert-success" style="margin-bottom: 20px; display: flex; align-items: center; gap: 10px; padding: 14px 18px; border-radius: 10px; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; font-size: 13.5px; font-weight: 600;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <span>${param.successMessage}</span>
                </div>
            </c:if>
            <c:if test="${not empty param.errorMessage}">
                <div class="alert alert-danger" style="margin-bottom: 20px; display: flex; align-items: center; gap: 10px; padding: 14px 18px; border-radius: 10px; background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; font-size: 13.5px; font-weight: 600;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <span>${param.errorMessage}</span>
                </div>
            </c:if>

            <!-- Metrics KPI Cards -->
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;">
                <div class="kpi-card" style="padding: 16px 20px;">
                    <div class="kpi-icon-box kpi-icon-blue">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${totalCount}</h3>
                        <span>Tổng số dịch vụ nha khoa</span>
                    </div>
                </div>

                <div class="kpi-card" style="padding: 16px 20px;">
                    <div class="kpi-icon-box kpi-icon-green">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${activeCount}</h3>
                        <span>Dịch vụ đang áp dụng</span>
                    </div>
                </div>

                <div class="kpi-card" style="padding: 16px 20px;">
                    <div class="kpi-icon-box kpi-icon-amber">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12" y2="16"/></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${inactiveCount}</h3>
                        <span>Dịch vụ tạm dừng</span>
                    </div>
                </div>
            </div>

            <!-- Category Filter Chips -->
            <div class="category-filter-chips">
                <a href="${pageContext.request.contextPath}/admin/services" 
                   class="cat-chip ${selectedCategory == 'all' ? 'active' : ''}">
                    <span>Tất cả dịch vụ</span>
                    <span class="cat-chip-count">${totalCount}</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=KhamTongQuat" 
                   class="cat-chip ${selectedCategory == 'KhamTongQuat' ? 'active' : ''}">
                    <span>Khám & Chẩn Đoán</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=TramRang" 
                   class="cat-chip ${selectedCategory == 'TramRang' ? 'active' : ''}">
                    <span>Trám Răng Thẩm Mỹ</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=DieuTriTuy" 
                   class="cat-chip ${selectedCategory == 'DieuTriTuy' ? 'active' : ''}">
                    <span>Điều Trị Tủy Vi Phẫu</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=NhoRang" 
                   class="cat-chip ${selectedCategory == 'NhoRang' ? 'active' : ''}">
                    <span>Nhổ Răng Siêu Âm</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=TayTrang" 
                   class="cat-chip ${selectedCategory == 'TayTrang' ? 'active' : ''}">
                    <span>Tẩy Trắng Răng LED</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=RangSu" 
                   class="cat-chip ${selectedCategory == 'RangSu' ? 'active' : ''}">
                    <span>Răng Sứ & Dán Veneer</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/services?category=Implant" 
                   class="cat-chip ${selectedCategory == 'Implant' ? 'active' : ''}">
                    <span>Cấy Ghép Implant</span>
                </a>
            </div>

            <!-- Full-Width Card for Universal Data Table -->
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                        <span>Danh Sách Dịch Vụ Nha Khoa & Đơn Giá Niêm Yết</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span class="badge-pill badge-Confirmed">● ${activeCount} Dịch vụ đang mở</span>
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table-custom doctor-table" data-datatable="true" data-page-size="10" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th style="width: 10%; text-align: center;">Mã Dịch Vụ</th>
                                    <th style="width: 30%;">Tên Dịch Vụ / Thủ Thuật</th>
                                    <th style="width: 18%;">Chuyên Khoa</th>
                                    <th style="width: 10%; text-align: center;">Đơn Vị</th>
                                    <th style="width: 15%; text-align: right;">Đơn Giá Niêm Yết</th>
                                    <th style="width: 10%; text-align: center;">Trạng Thái</th>
                                    <th style="width: 7%; text-align: center;" data-no-sort="true">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty serviceList}">
                                        <tr>
                                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 48px 20px;">
                                                <div style="font-size: 15px; font-weight: 700; color: var(--drsmile-navy); margin-bottom: 4px;">Chưa có dịch vụ nào trong chuyên khoa này</div>
                                                <div style="font-size: 13px;">Nhấn nút "Thêm Dịch Vụ Mới" ở trên để khai báo dịch vụ đầu tiên.</div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="s" items="${serviceList}">
                                            <tr>
                                                <td style="text-align: center;">
                                                    <span class="badge-code">${s.serviceCode}</span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13.5px;">
                                                        ${s.serviceName}
                                                    </div>
                                                    <c:if test="${not empty s.description}">
                                                        <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                            ${s.description}
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge-specialty">
                                                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20M2 12h20"/></svg>
                                                        ${s.categoryDisplayName}
                                                    </span>
                                                </td>
                                                <td style="text-align: center;">
                                                    <span class="badge-room">
                                                        ${s.unit}
                                                    </span>
                                                </td>
                                                <td style="text-align: right;">
                                                    <span style="font-weight: 700; color: var(--drsmile-navy); font-size: 14px;">
                                                        ${s.formattedPrice}
                                                    </span>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${s.active}">
                                                            <span class="status-pill status-pill-success">
                                                                <span class="status-dot"></span>
                                                                Áp dụng
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill status-pill-muted">
                                                                <span class="status-dot"></span>
                                                                Tạm ngưng
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${isAdmin}">
                                                            <div style="display: flex; gap: 6px; justify-content: center;">
                                                                <button type="button" class="btn-action-outline" title="Chỉnh sửa dịch vụ"
                                                                        onclick="openEditModal(${s.serviceId}, '${s.serviceCode}', '${s.serviceName}', '${s.category}', ${s.price}, '${s.unit}', '${s.description}', ${s.active})">
                                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                                    Sửa
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/admin/services/toggle" method="POST" style="margin: 0; display: inline;">
                                                                    <input type="hidden" name="serviceId" value="${s.serviceId}">
                                                                    <button type="submit" class="${s.active ? 'btn-action-danger' : 'btn-action-outline'}" 
                                                                            title="${s.active ? 'Tạm ngưng dịch vụ' : 'Kích hoạt lại dịch vụ'}">
                                                                        ${s.active ? 'Ngưng' : 'Mở'}
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 600;">Tra cứu</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODALS: ADD & EDIT DENTAL SERVICE (ADMIN ONLY) -->
<!-- ========================================================================= -->
<c:if test="${isAdmin}">
<div id="addServiceModal" class="dcms-modal-backdrop">
    <div class="dcms-modal-dialog">
        <form action="${pageContext.request.contextPath}/admin/services/create" method="POST">
            <div class="dcms-modal-header">
                <h3>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2.5"><path d="M12 5v14M5 12h14"/></svg>
                    Thêm Dịch Vụ Nha Khoa Mới
                </h3>
                <button type="button" class="dcms-modal-close" onclick="closeModal('addServiceModal')">&times;</button>
            </div>
            <div class="dcms-modal-body">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Mã Dịch Vụ *</label>
                        <input type="text" name="serviceCode" class="form-control" placeholder="Ví dụ: SR-TRAM-03" required style="font-weight: 600; text-transform: uppercase;">
                    </div>
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Chuyên Khoa *</label>
                        <select name="category" class="form-control" required>
                            <option value="KhamTongQuat">Khám & Chẩn Đoán</option>
                            <option value="TramRang" selected>Trám Răng Thẩm Mỹ</option>
                            <option value="DieuTriTuy">Điều Trị Tủy Vi Phẫu</option>
                            <option value="NhoRang">Nhổ Răng & Tiểu Phẫu</option>
                            <option value="TayTrang">Tẩy Trắng Răng</option>
                            <option value="RangSu">Răng Sứ & Veneer</option>
                            <option value="Implant">Cấy Ghép Implant</option>
                            <option value="ChinhNha">Chỉnh Nha - Niềng Răng</option>
                        </select>
                    </div>
                </div>

                <div style="margin-bottom: 14px;">
                    <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Tên Dịch Vụ / Thủ Thuật *</label>
                    <input type="text" name="serviceName" class="form-control" placeholder="Ví dụ: Trám răng Composite răng cối lớn" required>
                </div>

                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Đơn Giá Niêm Yết (VNĐ) *</label>
                        <input type="number" name="price" class="form-control" placeholder="500000" min="0" step="10000" required style="font-weight: 700;">
                    </div>
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Đơn Vị Tính *</label>
                        <select name="unit" class="form-control">
                            <option value="Răng" selected>Răng</option>
                            <option value="Lần">Lần</option>
                            <option value="Trụ">Trụ</option>
                            <option value="Liệu trình">Liệu trình</option>
                            <option value="Hàm">Hàm</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Mô Tả / Chỉ Định Lâm Sàng</label>
                    <textarea name="description" class="form-control" rows="2" placeholder="Ghi chú quy cách vật liệu, thời gian bảo hành..."></textarea>
                </div>
            </div>
            <div class="dcms-modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addServiceModal')">Hủy Bỏ</button>
                <button type="submit" class="btn btn-primary">Lưu Vào Danh Mục</button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL: EDIT DENTAL SERVICE -->
<!-- ========================================================================= -->
<div id="editServiceModal" class="dcms-modal-backdrop">
    <div class="dcms-modal-dialog">
        <form action="${pageContext.request.contextPath}/admin/services/update" method="POST">
            <input type="hidden" name="serviceId" id="edit_serviceId">
            <div class="dcms-modal-header">
                <h3>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    Chỉnh Sửa Dịch Vụ Nha Khoa
                </h3>
                <button type="button" class="dcms-modal-close" onclick="closeModal('editServiceModal')">&times;</button>
            </div>
            <div class="dcms-modal-body">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Mã Dịch Vụ *</label>
                        <input type="text" name="serviceCode" id="edit_serviceCode" class="form-control" required style="font-weight: 600;">
                    </div>
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Chuyên Khoa *</label>
                        <select name="category" id="edit_category" class="form-control" required>
                            <option value="KhamTongQuat">Khám & Chẩn Đoán</option>
                            <option value="TramRang">Trám Răng Thẩm Mỹ</option>
                            <option value="DieuTriTuy">Điều Trị Tủy Vi Phẫu</option>
                            <option value="NhoRang">Nhổ Răng & Tiểu Phẫu</option>
                            <option value="TayTrang">Tẩy Trắng Răng</option>
                            <option value="RangSu">Răng Sứ & Veneer</option>
                            <option value="Implant">Cấy Ghép Implant</option>
                            <option value="ChinhNha">Chỉnh Nha - Niềng Răng</option>
                        </select>
                    </div>
                </div>

                <div style="margin-bottom: 14px;">
                    <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Tên Dịch Vụ / Thủ Thuật *</label>
                    <input type="text" name="serviceName" id="edit_serviceName" class="form-control" required>
                </div>

                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Đơn Giá Niêm Yết (VNĐ) *</label>
                        <input type="number" name="price" id="edit_price" class="form-control" min="0" step="10000" required style="font-weight: 700;">
                    </div>
                    <div>
                        <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Đơn Vị Tính *</label>
                        <select name="unit" id="edit_unit" class="form-control">
                            <option value="Răng">Răng</option>
                            <option value="Lần">Lần</option>
                            <option value="Trụ">Trụ</option>
                            <option value="Liệu trình">Liệu trình</option>
                            <option value="Hàm">Hàm</option>
                        </select>
                    </div>
                </div>

                <div style="margin-bottom: 14px;">
                    <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Mô Tả / Chỉ Định Lâm Sàng</label>
                    <textarea name="description" id="edit_description" class="form-control" rows="2"></textarea>
                </div>

                <div>
                    <label class="form-label" style="font-weight: 700; font-size: 12.5px; color: var(--drsmile-navy); margin-bottom: 6px; display: block;">Trạng Thái Áp Dụng</label>
                    <select name="isActive" id="edit_isActive" class="form-control">
                        <option value="1">Đang Áp Dụng Niêm Yết</option>
                        <option value="0">Tạm Ngưng Áp Dụng</option>
                    </select>
                </div>
            </div>
            <div class="dcms-modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editServiceModal')">Hủy Bỏ</button>
                <button type="submit" class="btn btn-primary">Cập Nhật Thông Tin</button>
            </div>
        </form>
    </div>
</div>
</c:if>

<!-- DCMS Universal Data Table Standard Engine -->
<script src="${pageContext.request.contextPath}/assets/js/dcms-datatable.js?v=2.1" charset="UTF-8"></script>

<c:if test="${isAdmin}">
<script>
    function openAddModal() {
        document.getElementById('addServiceModal').classList.add('open');
    }

    function openEditModal(id, code, name, category, price, unit, desc, active) {
        document.getElementById('edit_serviceId').value = id;
        document.getElementById('edit_serviceCode').value = code;
        document.getElementById('edit_serviceName').value = name;
        document.getElementById('edit_category').value = category;
        document.getElementById('edit_price').value = Math.round(price);
        document.getElementById('edit_unit').value = unit;
        document.getElementById('edit_description').value = desc || '';
        document.getElementById('edit_isActive').value = active ? '1' : '0';
        document.getElementById('editServiceModal').classList.add('open');
    }
</script>
</c:if>

<script>
    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('open');
    }

    // Close modal on Escape key or outside click
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.dcms-modal-backdrop').forEach(m => m.classList.remove('open'));
        }
    });

    document.querySelectorAll('.dcms-modal-backdrop').forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.classList.remove('open');
            }
        });
    });
</script>

</body>
</html>

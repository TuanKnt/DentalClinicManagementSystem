<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activeMenu" value="treatment_plans" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Kế Hoạch Điều Trị #KH-${plan.planId} — DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.2">
    <style>
        .plan-layout-grid {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 24px;
            align-items: start;
        }

        .plan-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(0, 51, 102, 0.08);
            box-shadow: 0 4px 16px rgba(0, 51, 102, 0.04);
            padding: 24px;
            margin-bottom: 24px;
        }

        .meta-field-label {
            font-size: 12px;
            color: var(--text-secondary);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .meta-field-val {
            font-size: 14.5px;
            color: var(--drsmile-navy);
            font-weight: 600;
        }

        .session-badge {
            background: #e0f2fe;
            color: #0369a1;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            display: inline-block;
            border: 1px solid #bae6fd;
            white-space: nowrap !important;
        }

        .tooth-badge {
            background: #f1f5f9;
            color: #334155;
            font-weight: 700;
            font-family: 'Inter', monospace;
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 12px;
            border: 1px solid #cbd5e1;
            white-space: nowrap !important;
        }

        .estimate-summary-card {
            background: linear-gradient(135deg, #003366 0%, #0052cc 100%);
            color: #ffffff;
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0, 51, 102, 0.2);
            position: sticky;
            top: 24px;
        }

        .estimate-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.12);
            font-size: 13.5px;
        }

        .estimate-row.total-row {
            border-bottom: none;
            padding-top: 14px;
            margin-top: 6px;
            font-size: 16px;
            font-weight: 800;
        }

        .estimate-total-val {
            font-size: 22px;
            font-weight: 900;
            color: #38bdf8;
            letter-spacing: -0.5px;
        }

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1050;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-overlay.show {
            display: flex;
        }
        .modal-dialog-custom {
            background: #ffffff;
            border-radius: var(--radius-xl);
            width: 100%;
            max-width: 620px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: modalPop 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }
        @keyframes modalPop {
            0% { transform: scale(0.95); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        @media (max-width: 992px) {
            .plan-layout-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="../layout/header.jsp" />

        <main class="page-body">
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
                <a href="${pageContext.request.contextPath}/treatment/plans" style="color: var(--drsmile-blue); text-decoration: none; font-size: 13.5px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                    <span>←</span> Quay lại danh sách phác đồ điều trị
                </a>

                <c:set var="u" value="${sessionScope.currentUser}" />
                <c:set var="userRole" value="${not empty u.roleName ? u.roleName : (not empty sessionScope.role ? sessionScope.role : '')}" />
                <c:set var="isClinician" value="${userRole eq 'Admin' or userRole eq 'Dentist'}" />

                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${pageContext.request.contextPath}/treatment/plans/print-estimate?id=${plan.planId}" target="_blank" class="btn btn-secondary" style="font-weight: 700;">
                        <span>In Bảng Dự Toán</span>
                    </a>

                    <c:if test="${isClinician and plan.status eq 'Draft'}">
                        <button type="button" class="btn btn-drsmile" onclick="openAddItemModal()">
                            <span>+ Thêm Thủ Thuật</span>
                        </button>
                        <form action="${pageContext.request.contextPath}/treatment/plans/submit" method="POST" style="margin: 0;" onsubmit="return confirm('Xác nhận gửi kế hoạch này cho bệnh nhân tư vấn và phê duyệt?');">
                            <input type="hidden" name="planId" value="${plan.planId}">
                            <button type="submit" class="btn btn-primary" style="background: #0284c7; border-color: #0284c7;">
                                <span>Gửi Bệnh Nhân Duyệt</span>
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- Feedback banners -->
            <c:if test="${not empty param.msg}">
                <div class="alert-banner alert-banner-success" style="margin-bottom: 20px; padding: 12px 16px;">
                    <span class="alert-banner-icon">✓</span>
                    <div>
                        <c:choose>
                            <c:when test="${param.msg eq 'created'}">Đã khởi tạo kế hoạch điều trị thành công! Hãy thêm các thủ thuật chi tiết bên dưới.</c:when>
                            <c:when test="${param.msg eq 'item_added'}">Đã thêm thủ thuật vào kế hoạch điều trị thành công.</c:when>
                            <c:when test="${param.msg eq 'item_deleted'}">Đã xóa thủ thuật khỏi kế hoạch điều trị.</c:when>
                            <c:when test="${param.msg eq 'discount_updated'}">Đã cập nhật mức chiết khấu và tính lại dự toán chi phí.</c:when>
                            <c:when test="${param.msg eq 'submitted'}">Kế hoạch đã được chuyển sang trạng thái "Chờ bệnh nhân duyệt" (Proposed).</c:when>
                            <c:otherwise>Thao tác thành công.</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert-banner alert-banner-danger" style="margin-bottom: 20px; padding: 12px 16px;">
                    <span class="alert-banner-icon">!</span>
                    <div>${param.error}</div>
                </div>
            </c:if>

            <div class="plan-layout-grid">
                <!-- Left Column: Plan Information & Itemized Procedures -->
                <div>
                    <!-- Plan Master Info Card -->
                    <div class="plan-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 18px; border-bottom: 1px solid #e2e8f0; padding-bottom: 14px;">
                            <div>
                                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                                    <span style="font-family: 'Inter', monospace; font-weight: 800; color: var(--drsmile-blue); background: #f0f7fd; padding: 2px 8px; border-radius: 6px; font-size: 13px;">
                                        #KH-${plan.planId}
                                    </span>
                                    <span class="status-pill ${plan.statusBadgeClass}">
                                        ${plan.statusDisplayName}
                                    </span>
                                </div>
                                <h2 style="font-size: 20px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                                    ${plan.title}
                                </h2>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 18px;">
                            <div>
                                <div class="meta-field-label">Bệnh Nhân</div>
                                <div class="meta-field-val" style="color: var(--drsmile-navy);">
                                    ${plan.patientName}
                                </div>
                                <div style="font-size: 12px; color: var(--text-secondary);">
                                    SĐT: ${plan.patientPhone}
                                </div>
                            </div>
                            <div>
                                <div class="meta-field-label">Bác Sĩ Phụ Trách</div>
                                <div class="meta-field-val">
                                    ${plan.dentistName}
                                </div>
                                <div style="font-size: 12px; color: var(--drsmile-blue);">
                                    ${plan.dentistSpecialization}
                                </div>
                            </div>
                            <div>
                                <div class="meta-field-label">Thời Gian Tạo</div>
                                <div class="meta-field-val" style="font-size: 13.5px;">
                                    ${plan.createdAt}
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty plan.diagnosis}">
                            <div style="background: #f8fafc; border-radius: 8px; padding: 12px 16px; margin-bottom: 12px; border: 1px solid #e2e8f0;">
                                <div class="meta-field-label" style="color: #475569;">Chẩn Đoán Lâm Sàng & Phim X-Quang</div>
                                <div style="font-size: 13.5px; color: #1e293b; line-height: 1.5;">
                                    ${plan.diagnosis}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty plan.notes}">
                            <div style="background: #f8fafc; border-radius: 8px; padding: 12px 16px; border: 1px solid #e2e8f0;">
                                <div class="meta-field-label" style="color: #475569;">Lộ Trình / Ghi Chú Kế Hoạch</div>
                                <div style="font-size: 13.5px; color: #1e293b; line-height: 1.5;">
                                    ${plan.notes}
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Itemized Procedures Card -->
                    <div class="plan-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                            <div>
                                <h3 style="font-size: 17px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                                    Danh Sách Thủ Thuật Dự Kiến Theo Buổi Điều Trị (UC20)
                                </h3>
                                <div style="font-size: 12.5px; color: var(--text-secondary); margin-top: 2px;">
                                    Tổng cộng: <strong>${plan.items.size()}</strong> hạng mục phác đồ
                                </div>
                            </div>

                            <c:if test="${isClinician and plan.status eq 'Draft'}">
                                <button type="button" class="btn btn-secondary" onclick="openAddItemModal()" style="font-size: 13px; font-weight: 700;">
                                    + Thêm Thủ Thuật
                                </button>
                            </c:if>
                        </div>

                        <c:choose>
                            <c:when test="${empty plan.items}">
                                <div style="text-align: center; padding: 40px 20px; background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;">
                                    <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 15px; margin-bottom: 4px;">
                                        Chưa có thủ thuật nào trong kế hoạch này
                                    </div>
                                    <p style="font-size: 13px; color: var(--text-secondary); margin-bottom: 16px;">
                                        ${isClinician ? 'Nhấn vào nút bên dưới để chọn dịch vụ nha khoa, số hiệu răng và phân bổ buổi hẹn.' : 'Kế hoạch chưa có thủ thuật lâm sàng nào được chỉ định.'}
                                    </p>
                                    <c:if test="${isClinician and plan.status eq 'Draft'}">
                                        <button type="button" class="btn btn-drsmile" onclick="openAddItemModal()">
                                            + Thêm Thủ Thuật Đầu Tiên
                                        </button>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="overflow-x: auto;">
                                    <table class="dcms-table" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th style="width: 10%;">Buổi Khám</th>
                                                <th style="width: 25%;">Thủ Thuật / Dịch Vụ</th>
                                                <th style="width: 18%;">Vị Trí Răng (FDI)</th>
                                                <th style="width: 8%; text-align: center;">SL</th>
                                                <th style="width: 13%; text-align: right;">Đơn Giá</th>
                                                <th style="width: 13%; text-align: right;">Thành Tiền</th>
                                                <th style="width: 8%; text-align: center;">Trạng Thái</th>
                                                <th style="width: 5%; text-align: center;"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${plan.items}">
                                                <tr>
                                                    <td>
                                                        <span class="session-badge">Buổi ${item.priorityOrder}</span>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13px;">
                                                            ${item.serviceName}
                                                        </div>
                                                        <div style="font-size: 11px; color: var(--text-secondary); font-family: 'Inter', monospace;">
                                                            ${item.serviceCode} &bull; ${item.unit}
                                                        </div>
                                                        <c:if test="${not empty item.notes}">
                                                            <div style="font-size: 11.5px; color: #475569; font-style: italic; margin-top: 2px;">
                                                                Ghi chú: ${item.notes}
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty item.toothNumber and item.toothNumber > 0}">
                                                                <span class="tooth-badge">Răng #${item.toothNumber}</span>
                                                                <div style="font-size: 11px; color: var(--text-secondary); margin-top: 2px;">
                                                                    ${item.surface}
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="font-size: 12px; color: var(--text-secondary); font-style: italic;">
                                                                    Toàn hàm / Chung
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align: center; font-weight: 700;">
                                                        ${item.quantity}
                                                    </td>
                                                    <td style="text-align: right; font-size: 13px; color: var(--text-secondary);">
                                                        ${item.formattedUnitPrice}
                                                    </td>
                                                    <td style="text-align: right; font-weight: 800; color: var(--drsmile-navy); font-size: 13.5px;">
                                                        ${item.formattedSubTotal}
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <span class="status-pill ${item.statusBadgeClass}" style="font-size: 11px; padding: 2px 8px;">
                                                            ${item.statusDisplayName}
                                                        </span>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <c:if test="${isClinician and plan.status eq 'Draft' and (item.status eq 'Proposed' or item.status eq 'Accepted')}">
                                                            <form action="${pageContext.request.contextPath}/treatment/plans/item/delete" method="POST" style="margin: 0;" onsubmit="return confirm('Bạn có chắc muốn xóa thủ thuật này?');">
                                                                <input type="hidden" name="itemId" value="${item.itemId}">
                                                                <input type="hidden" name="planId" value="${plan.planId}">
                                                                <button type="submit" style="background: none; border: none; color: #ef4444; cursor: pointer; font-size: 16px; padding: 2px;" title="Xóa thủ thuật">
                                                                    &times;
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Right Column: Financial Quotation & Clinical Disclaimer -->
                <div>
                    <div class="estimate-summary-card">
                        <div style="font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; font-weight: 700; margin-bottom: 4px;">
                            Báo Giá & Dự Toán Chi Phí (UC21)
                        </div>
                        <h3 style="font-size: 18px; font-weight: 800; margin: 0 0 16px 0; color: #ffffff;">
                            Tổng Dự Toán Kế Hoạch
                        </h3>

                        <div class="estimate-row">
                            <span style="opacity: 0.9;">Tổng chi phí niêm yết:</span>
                            <span style="font-weight: 700;">${plan.formattedEstimatedCost}</span>
                        </div>

                        <div class="estimate-row">
                            <span style="opacity: 0.9;">Chiết khấu / Ưu đãi:</span>
                            <span style="font-weight: 700; color: #86efac;">- ${plan.formattedTotalDiscount}</span>
                        </div>

                        <div class="estimate-row total-row">
                            <span>Dự toán thanh toán:</span>
                            <span class="estimate-total-val">${plan.formattedFinalEstimate}</span>
                        </div>

                        <c:if test="${plan.status eq 'Draft'}">
                            <button type="button" class="btn" onclick="openDiscountModal()" style="width: 100%; margin-top: 16px; background: rgba(255,255,255,0.15); color: #ffffff; border: 1px solid rgba(255,255,255,0.25); font-weight: 700;">
                                Cập Nhật Mức Chiết Khấu
                            </button>
                        </c:if>

                        <div style="margin-top: 20px; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.15); font-size: 12px; line-height: 1.5; opacity: 0.85;">
                            <strong>Lưu Ý Nghiệp Vụ Viện Phí:</strong> Bảng báo giá này là ước tính lâm sàng. Viện phí thực tế chỉ xuất hóa đơn thu tiền cho các thủ thuật đã thực tế hoàn tất tại ghế khám (Iron Rule 3).
                        </div>
                    </div>

                    <div style="background: #ffffff; border-radius: var(--radius-lg); border: 1px solid rgba(0, 51, 102, 0.08); padding: 20px; margin-top: 20px;">
                        <div style="font-size: 13px; font-weight: 800; color: var(--drsmile-navy); margin-bottom: 6px;">
                            Cam Kết Chất Lượng Dr.Smile
                        </div>
                        <p style="font-size: 12.5px; color: var(--text-secondary); line-height: 1.6; margin: 0;">
                            "Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo". Phác đồ minh bạch, rõ ràng tới từng mặt răng.
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Thêm Thủ Thuật Vào Kế Hoạch -->
<div id="addItemModal" class="modal-overlay">
    <div class="modal-dialog-custom">
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 18px 24px; border-bottom: 1px solid #e2e8f0;">
            <h3 style="font-size: 17px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                + Thêm Thủ Thuật Vào Kế Hoạch (UC20)
            </h3>
            <button type="button" onclick="closeAddItemModal()" style="background: none; border: none; font-size: 22px; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/treatment/plans/item/add" method="POST" style="padding: 24px;">
            <input type="hidden" name="planId" value="${plan.planId}">

            <div class="form-group" style="margin-bottom: 16px;">
                <label for="serviceId" class="form-label required">Dịch Vụ / Thủ Thuật Nha Khoa</label>
                <select id="serviceId" name="serviceId" class="form-control" required onchange="handleServiceChange(this)">
                    <option value="">-- Chọn dịch vụ từ biểu phí Dr.Smile --</option>
                    <c:forEach var="srv" items="${activeServices}">
                        <option value="${srv.serviceId}" data-price="${srv.price}">
                            [${srv.serviceCode}] ${srv.serviceName} — ${srv.formattedPrice} / ${srv.unit}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 16px;">
                <div class="form-group">
                    <label for="toothNumber" class="form-label">Số Hiệu Răng (FDI 11 - 48)</label>
                    <input type="number" id="toothNumber" name="toothNumber" class="form-control" 
                           placeholder="VD: 11, 26, 36, 46..." min="11" max="48" />
                    <div style="font-size: 11px; color: var(--text-secondary); margin-top: 3px;">
                        Để trống nếu làm toàn hàm hoặc dịch vụ chung
                    </div>
                </div>

                <div class="form-group">
                    <label for="surface" class="form-label">Mặt Răng (Nếu có)</label>
                    <select id="surface" name="surface" class="form-control">
                        <option value="WholeTooth">Toàn răng</option>
                        <option value="Occlusal">Mặt nhai (Occlusal)</option>
                        <option value="Mesial">Mặt gần (Mesial)</option>
                        <option value="Distal">Mặt xa (Distal)</option>
                        <option value="Buccal">Mặt ngoài (Buccal)</option>
                        <option value="Lingual">Mặt trong (Lingual)</option>
                    </select>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; margin-bottom: 16px;">
                <div class="form-group">
                    <label for="priorityOrder" class="form-label required">Buổi Hẹn / Buổi</label>
                    <input type="number" id="priorityOrder" name="priorityOrder" class="form-control" value="1" min="1" max="20" required />
                </div>

                <div class="form-group">
                    <label for="quantity" class="form-label required">Số Lượng</label>
                    <input type="number" id="quantity" name="quantity" class="form-control" value="1" min="1" required />
                </div>

                <div class="form-group">
                    <label for="unitPrice" class="form-label">Đơn Giá Tùy Chỉnh</label>
                    <input type="number" id="unitPrice" name="unitPrice" class="form-control" placeholder="Mặc định theo catalog" min="0" />
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 20px;">
                <label for="itemNotes" class="form-label">Ghi Chú Kỹ Thuật Lâm Sàng</label>
                <input type="text" id="itemNotes" name="itemNotes" class="form-control" placeholder="VD: Trám xoang I composite thẩm mỹ, hẹn tái khám sau 3 ngày..." />
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid #e2e8f0; padding-top: 16px;">
                <button type="button" class="btn btn-secondary" onclick="closeAddItemModal()">Hủy Bỏ</button>
                <button type="submit" class="btn btn-drsmile">Thêm Vào Kế Hoạch</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Cập Nhật Chiết Khấu -->
<div id="discountModal" class="modal-overlay">
    <div class="modal-dialog-custom" style="max-width: 420px;">
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 18px 20px; border-bottom: 1px solid #e2e8f0;">
            <h3 style="font-size: 16px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                Ưu Đãi / Chiết Khấu Kế Hoạch
            </h3>
            <button type="button" onclick="closeDiscountModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/treatment/plans/estimate/discount" method="POST" style="padding: 20px;">
            <input type="hidden" name="planId" value="${plan.planId}">

            <div class="form-group" style="margin-bottom: 18px;">
                <label for="totalDiscount" class="form-label required">Số Tiền Chiết Khấu (VNĐ)</label>
                <input type="number" id="totalDiscount" name="totalDiscount" class="form-control" 
                       value="${plan.totalDiscount}" min="0" step="10000" required />
                <div style="font-size: 11.5px; color: var(--text-secondary); margin-top: 4px;">
                    Chiết khấu tối đa: ${plan.formattedEstimatedCost}
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 8px;">
                <button type="button" class="btn btn-secondary" onclick="closeDiscountModal()">Hủy</button>
                <button type="submit" class="btn btn-drsmile">Lưu Chiết Khấu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddItemModal() {
        document.getElementById('addItemModal').classList.add('show');
    }
    function closeAddItemModal() {
        document.getElementById('addItemModal').classList.remove('show');
    }
    function openDiscountModal() {
        document.getElementById('discountModal').classList.add('show');
    }
    function closeDiscountModal() {
        document.getElementById('discountModal').classList.remove('show');
    }

    function handleServiceChange(selectEl) {
        const selectedOpt = selectEl.options[selectEl.selectedIndex];
        const price = selectedOpt.getAttribute('data-price');
        if (price) {
            document.getElementById('unitPrice').value = price;
        }
    }

    // Close modals on Escape key
    window.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeAddItemModal();
            closeDiscountModal();
        }
    });
</script>

</body>
</html>

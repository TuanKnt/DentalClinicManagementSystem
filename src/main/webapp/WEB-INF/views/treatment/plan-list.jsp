<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activeMenu" value="treatment_plans" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kế Hoạch Điều Trị Nha Khoa — DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.2">
    <style>
        .page-header-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .kpi-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 24px;
        }

        .kpi-card-tp {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(0, 51, 102, 0.08);
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.03);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .kpi-icon-tp {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }

        .kpi-val-tp {
            font-size: 24px;
            font-weight: 800;
            color: var(--drsmile-navy);
            line-height: 1.1;
        }

        .kpi-label-tp {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 600;
            margin-top: 4px;
        }

        .patient-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .patient-avatar-mini {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #007acc 0%, #00a8cc 100%);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            flex-shrink: 0;
        }

        .table-responsive {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(0, 51, 102, 0.08);
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0, 51, 102, 0.04);
        }

        .btn-action-view {
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12.5px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            white-space: nowrap !important;
        }

        .btn-action-view:hover {
            background: #0284c7;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .plan-code-badge {
            font-family: 'Inter', monospace;
            font-weight: 700;
            color: var(--drsmile-blue);
            background: #f0f7fd;
            padding: 3px 8px;
            border-radius: 6px;
            border: 1px solid #d0e7f9;
            font-size: 12.5px;
            white-space: nowrap !important;
        }

        @media (max-width: 992px) {
            .kpi-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .kpi-row {
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
            <div class="page-header-actions">
                <div>
                    <div style="font-size: 13px; color: var(--drsmile-cyan); font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px;">
                        Khu Khám Lâm Sàng & Phục Hình
                    </div>
                    <h1 style="font-size: 24px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                        Kế Hoạch Điều Trị & Dự Toán Viện Phí
                    </h1>
                    <p style="font-size: 13.5px; color: var(--text-secondary); margin: 4px 0 0 0;">
                        Lập phác đồ điều trị đa buổi, chỉ định răng theo chuẩn FDI và quản lý dự toán chi phí (UC19, UC21, UC23)
                    </p>
                </div>

                <c:set var="u" value="${sessionScope.currentUser}" />
                <c:set var="userRole" value="${not empty u.roleName ? u.roleName : (not empty sessionScope.role ? sessionScope.role : '')}" />
                <c:set var="isClinician" value="${userRole eq 'Admin' or userRole eq 'Dentist'}" />

                <c:if test="${isClinician}">
                    <div style="display: flex; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/treatment/plans/create" class="btn btn-drsmile">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            <span>+ Lập Kế Hoạch Điều Trị Mới</span>
                        </a>
                    </div>
                </c:if>
            </div>

            <!-- KPI Cards Summary -->
            <c:set var="totalCount" value="${plans.size()}" />
            <c:set var="inProgressCount" value="0" />
            <c:set var="proposedCount" value="0" />
            <c:set var="acceptedCount" value="0" />
            <c:forEach var="p" items="${plans}">
                <c:if test="${p.status eq 'InProgress'}"><c:set var="inProgressCount" value="${inProgressCount + 1}" /></c:if>
                <c:if test="${p.status eq 'Proposed'}"><c:set var="proposedCount" value="${proposedCount + 1}" /></c:if>
                <c:if test="${p.status eq 'Accepted'}"><c:set var="acceptedCount" value="${acceptedCount + 1}" /></c:if>
            </c:forEach>

            <div class="kpi-row">
                <div class="kpi-card-tp">
                    <div class="kpi-icon-tp" style="background: rgba(0, 51, 102, 0.08); color: var(--drsmile-navy);">
                        📋
                    </div>
                    <div>
                        <div class="kpi-val-tp">${totalCount}</div>
                        <div class="kpi-label-tp">Tổng kế hoạch đã lập</div>
                    </div>
                </div>

                <div class="kpi-card-tp">
                    <div class="kpi-icon-tp" style="background: rgba(245, 158, 11, 0.12); color: #b45309;">
                        ⏳
                    </div>
                    <div>
                        <div class="kpi-val-tp">${proposedCount}</div>
                        <div class="kpi-label-tp">Chờ bệnh nhân duyệt</div>
                    </div>
                </div>

                <div class="kpi-card-tp">
                    <div class="kpi-icon-tp" style="background: rgba(14, 165, 233, 0.12); color: #0284c7;">
                        🤝
                    </div>
                    <div>
                        <div class="kpi-val-tp">${acceptedCount}</div>
                        <div class="kpi-label-tp">Đã đồng ý điều trị</div>
                    </div>
                </div>

                <div class="kpi-card-tp">
                    <div class="kpi-icon-tp" style="background: rgba(16, 185, 129, 0.12); color: #059669;">
                        ⚡
                    </div>
                    <div>
                        <div class="kpi-val-tp">${inProgressCount}</div>
                        <div class="kpi-label-tp">Đang điều trị tại ghế</div>
                    </div>
                </div>
            </div>

            <!-- Treatment Plans Data Table -->
            <div class="table-responsive">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
                    <div style="font-size: 16px; font-weight: 700; color: var(--drsmile-navy); display: flex; align-items: center; gap: 8px;">
                        <span>Danh Sách Phác Đồ Lâm Sàng Toàn Viện</span>
                    </div>
                </div>

                <table id="treatmentPlansTable" class="dcms-table" data-datatable="true" data-page-size="10" style="width: 100%;">
                    <thead>
                        <tr>
                            <th style="width: 10%;">Mã Kế Hoạch</th>
                            <th style="width: 20%;">Bệnh Nhân</th>
                            <th style="width: 18%;">Bác Sĩ Phụ Trách</th>
                            <th style="width: 22%;">Nội Dung / Chẩn Đoán</th>
                            <th style="width: 12%;">Tổng Dự Toán</th>
                            <th style="width: 10%;">Trạng Thái</th>
                            <th style="width: 8%; text-align: center;" data-no-sort="true">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="plan" items="${plans}">
                            <tr>
                                <td>
                                    <span class="plan-code-badge">#KH-${plan.planId}</span>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar-mini">
                                            ${plan.patientName.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13.5px;">
                                                ${plan.patientName}
                                            </div>
                                            <div style="font-size: 12px; color: var(--text-secondary);">
                                                SĐT: ${plan.patientPhone}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: #1e293b; font-size: 13.5px;">
                                        ${plan.dentistName}
                                    </div>
                                    <div style="font-size: 11.5px; color: var(--drsmile-blue);">
                                        ${plan.dentistSpecialization}
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13px; margin-bottom: 2px;">
                                        ${plan.title}
                                    </div>
                                    <div style="font-size: 12px; color: var(--text-secondary); line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;" title="${plan.diagnosis}">
                                        ${plan.diagnosis}
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight: 800; color: var(--drsmile-navy); font-size: 13.5px;">
                                        ${plan.formattedFinalEstimate}
                                    </div>
                                    <c:if test="${plan.totalDiscount > 0}">
                                        <div style="font-size: 11px; color: #16a34a; font-weight: 600;">
                                            Đã giảm: ${plan.formattedTotalDiscount}
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="status-pill ${plan.statusBadgeClass}">
                                        ${plan.statusDisplayName}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/treatment/plans/detail?id=${plan.planId}" class="btn-action-view" title="Xem chi tiết và biểu phí">
                                        <span>👁</span> Xem Chi Tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dcms-datatable.js?v=2.1"></script>
</body>
</html>

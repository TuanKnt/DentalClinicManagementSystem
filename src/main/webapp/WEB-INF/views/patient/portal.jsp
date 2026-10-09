<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activeMenu" value="patient_appointments" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng Bệnh Nhân — Lịch Hẹn & Hồ Sơ Điều Trị | DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.0">
    <style>
        .patient-hero {
            background: linear-gradient(135deg, #003366 0%, #0052cc 60%, #00a8cc 100%);
            border-radius: var(--radius-xl);
            padding: 28px 32px;
            color: #ffffff;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 25px rgba(0, 51, 102, 0.15);
        }
        .patient-hero-info h1 {
            color: #ffffff;
            font-size: 24px;
            font-weight: 800;
            margin: 0 0 6px 0;
        }
        .patient-hero-info p {
            color: rgba(255, 255, 255, 0.85);
            margin: 0;
            font-size: 14px;
        }
        .patient-meta-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 600;
            color: #ffffff;
            margin-top: 10px;
        }
        .section-box {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-light);
        }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--drsmile-navy);
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
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
                <span>Cổng Dành Cho Bệnh Nhân</span>
                <span class="breadcrumb-separator">/</span>
                <span>Lịch Hẹn & Phác Đồ Cá Nhân</span>
            </div>

            <!-- Patient Hero Banner -->
            <div class="patient-hero">
                <div class="patient-hero-info">
                    <h1>Xin chào, <c:out value="${not empty patient.fullName ? patient.fullName : sessionScope.currentUser.fullName}" />!</h1>
                    <p>Tra cứu lịch hẹn khám, theo dõi tiến độ phác đồ nha khoa và tra cứu biểu phí chính thức tại Nha khoa Dr.Smile.</p>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                        <span class="patient-meta-pill">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                            SĐT: <c:out value="${sessionScope.currentUser.phone}" />
                        </span>
                        <c:if test="${not empty patient}">
                            <span class="patient-meta-pill">
                                Mã hồ sơ: #BN-${patient.patientId}
                            </span>
                        </c:if>
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/#booking" class="btn btn-secondary" style="background: #ffffff; color: var(--drsmile-navy); font-weight: 700; border: none; padding: 12px 20px;">
                        + Đặt Lịch Khám Mới
                    </a>
                </div>
            </div>

            <!-- 1. BẢNG LỊCH HẸN CỦA TÔI -->
            <div class="section-box">
                <div class="section-header">
                    <h2 class="section-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                        Lịch Hẹn Khám Răng Của Bạn
                    </h2>
                </div>

                <div class="table-responsive">
                    <table class="table dcms-data-table" data-datatable="true" data-page-size="5">
                        <thead>
                            <tr>
                                <th style="width: 140px;">Ngày Hẹn</th>
                                <th style="width: 130px;">Khung Giờ</th>
                                <th>Bác Sĩ Phụ Trách</th>
                                <th>Lý Do Khám / Dịch Vụ</th>
                                <th style="width: 150px; text-align: center;">Trạng Thái</th>
                                <th style="width: 180px;">Ghi Chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                            Bạn hiện chưa có lịch hẹn nào. Nhấn <strong>"+ Đặt Lịch Khám Mới"</strong> để đăng ký khám với bác sĩ chuyên khoa.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="a" items="${appointments}">
                                        <tr>
                                            <td style="font-weight: 700; color: var(--drsmile-navy);">
                                                ${a.appointmentDate}
                                            </td>
                                            <td>
                                                <span class="badge-code">${a.startTime} – ${a.endTime}</span>
                                            </td>
                                            <td style="font-weight: 600;">
                                                <c:out value="${not empty a.dentistName ? a.dentistName : 'Nha khoa phân bổ'}" />
                                            </td>
                                            <td>
                                                <c:out value="${a.reason}" />
                                            </td>
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${a.status eq 'Confirmed'}">
                                                        <span class="status-pill status-pill-success"><span class="status-dot"></span> Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Arrived'}">
                                                        <span class="status-pill status-pill-info"><span class="status-dot"></span> Đã check-in</span>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Completed'}">
                                                        <span class="status-pill status-pill-success"><span class="status-dot"></span> Đã hoàn tất</span>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Cancelled'}">
                                                        <span class="status-pill status-pill-danger"><span class="status-dot"></span> Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pill-warning"><span class="status-dot"></span> Chờ tiếp nhận</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-size: 12px; color: var(--text-muted);">
                                                <c:out value="${a.notes}" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 2. BẢNG KẾ HOẠCH ĐIỀU TRỊ CỦA TÔI -->
            <div class="section-box">
                <div class="section-header">
                    <h2 class="section-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                        Kế Hoạch &amp; Phác Đồ Điều Trị Nha Khoa
                    </h2>
                </div>

                <div class="table-responsive">
                    <table class="table dcms-data-table" data-datatable="true" data-page-size="5">
                        <thead>
                            <tr>
                                <th style="width: 100px; text-align: center;">Mã Phác Đồ</th>
                                <th>Nội Dung Phác Đồ</th>
                                <th>Chẩn Đoán Bác Sĩ</th>
                                <th style="width: 140px; text-align: center;">Trạng Thái</th>
                                <th style="width: 160px; text-align: right;">Dự Toán Viện Phí</th>
                                <th style="width: 120px; text-align: center;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty treatmentPlans}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                            Bạn chưa có phác đồ điều trị nào được lập. Sau buổi khám lâm sàng, bác sĩ sẽ lập phác đồ chi tiết tại đây.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="tp" items="${treatmentPlans}">
                                        <tr>
                                            <td style="text-align: center;">
                                                <span class="badge-code">#KH-${tp.planId}</span>
                                            </td>
                                            <td style="font-weight: 700; color: var(--drsmile-navy);">
                                                ${tp.title}
                                            </td>
                                            <td style="font-size: 13px;">
                                                ${tp.diagnosis}
                                            </td>
                                            <td style="text-align: center;">
                                                <span class="badge ${tp.statusBadgeClass}">
                                                    ${tp.statusDisplayName}
                                                </span>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: var(--drsmile-navy);">
                                                ${tp.formattedFinalEstimate}
                                            </td>
                                            <td style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/treatment/plans/detail?id=${tp.planId}" class="btn-action-outline">
                                                    Xem Chi Tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- DCMS Universal Data Table Standard Engine -->
<script src="${pageContext.request.contextPath}/assets/js/dcms-datatable.js?v=2.1" charset="UTF-8"></script>

</body>
</html>

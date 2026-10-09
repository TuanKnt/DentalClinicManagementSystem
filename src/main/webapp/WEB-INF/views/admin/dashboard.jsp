<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="admin_dashboard" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Quản Trị — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.0">
</head>
<body>

<div class="app-shell">
    <!-- Reusable Sidebar -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <div class="app-main">
        <!-- Reusable Header -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <main class="page-content">
            <!-- Breadcrumbs -->
            <div class="breadcrumb-trail">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span class="breadcrumb-separator">/</span>
                <span>Hệ Thống</span>
                <span class="breadcrumb-separator">/</span>
                <span>Bảng Điều Khiển Quản Trị (Admin)</span>
            </div>

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Tổng Quan Hoạt Động Phòng Khám</h1>
                    <p>Giám sát toàn diện nhân sự, bác sĩ điều trị, khối lượng khám và sức khỏe hệ thống DCMS</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/reception/patients/create" class="btn btn-secondary">
                        + Thêm Bệnh Nhân
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/calendar" class="btn btn-primary">
                        Xem Lịch Toàn Viện
                    </a>
                </div>
            </div>

            <!-- System Metrics KPI Grid -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-blue">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${totalUsers}</h3>
                        <span>Tài khoản nhân sự</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-purple">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><line x1="19" y1="8" x2="19" y2="14"></line><line x1="16" y1="11" x2="22" y2="11"></line></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${totalDentists}</h3>
                        <span>Bác sĩ nha khoa</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-green">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${totalPatients}</h3>
                        <span>Hồ sơ bệnh nhân</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-amber">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${todayAppointmentsCount}</h3>
                        <span>Lịch hẹn hôm nay</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-red">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${waitingQueueCount}</h3>
                        <span>Chờ khám tại quầy</span>
                    </div>
                </div>
            </div>

            <!-- Two-Column Layout -->
            <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 24px;">
                <!-- Column 1: Dentist Staff & Roster -->
                <div class="card" style="margin-bottom: 0;">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <span>Đội Ngũ Bác Sĩ Nha Khoa Điều Trị</span>
                        </div>
                        <span class="badge-pill badge-Confirmed">● ${totalDentists} Bác sĩ trực sẵn sàng</span>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="table-custom" data-datatable="true" data-page-size="5">
                                <thead>
                                    <tr>
                                        <th style="width: 80px;">Mã BS</th>
                                        <th>Bác Sĩ Điều Trị</th>
                                        <th>Chuyên Môn</th>
                                        <th>Số Điện Thoại</th>
                                        <th style="text-align: center; width: 130px;">Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty dentists}">
                                            <tr>
                                                <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                                    Chưa có dữ liệu bác sĩ nha khoa.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${dentists}">
                                                <tr>
                                                    <td>
                                                        <span class="badge-code">BS-${d.dentistId}</span>
                                                    </td>
                                                    <td>
                                                        <div class="doctor-cell">
                                                            <div class="doctor-avatar-sm">
                                                                ${d.fullName.substring(d.fullName.lastIndexOf(' ') + 1, d.fullName.lastIndexOf(' ') + 2)}
                                                            </div>
                                                            <div>
                                                                <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13.5px;">
                                                                    ${d.fullName}
                                                                </div>
                                                                <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 1px;">
                                                                    ${d.email}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd;">
                                                            ${empty d.specialization ? 'Nha khoa tổng quát' : d.specialization}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="phone-badge">
                                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                                            </svg>
                                                            <span>${d.phoneNumber}</span>
                                                        </div>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <span style="display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 9999px; font-size: 11.5px; font-weight: 700; background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;">
                                                            <span style="width: 6px; height: 6px; border-radius: 50%; background: #10b981;"></span>
                                                            Hoạt động
                                                        </span>
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

                <!-- Column 2: Recent Patients & System Overview -->
                <div style="display: flex; flex-direction: column; gap: 24px;">
                    <!-- Recent Patients -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span>Bệnh Nhân Đăng Ký Mới Gần Đây</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/reception/patients" style="font-size: 13px; color: var(--primary); text-decoration: none; font-weight: 600;">
                                Xem tất cả &rarr;
                            </a>
                        </div>
                        <div class="card-body" style="padding: 16px;">
                            <c:choose>
                                <c:when test="${empty recentPatients}">
                                    <p style="color: var(--text-muted); text-align: center; margin: 20px 0;">Chưa có bệnh nhân nào.</p>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; flex-direction: column; gap: 12px;">
                                        <c:forEach var="p" items="${recentPatients}">
                                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--border);">
                                                <div>
                                                    <div style="font-weight: 600; color: var(--text-primary); font-size: 14px;">
                                                        ${p.fullName}
                                                    </div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                                        SĐT: ${p.phoneNumber} &bull; ${p.gender} &bull; ${p.dateOfBirth}
                                                    </div>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/reception/patients/detail?id=${p.patientId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 12px;">
                                                    Hồ Sơ
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- System Status Card -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <span>Trạng Thái Cụm Hạ Tầng & Dịch Vụ</span>
                            </div>
                        </div>
                        <div class="card-body" style="padding: 20px;">
                            <div style="display: flex; flex-direction: column; gap: 12px; font-size: 13px;">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="color: var(--text-muted);">Cơ sở dữ liệu:</span>
                                    <span class="badge-pill badge-Confirmed">MSSQL 2022 (Port 1434) &bull; Connected</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="color: var(--text-muted);">Mã hóa ngôn ngữ:</span>
                                    <span class="badge-pill badge-Confirmed">UTF-8 / Tiếng Việt có dấu</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="color: var(--text-muted);">Phiên bản ứng dụng:</span>
                                    <span class="badge-pill badge-Pending">v1.3.0 (Dr.Smile Branded)</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="color: var(--text-muted);">Môi trường máy chủ:</span>
                                    <span class="badge-pill badge-Confirmed">Apache Tomcat 10.1.8 (Jakarta EE 10)</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- DCMS Universal Data Table Standard Engine -->
<script src="${pageContext.request.contextPath}/assets/js/dcms-datatable.js?v=2.0" charset="UTF-8"></script>

</body>
</html>

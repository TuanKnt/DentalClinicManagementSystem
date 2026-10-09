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

            <!-- Section 1: Full-Width Doctor Roster Card -->
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Đội Ngũ Bác Sĩ Nha Khoa Điều Trị</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span class="badge-pill badge-Confirmed">● ${totalDentists} Bác sĩ trực sẵn sàng</span>
                        <a href="${pageContext.request.contextPath}/reception/schedules" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; font-size: 12.5px;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            Quản Lý Lịch Phân Ca &rarr;
                        </a>
                    </div>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table-custom doctor-table" data-datatable="true" data-page-size="5" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th style="width: 7%; text-align: center;">Mã BS</th>
                                    <th style="width: 22%;">Bác Sĩ Điều Trị</th>
                                    <th style="width: 24%;">Chuyên Khoa Lâm Sàng</th>
                                    <th style="width: 10%; text-align: center;">Phòng Ghế</th>
                                    <th style="width: 13%;">Số Điện Thoại</th>
                                    <th style="width: 14%; text-align: center;">Trạng Thái</th>
                                    <th style="width: 10%; text-align: center;" data-no-sort="true">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty dentists}">
                                        <tr>
                                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 48px 20px;">
                                                <div style="font-size: 15px; font-weight: 700; color: var(--drsmile-navy); margin-bottom: 4px;">Chưa có dữ liệu bác sĩ nha khoa</div>
                                                <div style="font-size: 13px;">Hệ thống chưa ghi nhận thông tin tài khoản bác sĩ nào.</div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${dentists}">
                                            <tr>
                                                <td style="text-align: center;">
                                                    <span class="badge-code">BS-${d.dentistId}</span>
                                                </td>
                                                <td>
                                                    <div class="doctor-cell">
                                                        <div class="doctor-avatar-sm">
                                                            ${d.fullName.substring(d.fullName.lastIndexOf(' ') + 1, d.fullName.lastIndexOf(' ') + 2)}
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13.5px; white-space: nowrap;">
                                                                ${d.fullName}
                                                            </div>
                                                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 1px; white-space: nowrap;">
                                                                ${d.email}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge-specialty">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20M2 12h20"/></svg>
                                                        ${empty d.specialization ? 'Nha khoa tổng quát' : d.specialization}
                                                    </span>
                                                </td>
                                                <td style="text-align: center;">
                                                    <span class="badge-room">
                                                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                                        ${empty d.roomNumber ? 'P.101' : d.roomNumber}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="phone-badge">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                                        </svg>
                                                        <span>${d.phoneNumber}</span>
                                                    </div>
                                                </td>
                                                <td style="text-align: center;">
                                                    <span class="status-pill status-pill-success">
                                                        <span class="status-dot"></span>
                                                        Đang hoạt động
                                                    </span>
                                                </td>
                                                <td style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/reception/schedules?dentistId=${d.dentistId}" class="btn-action-outline" title="Xem phân ca trực của bác sĩ">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                                        Ca Trực
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
            </div>

            <!-- Section 2: Two-Column Dashboard Overview Grid -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                <!-- Column 1: Recent Patients -->
                <div class="card" style="margin-bottom: 0;">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <span>Bệnh Nhân Đăng Ký Mới Gần Đây</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/reception/patients" style="font-size: 13px; color: var(--drsmile-cyan); text-decoration: none; font-weight: 600;">
                            Xem tất cả hồ sơ &rarr;
                        </a>
                    </div>
                    <div class="card-body" style="padding: 16px;">
                        <c:choose>
                            <c:when test="${empty recentPatients}">
                                <div style="text-align: center; padding: 32px 16px; color: var(--text-muted);">
                                    <p style="margin: 0; font-size: 13.5px;">Chưa có bệnh nhân nào đăng ký gần đây.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="display: flex; flex-direction: column; gap: 12px;">
                                    <c:forEach var="p" items="${recentPatients}">
                                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; background: #f8fafc; border-radius: 10px; border: 1px solid var(--border-light); transition: all 0.2s ease;">
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #e0f2fe 0%, #f0f7fd 100%); color: var(--drsmile-navy); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; border: 1px solid #bae6fd;">
                                                    ${p.fullName.substring(p.fullName.lastIndexOf(' ') + 1, p.fullName.lastIndexOf(' ') + 2)}
                                                </div>
                                                <div>
                                                    <div style="font-weight: 700; color: var(--text-primary); font-size: 13.5px;">
                                                        ${p.fullName} <span class="badge-code" style="font-size: 11px; margin-left: 4px;">#BN-${p.patientId}</span>
                                                    </div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                                        SĐT: <strong>${p.phoneNumber}</strong> &bull; ${p.gender} &bull; ${p.dateOfBirth}
                                                    </div>
                                                </div>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/reception/patients/detail?id=${p.patientId}" class="btn btn-secondary btn-sm" style="padding: 5px 12px; font-size: 12px; white-space: nowrap;">
                                                Bệnh Án
                                            </a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Column 2: System Health & Architecture Status -->
                <div class="card" style="margin-bottom: 0;">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Trạng Thái Cụm Hạ Tầng & Dịch Vụ</span>
                        </div>
                        <span class="status-pill status-pill-success" style="font-size: 11.5px;">
                            <span class="status-dot"></span>
                            Hoạt động bình thường
                        </span>
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <div style="display: flex; flex-direction: column; gap: 14px; font-size: 13px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px; border-bottom: 1px solid var(--border-light);">
                                <span style="color: var(--text-muted); font-weight: 500;">Cơ sở dữ liệu chính:</span>
                                <span class="badge-pill badge-Confirmed" style="font-weight: 700;">MSSQL 2022 (Port 1434) &bull; Connected</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px; border-bottom: 1px solid var(--border-light);">
                                <span style="color: var(--text-muted); font-weight: 500;">Mã hóa & Bộ ký tự:</span>
                                <span class="badge-pill badge-Confirmed" style="font-weight: 700;">UTF-8 / Tiếng Việt có dấu</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px; border-bottom: 1px solid var(--border-light);">
                                <span style="color: var(--text-muted); font-weight: 500;">Chuẩn Bảng Dữ Liệu:</span>
                                <span class="badge-pill badge-Confirmed" style="font-weight: 700;">Universal DataTable v2.1 (Active)</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="color: var(--text-muted); font-weight: 500;">Máy chủ & Web Container:</span>
                                <span class="badge-pill badge-Confirmed" style="font-weight: 700;">Apache Tomcat 10.1.8 (Jakarta EE 10)</span>
                            </div>
                        </div>

                        <!-- Quick Action Shortcuts -->
                        <div style="margin-top: 20px; padding-top: 16px; border-top: 1px dashed var(--border); display: flex; gap: 8px; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/reception/calendar" class="btn btn-secondary btn-sm" style="font-size: 12px; padding: 6px 12px;">
                                Lịch Hẹn Toàn Viện
                            </a>
                            <a href="${pageContext.request.contextPath}/reception/checkin" class="btn btn-secondary btn-sm" style="font-size: 12px; padding: 6px 12px;">
                                Tiếp Đón & Check-in
                            </a>
                            <a href="${pageContext.request.contextPath}/reception/schedules" class="btn btn-secondary btn-sm" style="font-size: 12px; padding: 6px 12px;">
                                Phân Ca Bác Sĩ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- DCMS Universal Data Table Standard Engine -->
<script src="${pageContext.request.contextPath}/assets/js/dcms-datatable.js?v=2.1" charset="UTF-8"></script>

</body>
</html>

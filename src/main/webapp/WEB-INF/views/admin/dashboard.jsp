<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="admin_dashboard" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Quản Trị — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
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
                        <span>➕</span> Thêm Bệnh Nhân
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/calendar" class="btn btn-primary">
                        <span>📅</span> Xem Lịch Toàn Viện
                    </a>
                </div>
            </div>

            <!-- System Metrics KPI Grid -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-blue">👥</div>
                    <div class="kpi-meta">
                        <h3>${totalUsers}</h3>
                        <span>Tài khoản nhân sự</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-purple">🩺</div>
                    <div class="kpi-meta">
                        <h3>${totalDentists}</h3>
                        <span>Bác sĩ nha khoa</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-green">📇</div>
                    <div class="kpi-meta">
                        <h3>${totalPatients}</h3>
                        <span>Hồ sơ bệnh nhân</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-amber">📅</div>
                    <div class="kpi-meta">
                        <h3>${todayAppointmentsCount}</h3>
                        <span>Lịch hẹn hôm nay</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-red">💺</div>
                    <div class="kpi-meta">
                        <h3>${waitingQueueCount}</h3>
                        <span>Chờ khám tại quầy</span>
                    </div>
                </div>
            </div>

            <!-- Two-Column Layout -->
            <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 24px;">
                <!-- Column 1: Dentist Staff & Roster -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>🩺</span>
                            <span>Đội Ngũ Bác Sĩ Nha Khoa Điều Trị</span>
                        </div>
                        <span class="badge-pill badge-Confirmed">● ${totalDentists} Bác sĩ trực sẵn sàng</span>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Mã BS</th>
                                        <th>Bác Sĩ</th>
                                        <th>Chuyên Môn</th>
                                        <th>Số Điện Thoại</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty dentists}">
                                            <tr>
                                                <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                                    Chưa có dữ liệu bác sĩ nha khoa.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${dentists}">
                                                <tr>
                                                    <td><strong>BS-${d.dentistId}</strong></td>
                                                    <td>
                                                        <div style="font-weight: 600; color: var(--text-primary);">
                                                            ${d.fullName}
                                                        </div>
                                                        <div style="font-size: 12px; color: var(--text-muted);">
                                                            ${d.email}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge-pill badge-Pending">
                                                            ${empty d.specialization ? 'Nha khoa tổng quát' : d.specialization}
                                                        </span>
                                                    </td>
                                                    <td><code>${d.phoneNumber}</code></td>
                                                    <td>
                                                        <span class="badge-pill badge-Confirmed">Hoạt động</span>
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
                                <span>📇</span>
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
                                                        📞 ${p.phoneNumber} &bull; ${p.gender} &bull; ${p.dateOfBirth}
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
                                <span>⚙️</span>
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

</body>
</html>

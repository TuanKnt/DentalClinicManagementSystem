<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activeMenu" value="dentist_dashboard" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bàn Làm Việc Bác Sĩ Nha Khoa — DCMS Dental Clinic</title>
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
                <span>Khu Khám Lâm Sàng</span>
                <span class="breadcrumb-separator">/</span>
                <span>Bàn Làm Việc Bác Sĩ (Dentist Workbench)</span>
            </div>

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Bàn Làm Việc Bác Sĩ Nha Khoa</h1>
                    <p>Bác sĩ: <strong>${sessionScope.currentUser != null ? sessionScope.currentUser.fullName : sessionScope.fullName}</strong> &bull; Quản lý ghế khám, hàng đợi bệnh nhân và bệnh án điều trị</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/dentist/queue" class="btn btn-secondary">
                        <span>💺</span> Xem Hàng Đợi Ghế Khám
                    </a>
                </div>
            </div>

            <!-- Toast / Success Messages -->
            <c:if test="${param.success eq 'visit_completed'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">✅</span>
                    <div>
                        <strong>Hoàn tất ca khám:</strong> Đã lưu trữ thành công kết quả khám và đóng lượt khám của bệnh nhân.
                    </div>
                </div>
            </c:if>

            <!-- Dentist KPIs Grid -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-blue">📅</div>
                    <div class="kpi-meta">
                        <h3>${totalApptsCount}</h3>
                        <span>Lịch hẹn của tôi hôm nay</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-amber">⏳</div>
                    <div class="kpi-meta">
                        <h3>${waitingVisits != null ? waitingVisits.size() : 0}</h3>
                        <span>Bệnh nhân đang chờ</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-purple">🩺</div>
                    <div class="kpi-meta">
                        <h3>${inProgressCount}</h3>
                        <span>Ca đang khám tại ghế</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-green">✅</div>
                    <div class="kpi-meta">
                        <h3>${completedCount}</h3>
                        <span>Đã hoàn thành hôm nay</span>
                    </div>
                </div>
            </div>

            <!-- Active / In-Progress Visits Alert -->
            <c:forEach var="v" items="${doctorVisits}">
                <c:if test="${v.status eq 'InProgress'}">
                    <div style="background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border: 2px solid var(--primary); border-radius: 12px; padding: 20px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(14, 165, 233, 0.15);">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="width: 50px; height: 50px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-size: 24px;">
                                🦷
                            </div>
                            <div>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <h3 style="margin: 0; font-size: 18px; color: #1e3a8a;">Ca khám đang mở tại ghế: <strong>${empty v.operatory ? 'Ghế khám chính' : v.operatory}</strong></h3>
                                    <span class="badge-pill badge-Arrived">● Đang khám</span>
                                </div>
                                <div style="color: #1e40af; font-size: 14px; margin-top: 4px;">
                                    Bệnh nhân: <strong>${v.patientName}</strong> &bull; SĐT: <code>${v.patientPhone}</code> &bull; Giờ tiếp đón: ${v.checkInTime.toLocalTime().toString().substring(0, 5)}
                                </div>
                            </div>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/clinical/examination?visitId=${v.visitId}" class="btn btn-primary" style="padding: 12px 24px; font-size: 14px; font-weight: 600;">
                                <span>🩺</span> Mở Hồ Sơ & Sơ Đồ Răng &rarr;
                            </a>
                        </div>
                    </div>
                </c:if>
            </c:forEach>

            <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px;">
                <!-- Left: Waiting Patients Queue with Operatory Selection -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>💺</span>
                            <span>Bệnh Nhân Chờ Khám Tại Ghế</span>
                        </div>
                        <span class="badge-pill badge-Pending">
                            ${empty waitingVisits ? 0 : waitingVisits.size()} Bệnh nhân
                        </span>
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <c:choose>
                            <c:when test="${empty waitingVisits}">
                                <div class="empty-state" style="padding: 30px;">
                                    <span class="empty-state-icon">☕</span>
                                    <h4>Không có bệnh nhân nào đang chờ</h4>
                                    <p>Khi quầy lễ tân check-in tiếp đón, bệnh nhân sẽ xuất hiện ngay tại đây.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="display: flex; flex-direction: column; gap: 16px;">
                                    <c:forEach var="v" items="${waitingVisits}" varStatus="loop">
                                        <form action="${pageContext.request.contextPath}/dentist/start-exam" method="POST" style="margin: 0;">
                                            <input type="hidden" name="visitId" value="${v.visitId}" />
                                            <div style="background: white; border: 1px solid var(--border-color); border-radius: 10px; padding: 16px; display: flex; justify-content: space-between; align-items: center; transition: all 0.2s ease;">
                                                <div>
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <span style="font-weight: 700; color: var(--text-primary); font-size: 15px;">#${loop.index + 1} &bull; ${v.patientName}</span>
                                                        <span class="badge-pill ${v.visitType eq 'Emergency' ? 'badge-Cancelled' : (v.visitType eq 'Scheduled' ? 'badge-Confirmed' : 'badge-Pending')}">
                                                            ${v.visitType eq 'Emergency' ? '🚨 Cấp cứu' : (v.visitType eq 'Scheduled' ? '📅 Có hẹn' : '🚶 Vãng lai')}
                                                        </span>
                                                    </div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">
                                                        📞 ${v.patientPhone} &bull; Check-in: <strong>${v.checkInTime.toLocalTime().toString().substring(0, 5)}</strong>
                                                    </div>
                                                    <c:if test="${not empty v.medicalAlerts || not empty v.allergies}">
                                                        <div style="margin-top: 6px; display: flex; gap: 6px; flex-wrap: wrap;">
                                                            <c:if test="${not empty v.medicalAlerts}">
                                                                <span class="alert-tag">⚠️ ${v.medicalAlerts}</span>
                                                            </c:if>
                                                            <c:if test="${not empty v.allergies}">
                                                                <span class="alert-tag" style="background:#fef3c7; color:#b45309;">⚡ ${v.allergies}</span>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <div style="display: flex; align-items: center; gap: 10px;">
                                                    <select name="operatory" class="form-control" style="width: 140px; padding: 8px 10px; font-size: 13px;">
                                                        <option value="Ghế 1 - P.101">Ghế 1 - P.101</option>
                                                        <option value="Ghế 2 - P.102">Ghế 2 - P.102</option>
                                                        <option value="Ghế 3 - P.103">Ghế 3 - P.103</option>
                                                        <option value="Ghế VIP - P.201">Ghế VIP - P.201</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-success" style="padding: 8px 16px; font-size: 13px; white-space: nowrap;">
                                                        <span>🩺</span> Mời Khám
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Right: Doctor Today Appointments -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>📅</span>
                            <span>Lịch Hẹn Của Bác Sĩ Hôm Nay</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/reception/calendar" style="font-size: 13px; color: var(--primary); text-decoration: none; font-weight: 600;">
                            Xem Lịch &rarr;
                        </a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Giờ Hẹn</th>
                                        <th>Bệnh Nhân</th>
                                        <th>Dịch Vụ / Lý Do</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty todayAppointments}">
                                            <tr>
                                                <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                                    Không có lịch hẹn nào được phân công hôm nay.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="a" items="${todayAppointments}">
                                                <tr>
                                                    <td>
                                                        <strong style="color: var(--primary);">${a.startTime.toString().substring(0, 5)} - ${a.endTime.toString().substring(0, 5)}</strong>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight: 600;">${a.patientName}</div>
                                                        <div style="font-size: 12px; color: var(--text-muted);">${a.patientPhone}</div>
                                                    </td>
                                                    <td>${empty a.reason ? 'Khám nha tổng quát' : a.reason}</td>
                                                    <td>
                                                        <span class="badge-pill badge-${a.status}">${a.status}</span>
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
            </div>
        </main>
    </div>
</div>

</body>
</html>

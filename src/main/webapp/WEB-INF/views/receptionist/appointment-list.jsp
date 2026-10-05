<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="appointments" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Hẹn — Dr.Smile DCMS Dental Care</title>
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
            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Lịch Hẹn Khám Bệnh</h1>
                    <p>Theo dõi lịch hẹn theo ca làm việc, điều phối bệnh nhân đến quầy và chống trùng lịch</p>
                </div>
                <div style="display:flex; gap:10px;">
                    <a href="${pageContext.request.contextPath}/reception/checkin" class="btn btn-secondary">
                        <span>🚪</span> Quầy Check-in
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary">
                        <span>➕</span> Đặt Lịch Hẹn Mới
                    </a>
                </div>
            </div>

            <!-- Toast / Success Messages -->
            <c:if test="${param.success eq 'booked'}">
                <div class="alert-tag" style="background:#ecfdf5;color:#047857;border-color:#a7f3d0;padding:12px 18px;font-size:13.5px;margin-bottom:20px;border-radius:10px;width:100%;">
                    ✅ <strong>Thành công:</strong> Lịch hẹn mới đã được lưu vào hệ thống an toàn!
                </div>
            </c:if>
            <c:if test="${param.success eq 'confirmed'}">
                <div class="alert-tag" style="background:#eff6ff;color:#1d4ed8;border-color:#bfdbfe;padding:12px 18px;font-size:13.5px;margin-bottom:20px;border-radius:10px;width:100%;">
                    ℹ️ <strong>Đã cập nhật:</strong> Bệnh nhân đã xác nhận chắc chắn sẽ đến khám!
                </div>
            </c:if>
            <c:if test="${param.success eq 'cancelled'}">
                <div class="alert-tag" style="background:#fef2f2;color:#b91c1c;border-color:#fecaca;padding:12px 18px;font-size:13.5px;margin-bottom:20px;border-radius:10px;width:100%;">
                    ⚠️ <strong>Đã hủy:</strong> Lịch hẹn đã được hủy theo yêu cầu của bệnh nhân/phòng khám.
                </div>
            </c:if>

            <!-- KPI Summary Widgets -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-blue">📅</div>
                    <div class="kpi-meta">
                        <h3>${empty appointmentList ? 0 : appointmentList.size()}</h3>
                        <span>Tổng lịch hẹn trong ngày</span>
                    </div>
                </div>

                <c:set var="countPending" value="0" />
                <c:set var="countArrived" value="0" />
                <c:set var="countConfirmed" value="0" />
                <c:forEach var="item" items="${appointmentList}">
                    <c:if test="${item.status eq 'Pending'}"><c:set var="countPending" value="${countPending + 1}" /></c:if>
                    <c:if test="${item.status eq 'Confirmed'}"><c:set var="countConfirmed" value="${countConfirmed + 1}" /></c:if>
                    <c:if test="${item.status eq 'Arrived'}"><c:set var="countArrived" value="${countArrived + 1}" /></c:if>
                </c:forEach>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-amber">⏳</div>
                    <div class="kpi-meta">
                        <h3>${countPending + countConfirmed}</h3>
                        <span>Chờ bệnh nhân đến quầy</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-green">🚪</div>
                    <div class="kpi-meta">
                        <h3>${countArrived}</h3>
                        <span>Đã Check-in (Vào khám)</span>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-purple">🩺</div>
                    <div class="kpi-meta">
                        <h3>${empty dentists ? 0 : dentists.size()}</h3>
                        <span>Bác sĩ phụ trách trực ca</span>
                    </div>
                </div>
            </div>

            <!-- Filter Controls -->
            <div class="card" style="margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/reception/appointments" method="GET" style="display:flex; flex-wrap:wrap; gap:16px; align-items:center; padding:16px 20px;">
                    <div class="form-group" style="flex: 0 0 200px;">
                        <label class="form-label">Chọn Ngày Khám</label>
                        <input type="date" name="date" class="form-control" value="${selectedDate}" onchange="this.form.submit()" />
                    </div>

                    <div class="form-group" style="flex: 1; min-width: 240px;">
                        <label class="form-label">Lọc Theo Bác Sĩ Phụ Trách</label>
                        <select name="dentistId" class="form-control" onchange="this.form.submit()">
                            <option value="">-- Tất cả bác sĩ trong ca --</option>
                            <c:forEach var="d" items="${dentists}">
                                <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                    ${d.fullName} — ${d.specialization} (${d.roomNumber})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="margin-left: auto; display:flex; gap:8px; align-self: flex-end;">
                        <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-secondary">
                            Hôm Nay
                        </a>
                    </div>
                </form>
            </div>

            <!-- Appointments Data Table -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <span>📋</span> Danh Sách Lịch Hẹn Ngày: <strong style="color:var(--primary);margin-left:4px;">${selectedDate}</strong>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Thời Gian</th>
                                <th>Bệnh Nhân</th>
                                <th>Số Điện Thoại</th>
                                <th>Bác Sĩ Phụ Trách</th>
                                <th>Lý Do Khám</th>
                                <th>Trạng Thái</th>
                                <th style="text-align: right;">Thao Tác Nghiệp Vụ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty appointmentList}">
                                    <tr>
                                        <td colspan="7">
                                            <div class="empty-state">
                                                <span class="empty-state-icon">📭</span>
                                                <h4>Không có lịch hẹn nào</h4>
                                                <p>Ngày <strong>${selectedDate}</strong> hiện chưa có bệnh nhân nào đặt lịch khám.</p>
                                                <div style="margin-top:16px;">
                                                    <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary btn-sm">
                                                        <span>➕</span> Đặt lịch ngay cho ngày này
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="a" items="${appointmentList}">
                                        <tr>
                                            <td>
                                                <div style="font-weight:700; color:var(--text-primary);">
                                                    ${a.startTime} — ${a.endTime}
                                                </div>
                                                <div style="font-size:11.5px; color:var(--text-muted);">Khung 30-45 phút</div>
                                            </td>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar-sm">
                                                        ${a.patientName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div style="font-weight:700;">${a.patientName}</div>
                                                        <div style="font-size:11.5px; color:var(--text-muted);">Mã hồ sơ: #${a.patientId}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span style="font-family:monospace; font-weight:600; background:#f1f5f9; padding:4px 8px; border-radius:6px;">
                                                    ${a.patientPhone}
                                                </span>
                                            </td>
                                            <td>
                                                <div style="font-weight:600; color:var(--primary);">${a.dentistName}</div>
                                                <div style="font-size:11.5px; color:var(--text-muted);">Bác sĩ khám chính</div>
                                            </td>
                                            <td>
                                                <div style="max-width: 220px; font-size:13px;">
                                                    ${not empty a.reason ? a.reason : 'Khám tổng quát định kỳ'}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge-pill badge-${a.status}">
                                                    ● ${a.status}
                                                </span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display:inline-flex; gap:6px; justify-content: flex-end;">
                                                    <c:if test="${a.status eq 'Pending'}">
                                                        <form action="${pageContext.request.contextPath}/reception/appointments/confirm" method="POST" style="display:inline;">
                                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                                            <input type="hidden" name="returnDate" value="${selectedDate}" />
                                                            <button type="submit" class="btn btn-secondary btn-sm" title="Xác nhận bệnh nhân chắc chắn đến">
                                                                Xác Nhận
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${a.canBeCheckedIn()}">
                                                        <form action="${pageContext.request.contextPath}/reception/checkin" method="POST" style="display:inline;">
                                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                                            <button type="submit" class="btn btn-success btn-sm" title="Bệnh nhân đã có mặt -> Tạo lượt khám thực tế">
                                                                <span>🚪</span> Check-in
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${a.canBeCancelled()}">
                                                        <button type="button" class="btn btn-danger-subtle btn-sm" onclick="cancelAppointment(${a.appointmentId})">
                                                            Hủy
                                                        </button>
                                                    </c:if>
                                                </div>
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

<form id="cancelForm" action="${pageContext.request.contextPath}/reception/appointments/cancel" method="POST" style="display:none;">
    <input type="hidden" name="appointmentId" id="cancelApptId" />
    <input type="hidden" name="reason" id="cancelReason" />
    <input type="hidden" name="returnDate" value="${selectedDate}" />
</form>

<script>
    function cancelAppointment(id) {
        var reason = prompt("Vui lòng nhập lý do hủy lịch hẹn:", "Bận việc đột xuất");
        if (reason !== null && reason.trim() !== "") {
            document.getElementById('cancelApptId').value = id;
            document.getElementById('cancelReason').value = reason;
            document.getElementById('cancelForm').submit();
        }
    }
</script>

</body>
</html>

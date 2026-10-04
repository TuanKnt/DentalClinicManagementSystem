<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiếp Đón & Check-in Bệnh Nhân — DCMS</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        body { background-color: var(--bg); color: var(--text-main); min-height: 100vh; }
        
        .navbar { background: #ffffff; border-bottom: 1px solid var(--border); padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { font-size: 18px; font-weight: 700; color: var(--primary); text-decoration: none; }
        .nav-links a { color: var(--text-muted); text-decoration: none; font-size: 14px; margin-left: 20px; font-weight: 500; }
        .nav-links a:hover, .nav-links a.active { color: var(--primary); }

        .container { max-width: 1200px; width: 100%; margin: 30px auto; padding: 0 20px; }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .header-title h1 { font-size: 22px; font-weight: 700; }
        .header-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 9px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: var(--primary-hover); }
        .btn-success { background: #10b981; color: white; }
        .btn-success:hover { background: #059669; }

        .section-card { background: white; border-radius: 12px; border: 1px solid var(--border); margin-bottom: 28px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
        .section-header { padding: 16px 20px; background: #f8fafc; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        .section-header h2 { font-size: 16px; font-weight: 700; }
        .badge-count { background: var(--primary); color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; }

        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
        th { background: #ffffff; padding: 12px 18px; font-weight: 600; color: var(--text-muted); border-bottom: 1px solid var(--border); font-size: 13px; }
        td { padding: 14px 18px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        tr:hover { background-color: #f1f5f9; }

        .alert-tag { background: #fee2e2; color: #b91c1c; font-size: 11px; font-weight: 600; padding: 2px 6px; border-radius: 4px; display: inline-block; }
        .type-badge { font-size: 12px; font-weight: 600; padding: 2px 8px; border-radius: 6px; }
        .type-Scheduled { background: #e0f2fe; color: #0369a1; }
        .type-WalkIn { background: #fef3c7; color: #b45309; }
        .type-Emergency { background: #fee2e2; color: #b91c1c; }

        .alert-bar { padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #15803d; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">🦷 DCMS Clinic</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/reception/appointments">Lịch Hẹn</a>
        <a href="${pageContext.request.contextPath}/reception/patients">Hồ Sơ Bệnh Nhân</a>
        <a href="${pageContext.request.contextPath}/reception/checkin" class="active">Tiếp Đón / Check-in</a>
        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất (${sessionScope.currentUser.fullName})</a>
    </div>
</nav>

<div class="container">
    <div class="header-section">
        <div class="header-title">
            <h1>Trung Tâm Tiếp Đón & Check-in (Hôm Nay: ${todayDate})</h1>
            <p>Quy tắc cốt lõi: Check-in biến Lịch hẹn thành Lượt khám thực tế; Khách vãng lai vào thẳng hàng đợi</p>
        </div>
        <a href="${pageContext.request.contextPath}/reception/walkin" class="btn btn-primary">
            <span>🚶</span> Tiếp Nhận Khách Vãng Lai (Walk-in)
        </a>
    </div>

    <c:if test="${param.success eq 'checkedin'}">
        <div class="alert-bar alert-success">✅ Bệnh nhân đã check-in thành công và đưa vào hàng đợi khám (Lượt khám #${param.visitId})!</div>
    </c:if>
    <c:if test="${param.success eq 'walkin'}">
        <div class="alert-bar alert-success">✅ Tiếp nhận khách vãng lai thành công! (Lượt khám #${param.visitId})</div>
    </c:if>

    <!-- SECTION 1: TODAY'S ACTIVE WAITING QUEUE -->
    <div class="section-card">
        <div class="section-header">
            <h2>Hàng Đợi Chờ Khám Hiện Tại (Ghế Khám)</h2>
            <span class="badge-count">${waitingQueue.size()} Bệnh nhân đang chờ</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Thời Điểm Đến</th>
                    <th>Bệnh Nhân</th>
                    <th>Số Điện Thoại</th>
                    <th>Bác Sĩ Phụ Trách</th>
                    <th>Loại Tiếp Nhận</th>
                    <th>Cảnh Báo Y Tế</th>
                    <th>Trạng Thái</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty waitingQueue}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                Hiện tại không có bệnh nhân nào trong hàng đợi chờ khám.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="v" items="${waitingQueue}" varStatus="status">
                            <tr>
                                <td><strong>#${status.index + 1}</strong></td>
                                <td>${v.checkInTime.toLocalTime().toString().substring(0, 5)}</td>
                                <td>
                                    <strong>${v.patientName}</strong>
                                    <div style="font-size: 11px; color: var(--text-muted);">Visit ID: #${v.visitId}</div>
                                </td>
                                <td><code>${v.patientPhone}</code></td>
                                <td>${v.dentistName}</td>
                                <td>
                                    <span class="type-badge type-${v.visitType}">
                                        ${v.visitType eq 'Scheduled' ? 'Có hẹn' : (v.visitType eq 'WalkIn' ? 'Vãng lai' : 'Cấp cứu')}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty v.medicalAlerts}">
                                        <span class="alert-tag">⚠️ ${v.medicalAlerts}</span>
                                    </c:if>
                                    <c:if test="${not empty v.allergies}">
                                        <span class="alert-tag">⚡ Dị ứng: ${v.allergies}</span>
                                    </c:if>
                                    <c:if test="${empty v.medicalAlerts && empty v.allergies}">
                                        <span style="color:var(--text-muted);font-size:12px;">Không có</span>
                                    </c:if>
                                </td>
                                <td>
                                    <span style="color: #b45309; font-weight: 600; font-size: 13px;">⏳ Chờ gọi khám</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- SECTION 2: TODAY'S SCHEDULED APPOINTMENTS READY FOR CHECK-IN -->
    <div class="section-card">
        <div class="section-header">
            <h2>Lịch Hẹn Trong Ngày Đang Chờ Bệnh Nhân Đến Quầy</h2>
            <span style="font-size: 12px; color: var(--text-muted);">Bấm Check-in ngay khi bệnh nhân có mặt</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Giờ Dự Kiến</th>
                    <th>Bệnh Nhân</th>
                    <th>Số Điện Thoại</th>
                    <th>Bác Sĩ Phụ Trách</th>
                    <th>Lý Do Khám</th>
                    <th>Trạng Thái Lịch</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty todayAppointments}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                Hôm nay không có lịch hẹn nào được ghi nhận.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="a" items="${todayAppointments}">
                            <tr>
                                <td><strong>${a.startTime} - ${a.endTime}</strong></td>
                                <td>
                                    <strong>${a.patientName}</strong>
                                    <div style="font-size: 11px; color: var(--text-muted);">Mã BN: #${a.patientId}</div>
                                </td>
                                <td><code>${a.patientPhone}</code></td>
                                <td>${a.dentistName}</td>
                                <td>${a.reason}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.status eq 'Arrived'}">
                                            <span style="color: #15803d; font-weight: 600;">Đã Check-in</span>
                                        </c:when>
                                        <c:when test="${a.status eq 'Confirmed'}">
                                            <span style="color: #0369a1; font-weight: 600;">Đã xác nhận</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #b45309; font-weight: 600;">${a.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${a.canBeCheckedIn()}">
                                        <form action="${pageContext.request.contextPath}/reception/checkin" method="POST">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                            <button type="submit" class="btn btn-success">✅ Tiếp Đón / Check-in</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${a.status eq 'Arrived'}">
                                        <span style="color:var(--text-muted);font-size:12px;">Đang ở ghế khám</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Hẹn — DCMS</title>
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
        body { background-color: var(--bg); color: var(--text-main); display: flex; flex-direction: column; min-height: 100vh; }
        
        .navbar { background: #ffffff; border-bottom: 1px solid var(--border); padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { font-size: 18px; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .nav-links a { color: var(--text-muted); text-decoration: none; font-size: 14px; margin-left: 20px; font-weight: 500; }
        .nav-links a:hover, .nav-links a.active { color: var(--primary); }

        .container { max-width: 1200px; width: 100%; margin: 30px auto; padding: 0 20px; }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .header-title h1 { font-size: 22px; font-weight: 700; }
        .header-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 9px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: var(--primary-hover); }
        .btn-success { background: #10b981; color: white; }
        .btn-success:hover { background: #059669; }
        .btn-warning { background: #f59e0b; color: white; }
        .btn-danger { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        .btn-danger:hover { background: #fecaca; }

        .filter-card { background: white; padding: 16px 20px; border-radius: 12px; border: 1px solid var(--border); margin-bottom: 20px; display: flex; gap: 14px; align-items: center; }
        .filter-group { display: flex; align-items: center; gap: 8px; }
        .filter-group label { font-size: 13px; font-weight: 600; }
        input[type="date"], select { padding: 8px 12px; border-radius: 8px; border: 1px solid var(--border); font-size: 13px; outline: none; }

        .table-card { background: white; border-radius: 12px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
        th { background: #f8fafc; padding: 14px 18px; font-weight: 600; color: var(--text-muted); border-bottom: 1px solid var(--border); font-size: 13px; }
        td { padding: 14px 18px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        tr:hover { background-color: #f1f5f9; }

        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; }
        .status-Pending { background: #fef3c7; color: #b45309; }
        .status-Confirmed { background: #e0f2fe; color: #0369a1; }
        .status-Arrived { background: #dcfce7; color: #15803d; }
        .status-Completed { background: #f1f5f9; color: #475569; }
        .status-Cancelled { background: #fee2e2; color: #b91c1c; }

        .alert-bar { padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #15803d; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">🦷 DCMS Clinic</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/reception/appointments" class="active">Lịch Hẹn</a>
        <a href="${pageContext.request.contextPath}/reception/patients">Hồ Sơ Bệnh Nhân</a>
        <a href="${pageContext.request.contextPath}/reception/checkin">Tiếp Đón / Check-in</a>
        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất (${sessionScope.currentUser.fullName})</a>
    </div>
</nav>

<div class="container">
    <div class="header-section">
        <div class="header-title">
            <h1>Lịch Hẹn Khám Bệnh</h1>
            <p>Theo dõi lịch hẹn theo ngày, chống trùng lịch và điều phối tiếp đón</p>
        </div>
        <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary">
            <span>📅</span> Đặt Lịch Hẹn Mới
        </a>
    </div>

    <c:if test="${param.success eq 'booked'}">
        <div class="alert-bar alert-success">✅ Đặt lịch hẹn mới thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'confirmed'}">
        <div class="alert-bar alert-success">✅ Đã xác nhận lịch hẹn!</div>
    </c:if>
    <c:if test="${param.success eq 'cancelled'}">
        <div class="alert-bar alert-success">✅ Đã hủy lịch hẹn theo yêu cầu!</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/reception/appointments" method="GET" class="filter-card">
        <div class="filter-group">
            <label for="date">Chọn Ngày:</label>
            <input type="date" id="date" name="date" value="${selectedDate}" onchange="this.form.submit()" />
        </div>

        <div class="filter-group">
            <label for="dentistId">Bác Sĩ:</label>
            <select id="dentistId" name="dentistId" onchange="this.form.submit()">
                <option value="">-- Tất cả bác sĩ --</option>
                <c:forEach var="d" items="${dentists}">
                    <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                        ${d.fullName} (${d.specialization})
                    </option>
                </c:forEach>
            </select>
        </div>

        <div style="margin-left: auto;">
            <a href="${pageContext.request.contextPath}/reception/appointments" class="btn" style="background:#e2e8f0;color:#0f172a;">Hôm Nay</a>
        </div>
    </form>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Giờ Hẹn</th>
                    <th>Bệnh Nhân</th>
                    <th>Số Điện Thoại</th>
                    <th>Bác Sĩ Phụ Trách</th>
                    <th>Lý Do Khám</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty appointmentList}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                📭 Không có lịch hẹn nào trong ngày đã chọn.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="a" items="${appointmentList}">
                            <tr>
                                <td>
                                    <strong>${a.startTime} - ${a.endTime}</strong>
                                </td>
                                <td>
                                    <strong>${a.patientName}</strong>
                                    <div style="font-size: 11px; color: var(--text-muted);">Mã BN: #${a.patientId}</div>
                                </td>
                                <td><code>${a.patientPhone}</code></td>
                                <td>${a.dentistName}</td>
                                <td>${a.reason}</td>
                                <td>
                                    <span class="status-badge status-${a.status}">${a.status}</span>
                                </td>
                                <td style="display: flex; gap: 6px; align-items: center;">
                                    <c:if test="${a.status eq 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/reception/appointments/confirm" method="POST" style="display:inline;">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                            <input type="hidden" name="returnDate" value="${selectedDate}" />
                                            <button type="submit" class="btn btn-warning" title="Xác nhận khách sẽ đến">Xác Nhận</button>
                                        </form>
                                    </c:if>

                                    <c:if test="${a.canBeCheckedIn()}">
                                        <form action="${pageContext.request.contextPath}/reception/checkin" method="POST" style="display:inline;">
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                            <button type="submit" class="btn btn-success" title="Bệnh nhân đã đến quầy -> Tạo lượt khám">Check-in</button>
                                        </form>
                                    </c:if>

                                    <c:if test="${a.canBeCancelled()}">
                                        <button type="button" class="btn btn-danger" onclick="cancelAppointment(${a.appointmentId})">Hủy</button>
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

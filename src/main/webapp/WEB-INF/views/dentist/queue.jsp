<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hàng Đợi Khám Bệnh Nhân — Bác Sĩ Nha Khoa</title>
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

        .container { max-width: 1100px; width: 100%; margin: 30px auto; padding: 0 20px; }
        
        .header-section { margin-bottom: 24px; }
        .header-section h1 { font-size: 22px; font-weight: 700; }
        .header-section p { font-size: 13px; color: var(--text-muted); margin-top: 4px; }

        .queue-grid { display: flex; flex-direction: column; gap: 16px; }
        
        .patient-card {
            background: white; border-radius: 14px; border: 1px solid var(--border); padding: 22px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center;
            transition: all 0.2s ease;
        }
        .patient-card:hover { border-color: var(--primary); box-shadow: 0 4px 12px rgba(2, 132, 199, 0.08); }

        .card-info { display: flex; gap: 20px; align-items: center; }
        .order-badge { width: 44px; height: 44px; border-radius: 12px; background: #e0f2fe; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 18px; font-weight: 700; }
        
        .patient-details h3 { font-size: 17px; font-weight: 700; margin-bottom: 4px; }
        .patient-meta { font-size: 13px; color: var(--text-muted); display: flex; gap: 14px; align-items: center; margin-bottom: 8px; }

        .alert-banner { display: flex; gap: 8px; align-items: center; }
        .alert-item { background: #fee2e2; border: 1px solid #fecaca; color: #b91c1c; font-size: 12px; font-weight: 600; padding: 3px 8px; border-radius: 6px; }

        .btn-start {
            background: #10b981; color: white; border: none; padding: 10px 20px; border-radius: 8px;
            font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s;
        }
        .btn-start:hover { background: #059669; }

        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #15803d; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">🦷 DCMS Clinic — Bác Sĩ Nha Khoa</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dentist/queue" class="active">Hàng Đợi Khám</a>
        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất (${sessionScope.currentUser.fullName})</a>
    </div>
</nav>

<div class="container">
    <div class="header-section">
        <h1>Danh Sách Bệnh Nhân Chờ Khám Tại Ghế</h1>
        <p>Bác sĩ: <strong>${sessionScope.currentUser.fullName}</strong> | Danh sách bệnh nhân đã Check-in tại quầy tiếp đón</p>
    </div>

    <c:if test="${param.success eq 'started'}">
        <div class="alert-success">✅ Đã bắt đầu lượt khám lâm sàng! Trạng thái chuyển sang 'InProgress'.</div>
    </c:if>

    <div class="queue-grid">
        <c:choose>
            <c:when test="${empty waitingQueue}">
                <div style="background: white; padding: 48px; border-radius: 12px; border: 1px solid var(--border); text-align: center; color: var(--text-muted);">
                    ☕ Hiện tại không có bệnh nhân nào đang chờ tại ghế của bạn.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="v" items="${waitingQueue}" varStatus="loop">
                    <div class="patient-card">
                        <div class="card-info">
                            <div class="order-badge">#${loop.index + 1}</div>
                            <div class="patient-details">
                                <h3>${v.patientName}</h3>
                                <div class="patient-meta">
                                    <span>📞 ${v.patientPhone}</span>
                                    <span>⏱️ Đến lúc: ${v.checkInTime.toLocalTime().toString().substring(0, 5)}</span>
                                    <span>🏷️ ${v.visitType eq 'Scheduled' ? 'Có lịch hẹn trước' : (v.visitType eq 'WalkIn' ? 'Khách vãng lai' : 'Cấp cứu')}</span>
                                </div>
                                <div style="font-size: 13px; color: var(--text-main); margin-bottom: 6px;">
                                    📝 <strong>Triệu chứng / Yêu cầu:</strong> ${v.notes}
                                </div>
                                <div class="alert-banner">
                                    <c:if test="${not empty v.medicalAlerts}">
                                        <span class="alert-item">⚠️ Bệnh nền: ${v.medicalAlerts}</span>
                                    </c:if>
                                    <c:if test="${not empty v.allergies}">
                                        <span class="alert-item">⚡ Dị ứng: ${v.allergies}</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div>
                            <form action="${pageContext.request.contextPath}/dentist/start-exam" method="POST">
                                <input type="hidden" name="visitId" value="${v.visitId}" />
                                <button type="submit" class="btn-start">🩺 Bắt Đầu Khám</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>

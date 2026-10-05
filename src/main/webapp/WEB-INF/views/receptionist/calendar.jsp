<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="calendar" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hẹn Phòng Khám Dạng Calendar — DCMS Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .calendar-nav-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            padding: 16px 24px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            flex-wrap: wrap;
            gap: 16px;
        }
        .calendar-week-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 12px;
            align-items: stretch;
        }
        .day-column {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            min-height: 540px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .day-column.is-today {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(14, 165, 233, 0.25);
        }
        .day-header {
            padding: 12px 14px;
            background: #f8fafc;
            border-bottom: 1px solid var(--border-color);
            text-align: center;
        }
        .day-column.is-today .day-header {
            background: #e0f2fe;
            color: #0369a1;
        }
        .day-title {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .day-date {
            font-size: 16px;
            font-weight: 800;
            margin-top: 2px;
        }
        .day-body {
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex: 1;
            background: #fafbfc;
        }
        .appt-card {
            background: white;
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--primary);
            border-radius: 8px;
            padding: 10px 12px;
            font-size: 12px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
            transition: all 0.2s ease;
        }
        .appt-card:hover {
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }
        .appt-card.status-Confirmed { border-left-color: #10b981; }
        .appt-card.status-Pending { border-left-color: #f59e0b; }
        .appt-card.status-Arrived { border-left-color: #0ea5e9; }
        .appt-card.status-Completed { border-left-color: #6366f1; }
        .appt-card.status-Cancelled { border-left-color: #94a3b8; opacity: 0.7; }

        .appt-time {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .appt-patient {
            font-weight: 600;
            color: #0f172a;
            font-size: 13px;
            margin-bottom: 2px;
        }
        .appt-meta {
            color: var(--text-muted);
            font-size: 11px;
            line-height: 1.4;
        }
        .appt-actions {
            margin-top: 8px;
            padding-top: 6px;
            border-top: 1px dashed var(--border-color);
            display: flex;
            justify-content: flex-end;
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
            <!-- Breadcrumbs -->
            <div class="breadcrumb-trail">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span class="breadcrumb-separator">/</span>
                <span>Tiếp Đón & Lịch Hẹn</span>
                <span class="breadcrumb-separator">/</span>
                <span>Lịch Hẹn Dạng Calendar (Visual Schedule)</span>
            </div>

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Lịch Hẹn Phòng Khám Nha Khoa</h1>
                    <p>Theo dõi trực quan phân bổ lịch khám theo tuần, khung giờ và bác sĩ phụ trách &bull; Tổng cộng <strong>${totalWeekAppointments}</strong> cuộc hẹn tuần này</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary">
                        <span>➕</span> Đặt Lịch Mới
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/checkin" class="btn btn-secondary">
                        <span>🚪</span> Quầy Check-in
                    </a>
                </div>
            </div>

            <!-- Calendar Navigation & Filter Controls -->
            <div class="calendar-nav-bar">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/reception/calendar?date=${prevWeekDate}&dentistId=${selectedDentistId}" class="btn btn-secondary" style="padding: 8px 14px;">
                        &larr; Tuần Trước
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/calendar?date=${todayDate}&dentistId=${selectedDentistId}" class="btn ${targetDate eq todayDate ? 'btn-primary' : 'btn-secondary'}" style="padding: 8px 16px;">
                        Hôm Nay
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/calendar?date=${nextWeekDate}&dentistId=${selectedDentistId}" class="btn btn-secondary" style="padding: 8px 14px;">
                        Tuần Kế &rarr;
                    </a>
                    <span style="font-weight: 700; font-size: 15px; color: var(--text-primary); margin-left: 8px;">
                        Tuần: ${startOfWeek} &rarr; ${endOfWeek}
                    </span>
                </div>

                <!-- Dentist Filter Form -->
                <form action="${pageContext.request.contextPath}/reception/calendar" method="GET" style="display: flex; align-items: center; gap: 10px; margin: 0;">
                    <input type="hidden" name="date" value="${targetDate}" />
                    <label style="font-size: 13px; font-weight: 600; color: var(--text-muted); margin: 0;">Lọc bác sĩ:</label>
                    <select name="dentistId" class="form-control" style="width: 200px; padding: 7px 12px; font-size: 13px;" onchange="this.form.submit()">
                        <option value="">Tất cả Bác sĩ</option>
                        <c:forEach var="d" items="${dentists}">
                            <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                ${d.fullName} (${d.specialization})
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <!-- Calendar 7-Day Week Columns -->
            <div class="calendar-week-grid">
                <c:forEach var="entry" items="${weekSchedule}">
                    <c:set var="curDate" value="${entry.key}" />
                    <c:set var="dayAppts" value="${entry.value}" />
                    <c:set var="isToday" value="${curDate eq todayDate}" />
                    <c:set var="dowValue" value="${curDate.dayOfWeek.value}" />

                    <div class="day-column ${isToday ? 'is-today' : ''}">
                        <div class="day-header">
                            <div class="day-title">
                                <c:choose>
                                    <c:when test="${dowValue == 1}">Thứ Hai</c:when>
                                    <c:when test="${dowValue == 2}">Thứ Ba</c:when>
                                    <c:when test="${dowValue == 3}">Thứ Tư</c:when>
                                    <c:when test="${dowValue == 4}">Thứ Năm</c:when>
                                    <c:when test="${dowValue == 5}">Thứ Sáu</c:when>
                                    <c:when test="${dowValue == 6}">Thứ Bảy</c:when>
                                    <c:otherwise>Chủ Nhật</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="day-date">
                                ${curDate.dayOfMonth}/${curDate.monthValue}
                            </div>
                            <span class="badge-pill ${empty dayAppts ? 'badge-Pending' : 'badge-Confirmed'}" style="margin-top: 4px; font-size: 10px;">
                                ${empty dayAppts ? 0 : dayAppts.size()} Lịch
                            </span>
                        </div>

                        <div class="day-body">
                            <c:choose>
                                <c:when test="${empty dayAppts}">
                                    <div style="text-align: center; color: var(--text-muted); font-size: 11px; margin-top: 30px;">
                                        Không có lịch
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="a" items="${dayAppts}">
                                        <div class="appt-card status-${a.status}">
                                            <div class="appt-time">
                                                <span>⏱️ ${a.startTime.toString().substring(0, 5)} - ${a.endTime.toString().substring(0, 5)}</span>
                                                <span class="badge-pill badge-${a.status}" style="font-size: 9px; padding: 2px 6px;">${a.status}</span>
                                            </div>
                                            <div class="appt-patient">
                                                ${a.patientName}
                                            </div>
                                            <div class="appt-meta">
                                                <div>📞 ${a.patientPhone}</div>
                                                <div>👨‍⚕️ ${a.dentistName}</div>
                                                <c:if test="${not empty a.reason}">
                                                    <div style="font-style: italic; margin-top: 2px;">💬 ${a.reason}</div>
                                                </c:if>
                                            </div>

                                            <c:if test="${a.status eq 'Pending' || a.status eq 'Confirmed'}">
                                                <div class="appt-actions">
                                                    <form action="${pageContext.request.contextPath}/reception/checkin" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                                        <button type="submit" class="btn btn-secondary" style="padding: 4px 8px; font-size: 11px;">
                                                            🚪 Check-in
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </main>
    </div>
</div>

</body>
</html>

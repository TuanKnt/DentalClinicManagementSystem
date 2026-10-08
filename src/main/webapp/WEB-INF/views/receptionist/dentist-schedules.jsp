<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="schedules" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Trực Bác Sĩ (Dentist Work Schedule) — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .schedule-grid-layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 1024px) {
            .schedule-grid-layout {
                grid-template-columns: 1fr;
            }
        }
        .preset-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-top: 6px;
            margin-bottom: 14px;
        }
        .preset-btn {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            padding: 8px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            cursor: pointer;
            text-align: center;
            transition: all 0.2s;
        }
        .preset-btn:hover {
            background: #e0f2fe;
            border-color: #0284c7;
            color: #0369a1;
        }
        .day-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 12px;
        }
        .day-1, .day-2, .day-3, .day-4, .day-5 {
            background: #e0f2fe;
            color: #0369a1;
        }
        .day-6 {
            background: #fef3c7;
            color: #b45309;
        }
        .day-7 {
            background: #fee2e2;
            color: #b91c1c;
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
                <a href="${pageContext.request.contextPath}/reception/calendar">Lịch Hẹn Khám</a>
                <span class="breadcrumb-separator">/</span>
                <span>Lịch Trực Bác Sĩ (Dentist Work Schedule)</span>
            </div>

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Quản Lý Lịch Trực & Ca Khám Bác Sĩ</h1>
                    <p>Thiết lập ca trực cố định hàng tuần để hệ thống tự động kiểm tra nhận hẹn và chống trùng lịch (UC37)</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/reception/calendar" class="btn btn-secondary">
                        <span>📆</span> Lịch Dạng Calendar
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary">
                        <span>➕</span> Đặt Lịch Hẹn Mới
                    </a>
                </div>
            </div>

            <!-- Success Notification -->
            <c:if test="${param.success eq 'created'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">✅</span>
                    <div><strong>Thành công:</strong> Đã tạo mới ca trực cho Bác sĩ thành công! Lịch hẹn sẽ tự động áp dụng khung giờ này.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="alert-banner alert-banner-info">
                    <span class="alert-banner-icon">🗑️</span>
                    <div><strong>Đã xóa:</strong> Đã gỡ bỏ ca trực khỏi hệ thống.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'toggled'}">
                <div class="alert-banner alert-banner-info">
                    <span class="alert-banner-icon">🔄</span>
                    <div><strong>Cập nhật:</strong> Đã thay đổi trạng thái khả dụng của ca trực.</div>
                </div>
            </c:if>

            <!-- Error Notification -->
            <c:if test="${not empty param.error}">
                <div class="alert-banner alert-banner-danger">
                    <span class="alert-banner-icon">⚠️</span>
                    <div><strong>Lỗi thực hiện:</strong> ${param.error}</div>
                </div>
            </c:if>

            <!-- Stats Overview Row -->
            <div class="kpi-grid" style="margin-bottom: 24px;">
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-title">Tổng Số Ca Trực</span>
                        <span class="kpi-icon">📋</span>
                    </div>
                    <div class="kpi-value">${totalShifts}</div>
                    <div class="kpi-footer">Toàn bộ ca trực thiết lập trong tuần</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-title">Đang Nhận Hẹn Khám</span>
                        <span class="kpi-icon">✅</span>
                    </div>
                    <div class="kpi-value" style="color: #10b981;">${activeShifts}</div>
                    <div class="kpi-footer">Ca trực sẵn sàng phục vụ bệnh nhân</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-title">Tạm Ngưng Nhận Hẹn</span>
                        <span class="kpi-icon">⏸️</span>
                    </div>
                    <div class="kpi-value" style="color: #64748b;">${inactiveShifts}</div>
                    <div class="kpi-footer">Ca trực đang tạm đóng hoặc nghỉ phép</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-title">Bác Sĩ Hệ Thống</span>
                        <span class="kpi-icon">👨‍⚕️</span>
                    </div>
                    <div class="kpi-value" style="color: var(--drsmile-navy);">${dentists.size()}</div>
                    <div class="kpi-footer">Bác sĩ chuyên khoa tại cơ sở phòng khám</div>
                </div>
            </div>

            <!-- Two-Column Layout: Form Add Schedule + Table List Schedules -->
            <div class="schedule-grid-layout">
                <!-- FORM CARD: ADD DENTIST SCHEDULE -->
                <div class="form-card" style="margin: 0;">
                    <div class="form-card-header">
                        <h2>➕ Thêm Ca Trực Bác Sĩ</h2>
                        <p>Khai báo ca làm việc cố định theo thứ trong tuần</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/reception/schedules/create" method="POST">
                        <div class="form-card-body" style="padding: 20px;">
                            <!-- Doctor Selection -->
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="formDentistId" class="form-label required">Bác Sĩ Phụ Trách</label>
                                <select id="formDentistId" name="dentistId" class="form-control" required>
                                    <option value="">-- Chọn bác sĩ --</option>
                                    <c:forEach var="d" items="${dentists}">
                                        <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                            👨‍⚕️ ${d.fullName} (${d.specialization})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Day Of Week -->
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="formDayOfWeek" class="form-label required">Thứ Trong Tuần</label>
                                <select id="formDayOfWeek" name="dayOfWeek" class="form-control" required>
                                    <option value="1">Thứ Hai</option>
                                    <option value="2">Thứ Ba</option>
                                    <option value="3">Thứ Tư</option>
                                    <option value="4">Thứ Năm</option>
                                    <option value="5">Thứ Sáu</option>
                                    <option value="6">Thứ Bảy</option>
                                    <option value="7">Chủ Nhật</option>
                                </select>
                            </div>

                            <!-- Quick Preset Shifts -->
                            <div class="form-group" style="margin-bottom: 12px;">
                                <label class="form-label">Khung Giờ Mẫu Nhanh (Click để chọn nhanh)</label>
                                <div class="preset-buttons">
                                    <button type="button" class="preset-btn" onclick="applyPreset('08:00', '12:00')">
                                        🌅 Sáng (08:00 - 12:00)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('13:00', '17:30')">
                                        🌇 Chiều (13:00 - 17:30)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('13:00', '18:30')">
                                        🌆 Tối (13:00 - 18:30)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('08:00', '18:30')">
                                        ⭐ Cả ngày (08:00 - 18:30)
                                    </button>
                                </div>
                            </div>

                            <!-- Start and End Time Inputs -->
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px;">
                                <div class="form-group">
                                    <label for="shiftStart" class="form-label required">Bắt Đầu</label>
                                    <input type="time" id="shiftStart" name="shiftStart" class="form-control" value="08:00" required />
                                </div>
                                <div class="form-group">
                                    <label for="shiftEnd" class="form-label required">Kết Thúc</label>
                                    <input type="time" id="shiftEnd" name="shiftEnd" class="form-control" value="17:00" required />
                                </div>
                            </div>

                            <!-- Is Available Checkbox -->
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; cursor: pointer;">
                                    <input type="checkbox" name="isAvailable" value="true" checked style="width: 18px; height: 18px;" />
                                    <span>Kích hoạt ca trực (Sẵn sàng nhận hẹn khám)</span>
                                </label>
                            </div>
                        </div>

                        <div class="form-card-footer" style="padding: 16px 20px;">
                            <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                                <span>💾</span> Lưu Ca Trực Bác Sĩ
                            </button>
                        </div>
                    </form>
                </div>

                <!-- TABLE CARD: LIST DENTIST SCHEDULES -->
                <div class="data-table-container">
                    <div style="padding: 18px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                        <div>
                            <h2 style="font-size: 17px; font-weight: 700; color: var(--drsmile-navy); margin: 0;">
                                Danh Sách Ca Trực Đang Áp Dụng
                            </h2>
                            <p style="font-size: 12.5px; color: var(--text-muted); margin: 2px 0 0 0;">
                                Tổng cộng <strong>${scheduleList.size()}</strong> ca làm việc đã đăng ký
                            </p>
                        </div>

                        <!-- Filter by Dentist -->
                        <form action="${pageContext.request.contextPath}/reception/schedules" method="GET" style="display: flex; align-items: center; gap: 8px; margin: 0;">
                            <label style="font-size: 13px; font-weight: 600; color: var(--text-muted); margin: 0;">Lọc theo bác sĩ:</label>
                            <select name="dentistId" class="form-control" style="width: 220px; padding: 6px 10px; font-size: 13px;" onchange="this.form.submit()">
                                <option value="">Tất cả Bác sĩ</option>
                                <c:forEach var="d" items="${dentists}">
                                    <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                        👨‍⚕️ ${d.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">Mã</th>
                                <th>Bác Sĩ Điều Trị</th>
                                <th style="width: 120px;">Thứ Trực</th>
                                <th>Khung Giờ Ca Làm Việc</th>
                                <th style="width: 140px;">Trạng Thái</th>
                                <th style="text-align: right; width: 140px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty scheduleList}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                            Chưa có ca trực nào được thiết lập. Hãy sử dụng form bên trái để thêm ca trực mới!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="s" items="${scheduleList}">
                                        <tr>
                                            <td style="font-family: monospace; font-weight: 600; color: var(--text-muted);">
                                                #${s.scheduleId}
                                            </td>
                                            <td>
                                                <div style="font-weight: 700; color: var(--drsmile-navy);">
                                                    👨‍⚕️ ${s.dentistName}
                                                </div>
                                                <div style="font-size: 12px; color: var(--text-muted);">
                                                    ${s.specialization} &bull; ${s.roomNumber != null ? s.roomNumber : 'Ghế khám'}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="day-badge day-${s.dayOfWeek}">
                                                    📅 ${s.dayOfWeekName}
                                                </span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 700; color: #0f172a; font-family: monospace; font-size: 14px;">
                                                    ⏱️ ${s.shiftTimeFormatted}
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${s.available}">
                                                        <span class="badge-pill badge-Confirmed">
                                                            ● Đang nhận hẹn
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-pill badge-Pending">
                                                            ○ Tạm ngưng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: inline-flex; gap: 6px;">
                                                    <!-- Toggle Availability Form -->
                                                    <form action="${pageContext.request.contextPath}/reception/schedules/toggle" method="POST" style="margin: 0; display: inline;">
                                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}" />
                                                        <input type="hidden" name="available" value="${!s.available}" />
                                                        <input type="hidden" name="returnDentistId" value="${selectedDentistId}" />
                                                        <button type="submit" class="btn btn-secondary btn-sm" title="${s.available ? 'Tạm ngưng nhận hẹn' : 'Kích hoạt ca trực'}">
                                                            ${s.available ? '⏸️' : '▶️'}
                                                        </button>
                                                    </form>

                                                    <!-- Delete Schedule Form -->
                                                    <form action="${pageContext.request.contextPath}/reception/schedules/delete" method="POST" style="margin: 0; display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa ca trực #${s.scheduleId} của ${s.dentistName} vào ${s.dayOfWeekName}?');">
                                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}" />
                                                        <input type="hidden" name="returnDentistId" value="${selectedDentistId}" />
                                                        <button type="submit" class="btn btn-secondary btn-sm" style="color: #ef4444;" title="Xóa ca trực">
                                                            🗑️
                                                        </button>
                                                    </form>
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

<script>
    function applyPreset(start, end) {
        document.getElementById('shiftStart').value = start;
        document.getElementById('shiftEnd').value = end;
    }
</script>

</body>
</html>

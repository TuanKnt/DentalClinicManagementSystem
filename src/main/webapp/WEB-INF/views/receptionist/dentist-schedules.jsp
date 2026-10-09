<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="schedules" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Trực Bác Sĩ (Dentist Work Schedule) — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=2.2">
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
            justify-content: center;
            padding: 4px 12px;
            border-radius: 9999px;
            font-weight: 700;
            font-size: 11.5px;
            letter-spacing: 0.3px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
            white-space: nowrap;
        }
        .day-1, .day-2, .day-3, .day-4, .day-5 {
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }
        .day-6 {
            background: #fef3c7;
            color: #b45309;
            border: 1px solid #fde68a;
        }
        .day-7 {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }
        .btn-action-outline {
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: #334155;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-action-outline:hover {
            background: #f8fafc;
            border-color: #94a3b8;
            color: var(--drsmile-navy);
            transform: translateY(-1px);
        }
        .btn-action-danger {
            border: 1px solid #fecaca;
            background: #fff5f5;
            color: #dc2626;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-action-danger:hover {
            background: #fee2e2;
            border-color: #fca5a5;
            color: #b91c1c;
            transform: translateY(-1px);
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
                        Lịch Dạng Calendar
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/appointments/create" class="btn btn-primary">
                        + Đặt Lịch Hẹn Mới
                    </a>
                </div>
            </div>

            <!-- Success Notification -->
            <c:if test="${param.success eq 'created'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">✓</span>
                    <div><strong>Thành công:</strong> Đã tạo mới ca trực cho Bác sĩ thành công! Lịch hẹn sẽ tự động áp dụng khung giờ này.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="alert-banner alert-banner-info">
                    <span class="alert-banner-icon">✓</span>
                    <div><strong>Đã xóa:</strong> Đã gỡ bỏ ca trực khỏi hệ thống.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'toggled'}">
                <div class="alert-banner alert-banner-info">
                    <span class="alert-banner-icon">✓</span>
                    <div><strong>Cập nhật:</strong> Đã thay đổi trạng thái khả dụng của ca trực.</div>
                </div>
            </c:if>

            <!-- Error Notification -->
            <c:if test="${not empty param.error}">
                <div class="alert-banner alert-banner-danger">
                    <span class="alert-banner-icon">!</span>
                    <div><strong>Lỗi thực hiện:</strong> ${param.error}</div>
                </div>
            </c:if>

            <!-- Stats Overview Row -->
            <div class="kpi-grid" style="margin-bottom: 24px;">
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-blue">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${totalShifts}</h3>
                        <span>Tổng số ca trực trong tuần</span>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-green">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${activeShifts}</h3>
                        <span>Đang nhận hẹn khám (Active)</span>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-amber">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="10" y1="15" x2="10" y2="9"></line><line x1="14" y1="15" x2="14" y2="9"></line></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${inactiveShifts}</h3>
                        <span>Tạm ngưng nhận hẹn (Pause)</span>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon-box kpi-icon-purple">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><line x1="19" y1="8" x2="19" y2="14"></line><line x1="16" y1="11" x2="22" y2="11"></line></svg>
                    </div>
                    <div class="kpi-meta">
                        <h3>${dentists.size()}</h3>
                        <span>Bác sĩ chuyên khoa tại cơ sở</span>
                    </div>
                </div>
            </div>

            <!-- Two-Column Layout: Form Add Schedule + Table List Schedules -->
            <div class="schedule-grid-layout">
                <!-- FORM CARD: ADD DENTIST SCHEDULE -->
                <div class="card" style="margin: 0;">
                    <div class="card-header" style="flex-direction: column; align-items: flex-start; gap: 4px;">
                        <div class="card-title">
                            <span>+ Thêm Ca Trực Bác Sĩ</span>
                        </div>
                        <p style="font-size: 12px; color: var(--text-muted); margin: 0;">Khai báo ca làm việc cố định theo thứ trong tuần</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/reception/schedules/create" method="POST">
                        <div class="card-body" style="padding: 20px;">
                            <!-- Doctor Selection -->
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="formDentistId" class="form-label required">Bác Sĩ Phụ Trách</label>
                                <select id="formDentistId" name="dentistId" class="form-control" required>
                                    <option value="">-- Chọn bác sĩ --</option>
                                    <c:forEach var="d" items="${dentists}">
                                        <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                            ${d.fullName} (${d.specialization})
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
                                        Sáng (08:00 - 12:00)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('13:00', '17:30')">
                                        Chiều (13:00 - 17:30)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('13:00', '18:30')">
                                        Tối (13:00 - 18:30)
                                    </button>
                                    <button type="button" class="preset-btn" onclick="applyPreset('08:00', '18:30')">
                                        Cả ngày (08:00 - 18:30)
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
                            <div class="form-group" style="margin-bottom: 8px;">
                                <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; cursor: pointer;">
                                    <input type="checkbox" name="isAvailable" value="true" checked style="width: 18px; height: 18px;" />
                                    <span>Kích hoạt ca trực (Sẵn sàng nhận hẹn khám)</span>
                                </label>
                            </div>
                        </div>

                        <div style="padding: 16px 20px; background: #f8fafc; border-top: 1px solid var(--border-light);">
                            <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                                Lưu Ca Trực Bác Sĩ
                            </button>
                        </div>
                    </form>
                </div>

                <!-- TABLE CARD: LIST DENTIST SCHEDULES -->
                <div class="card" style="margin: 0;">
                    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 14px;">
                        <div>
                            <div class="card-title">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007acc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Danh Sách Ca Trực Đang Áp Dụng</span>
                            </div>
                            <p style="font-size: 12px; color: var(--text-muted); margin: 3px 0 0 0;">
                                Tổng cộng <strong>${scheduleList.size()}</strong> ca làm việc đã thiết lập trong tuần
                            </p>
                        </div>

                        <!-- Filter by Dentist -->
                        <form action="${pageContext.request.contextPath}/reception/schedules" method="GET" style="display: flex; align-items: center; gap: 8px; margin: 0;">
                            <label style="font-size: 12.5px; font-weight: 600; color: var(--text-muted); margin: 0;">Lọc bác sĩ:</label>
                            <select name="dentistId" class="form-control" style="width: 200px; padding: 7px 12px; font-size: 12.5px; border-radius: 8px;" onchange="this.form.submit()">
                                <option value="">-- Tất cả Bác sĩ --</option>
                                <c:forEach var="d" items="${dentists}">
                                    <option value="${d.dentistId}" ${selectedDentistId == d.dentistId ? 'selected' : ''}>
                                        ${d.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th style="width: 70px;">Mã</th>
                                    <th>Bác Sĩ Điều Trị</th>
                                    <th style="width: 110px;">Thứ Trực</th>
                                    <th>Khung Giờ Ca Làm Việc</th>
                                    <th style="width: 150px;">Trạng Thái</th>
                                    <th style="text-align: right; width: 150px;">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty scheduleList}">
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 50px 20px; color: var(--text-muted);">
                                                <div style="font-size: 14px; font-weight: 600; color: var(--drsmile-navy); margin-bottom: 4px;">Chưa có ca trực nào được thiết lập</div>
                                                <div style="font-size: 12.5px;">Hãy sử dụng form bên trái để tạo ca trực cố định hàng tuần cho bác sĩ.</div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="s" items="${scheduleList}">
                                            <tr>
                                                <td>
                                                    <span class="badge-code">#${s.scheduleId}</span>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 12px;">
                                                        <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #003366 0%, #007acc 100%); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13px; flex-shrink: 0; box-shadow: 0 2px 4px rgba(0,51,102,0.15);">
                                                            ${s.dentistName.substring(s.dentistName.lastIndexOf(' ') + 1, s.dentistName.lastIndexOf(' ') + 2)}
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 700; color: var(--drsmile-navy); font-size: 13.5px;">${s.dentistName}</div>
                                                            <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 1px;">
                                                                ${s.specialization} &bull; <span style="color: #0284c7; font-weight: 600;">${s.roomNumber != null ? s.roomNumber : 'Ghế khám'}</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="day-badge day-${s.dayOfWeek}">
                                                        ${s.dayOfWeekName}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="time-badge">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                        <span>${s.shiftTimeFormatted}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${s.available}">
                                                            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 9999px; font-size: 11.5px; font-weight: 700; background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: #10b981;"></span>
                                                                Đang nhận hẹn
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 9999px; font-size: 11.5px; font-weight: 600; background: #f1f5f9; color: #64748b; border: 1px solid #e2e8f0;">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: #94a3b8;"></span>
                                                                Tạm ngưng
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <div style="display: inline-flex; gap: 8px;">
                                                        <!-- Toggle Availability Form -->
                                                        <form action="${pageContext.request.contextPath}/reception/schedules/toggle" method="POST" style="margin: 0; display: inline;">
                                                            <input type="hidden" name="scheduleId" value="${s.scheduleId}" />
                                                            <input type="hidden" name="available" value="${!s.available}" />
                                                            <input type="hidden" name="returnDentistId" value="${selectedDentistId}" />
                                                            <button type="submit" class="btn-action-outline" title="${s.available ? 'Tạm ngưng nhận hẹn' : 'Kích hoạt ca trực'}">
                                                                ${s.available ? 'Tạm ngưng' : 'Kích hoạt'}
                                                            </button>
                                                        </form>

                                                        <!-- Delete Schedule Form -->
                                                        <form action="${pageContext.request.contextPath}/reception/schedules/delete" method="POST" style="margin: 0; display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa ca trực #${s.scheduleId} của ${s.dentistName} vào ${s.dayOfWeekName}?');">
                                                            <input type="hidden" name="scheduleId" value="${s.scheduleId}" />
                                                            <input type="hidden" name="returnDentistId" value="${selectedDentistId}" />
                                                            <button type="submit" class="btn-action-danger" title="Xóa ca trực">
                                                                Xóa
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

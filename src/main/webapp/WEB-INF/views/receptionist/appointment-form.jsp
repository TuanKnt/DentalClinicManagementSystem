<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activeMenu" value="appointments" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Hẹn Khám Bệnh Mới — DCMS Dental Clinic</title>
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
                <a href="${pageContext.request.contextPath}/reception/appointments">Lịch Hẹn Khám</a>
                <span class="breadcrumb-separator">/</span>
                <span>Đặt Lịch Hẹn Mới</span>
            </div>

            <!-- Page Header Row -->
            <div class="page-header-row">
                <div class="page-title">
                    <h1>Đặt Lịch Hẹn Khám Bệnh Mới</h1>
                    <p>Hệ thống tự động kiểm tra ca trực của Bác sĩ và chặn trùng giờ khám theo quy tắc BF-01</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-secondary">
                        <span>←</span> Quay Lại Danh Sách Lịch Hẹn
                    </a>
                </div>
            </div>

            <!-- Error Notification -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-banner alert-banner-danger">
                    <span class="alert-banner-icon">⚠️</span>
                    <div><strong>Lỗi đặt lịch:</strong> ${errorMessage}</div>
                </div>
            </c:if>

            <!-- Form Card -->
            <div class="form-card">
                <div class="form-card-header">
                    <h2>Thông Tin Chi Tiết Lịch Hẹn</h2>
                    <p>Điền đầy đủ thông tin bệnh nhân, bác sĩ điều trị và khung giờ dự kiến khám</p>
                </div>

                <form action="${pageContext.request.contextPath}/reception/appointments/create" method="POST">
                    <div class="form-card-body">
                        <!-- Hidden Patient ID -->
                        <input type="hidden" id="patientId" name="patientId" value="${selectedPatient != null ? selectedPatient.patientId : appt.patientId}" required />

                        <!-- Form Grid -->
                        <div class="form-grid">
                            <!-- Patient Search -->
                            <div class="form-group form-group-full search-autocomplete-box">
                                <label for="patientSearch" class="form-label required">Chọn Bệnh Nhân</label>
                                <div style="display:flex; gap:10px;">
                                    <input type="text" 
                                           id="patientSearch" 
                                           class="form-control" 
                                           placeholder="Gõ số điện thoại, họ tên hoặc CCCD để tìm..." 
                                           autocomplete="off" 
                                           value="${selectedPatient != null ? selectedPatient.fullName : ''}" />
                                    <a href="${pageContext.request.contextPath}/reception/patients/create" class="btn btn-secondary" style="flex-shrink:0;">
                                        <span>➕</span> Tạo Hồ Sơ Mới
                                    </a>
                                </div>
                                <div id="searchResults" class="search-results-floating"></div>

                                <div id="selectedPatientBadge" class="selected-patient-chip" style="${selectedPatient != null ? '' : 'display:none;'}">
                                    <span>👤</span>
                                    <span>Đã chọn: <strong id="selectedPatientName">${selectedPatient.fullName}</strong> — SĐT: <strong id="selectedPatientPhone">${selectedPatient.phone}</strong></span>
                                </div>
                            </div>

                            <!-- Doctor Selection -->
                            <div class="form-group form-group-full">
                                <label for="dentistId" class="form-label required">Bác Sĩ Điều Trị</label>
                                <select id="dentistId" name="dentistId" class="form-control" required>
                                    <option value="">-- Chọn bác sĩ phụ trách --</option>
                                    <c:forEach var="d" items="${dentists}">
                                        <option value="${d.dentistId}" ${appt.dentistId == d.dentistId ? 'selected' : ''}>
                                            👨‍⚕️ ${d.fullName} — ${d.specialization} (${d.roomNumber != null ? d.roomNumber : 'Ghế khám'})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Appointment Date -->
                            <div class="form-group">
                                <label for="appointmentDate" class="form-label required">Ngày Hẹn Khám</label>
                                <input type="date" 
                                       id="appointmentDate" 
                                       name="appointmentDate" 
                                       class="form-control" 
                                       value="${appt.appointmentDate}" 
                                       required />
                            </div>

                            <div><!-- Empty spacer for grid alignment --></div>

                            <!-- Time Slots -->
                            <div class="form-group">
                                <label for="startTime" class="form-label required">Giờ Bắt Đầu</label>
                                <input type="time" 
                                       id="startTime" 
                                       name="startTime" 
                                       class="form-control" 
                                       value="${appt.startTime}" 
                                       required />
                            </div>

                            <div class="form-group">
                                <label for="endTime" class="form-label required">Giờ Kết Thúc Dự Kiến</label>
                                <input type="time" 
                                       id="endTime" 
                                       name="endTime" 
                                       class="form-control" 
                                       value="${appt.endTime}" 
                                       required />
                            </div>

                            <!-- Reason -->
                            <div class="form-group form-group-full">
                                <label for="reason" class="form-label">Lý Do Đến Khám</label>
                                <input type="text" 
                                       id="reason" 
                                       name="reason" 
                                       class="form-control" 
                                       value="${appt.reason}" 
                                       placeholder="Ví dụ: Đau răng hàm dưới, trám răng sâu, tư vấn niềng răng, cạo vôi răng..." />
                            </div>

                            <!-- Notes -->
                            <div class="form-group form-group-full">
                                <label for="notes" class="form-label">Ghi Chú Thêm</label>
                                <textarea id="notes" 
                                          name="notes" 
                                          class="form-control" 
                                          rows="2" 
                                          placeholder="Yêu cầu đặc biệt của khách hàng hoặc nhắc nhở thêm...">${appt.notes}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-card-footer">
                        <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-secondary">
                            Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <span>📅</span> Xác Nhận Đặt Lịch
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script>
    var searchInput = document.getElementById('patientSearch');
    var resultsBox = document.getElementById('searchResults');
    var patientIdInput = document.getElementById('patientId');
    var badgeBox = document.getElementById('selectedPatientBadge');
    var badgeName = document.getElementById('selectedPatientName');
    var badgePhone = document.getElementById('selectedPatientPhone');

    var debounceTimer;
    searchInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        var q = this.value.trim();
        if (q.length < 2) {
            resultsBox.style.display = 'none';
            return;
        }

        debounceTimer = setTimeout(function() {
            fetch('${pageContext.request.contextPath}/reception/patients/search-ajax?term=' + encodeURIComponent(q))
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    resultsBox.innerHTML = '';
                    if (!data || data.length === 0) {
                        resultsBox.innerHTML = '<div class="search-result-row" style="color:var(--text-muted); cursor:default;">Không tìm thấy bệnh nhân. Hãy tạo mới hồ sơ trước.</div>';
                    } else {
                        data.forEach(function(p) {
                            var item = document.createElement('div');
                            item.className = 'search-result-row';
                            item.innerHTML = '<div><strong>' + p.fullName + '</strong> <span style="color:var(--text-muted); font-size:12px;">(' + (p.gender || '') + ')</span></div>' +
                                             '<div style="color:var(--primary); font-family:monospace; font-weight:600;">' + p.phone + (p.citizenId ? ' &bull; CCCD: ' + p.citizenId : '') + '</div>';
                            item.addEventListener('click', function() {
                                patientIdInput.value = p.patientId;
                                searchInput.value = p.fullName;
                                badgeName.innerText = p.fullName;
                                badgePhone.innerText = p.phone;
                                badgeBox.style.display = 'inline-flex';
                                resultsBox.style.display = 'none';
                            });
                            resultsBox.appendChild(item);
                        });
                    }
                    resultsBox.style.display = 'block';
                })
                .catch(function(err) {
                    console.error('Error fetching search results:', err);
                });
        }, 250);
    });

    document.addEventListener('click', function(e) {
        if (!searchInput.contains(e.target) && !resultsBox.contains(e.target)) {
            resultsBox.style.display = 'none';
        }
    });

    // Auto calculate EndTime = StartTime + 30m if empty
    document.getElementById('startTime').addEventListener('change', function() {
        var start = this.value;
        if (start && !document.getElementById('endTime').value) {
            var parts = start.split(':');
            var h = parseInt(parts[0]);
            var m = parseInt(parts[1]) + 30;
            if (m >= 60) {
                h += 1;
                m -= 60;
            }
            var hStr = (h < 10 ? '0' : '') + h;
            var mStr = (m < 10 ? '0' : '') + m;
            document.getElementById('endTime').value = hStr + ':' + mStr;
        }
    });
</script>

</body>
</html>

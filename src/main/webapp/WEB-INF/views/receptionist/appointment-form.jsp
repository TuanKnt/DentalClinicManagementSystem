<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="appointments" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Hẹn Khám Bệnh Mới — Dr.Smile DCMS Dental Care</title>
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
                    <span class="alert-banner-icon">!</span>
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
                                        Tạo Hồ Sơ Mới
                                    </a>
                                </div>
                                <div id="searchResults" class="search-results-floating"></div>

                                <div id="selectedPatientBadge" class="selected-patient-chip" style="${selectedPatient != null ? '' : 'display:none;'}">
                                    <span>Đã chọn: <strong id="selectedPatientName">${selectedPatient.fullName}</strong> — SĐT: <strong id="selectedPatientPhone">${selectedPatient.phone}</strong></span>
                                </div>
                            </div>

                            <!-- Doctor Selection -->
                            <!-- Doctor Selection -->
                            <div class="form-group form-group-full">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                                    <label for="dentistId" class="form-label required" style="margin-bottom:0;">Bác Sĩ Điều Trị</label>
                                    <a href="${pageContext.request.contextPath}/reception/schedules" target="_blank" style="font-size: 12px; color: var(--drsmile-blue); font-weight: 600; text-decoration: none;">
                                        Xem lịch trực bác sĩ &rarr;
                                    </a>
                                </div>
                                <select id="dentistId" name="dentistId" class="form-control" required>
                                    <option value="">-- Chọn bác sĩ phụ trách --</option>
                                    <c:forEach var="d" items="${dentists}">
                                        <option value="${d.dentistId}" ${appt.dentistId == d.dentistId ? 'selected' : ''}>
                                            ${d.fullName} — ${d.specialization} (${d.roomNumber != null ? d.roomNumber : 'Ghế khám'})
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

                            <!-- Fixed Time Slot (Like Guest Booking) -->
                            <div class="form-group">
                                <label for="timeSlot" class="form-label required">Khung Giờ Khám (Ca Slot Cố Định)</label>
                                <small style="display:block; color:var(--text-muted); font-size:11.5px; margin-bottom:4px;">Mỗi ca 30 phút · 08:00 – 18:30</small>
                                <select id="timeSlot" name="timeSlot" class="form-control" required onchange="handleSlotChange(this.value)">
                                    <option value="">-- Chọn ca khám 30 phút --</option>
                                    <optgroup label="Buổi sáng">
                                        <option value="08:00-08:30">08:00 – 08:30</option>
                                        <option value="08:30-09:00">08:30 – 09:00</option>
                                        <option value="09:00-09:30">09:00 – 09:30</option>
                                        <option value="09:30-10:00">09:30 – 10:00</option>
                                        <option value="10:00-10:30">10:00 – 10:30</option>
                                        <option value="10:30-11:00">10:30 – 11:00</option>
                                        <option value="11:00-11:30">11:00 – 11:30</option>
                                        <option value="11:30-12:00">11:30 – 12:00</option>
                                    </optgroup>
                                    <optgroup label="Buổi chiều">
                                        <option value="12:00-12:30">12:00 – 12:30</option>
                                        <option value="12:30-13:00">12:30 – 13:00</option>
                                        <option value="13:00-13:30">13:00 – 13:30</option>
                                        <option value="13:30-14:00">13:30 – 14:00</option>
                                        <option value="14:00-14:30">14:00 – 14:30</option>
                                        <option value="14:30-15:00">14:30 – 15:00</option>
                                        <option value="15:00-15:30">15:00 – 15:30</option>
                                        <option value="15:30-16:00">15:30 – 16:00</option>
                                        <option value="16:00-16:30">16:00 – 16:30</option>
                                        <option value="16:30-17:00">16:30 – 17:00</option>
                                        <option value="17:00-17:30">17:00 – 17:30</option>
                                        <option value="17:30-18:00">17:30 – 18:00</option>
                                        <option value="18:00-18:30">18:00 – 18:30</option>
                                    </optgroup>
                                </select>

                                <!-- Hidden or synced Start and End Time inputs -->
                                <input type="hidden" id="startTime" name="startTime" value="${appt.startTime}" />
                                <input type="hidden" id="endTime" name="endTime" value="${appt.endTime}" />

                                <div style="margin-top: 6px;">
                                    <button type="button" class="btn btn-secondary btn-sm" id="btnToggleManual" style="font-size:11px; padding:2px 8px;" onclick="toggleManualTime()">
                                        Tùy chỉnh giờ tự do...
                                    </button>
                                </div>
                            </div>

                            <!-- Optional Manual Time inputs if customized -->
                            <div id="manualTimeRow" class="form-group form-group-full" style="display:none; background:#f8fafc; padding:12px; border-radius:8px; border:1px dashed #cbd5e1;">
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                    <div>
                                        <label for="manualStart" class="form-label" style="font-size:12px;">Giờ bắt đầu tùy chỉnh</label>
                                        <input type="time" id="manualStart" class="form-control" onchange="syncManualStart(this.value)" />
                                    </div>
                                    <div>
                                        <label for="manualEnd" class="form-label" style="font-size:12px;">Giờ kết thúc tùy chỉnh</label>
                                        <input type="time" id="manualEnd" class="form-control" onchange="syncManualEnd(this.value)" />
                                    </div>
                                </div>
                                <small style="color:var(--text-muted); font-size:11px; margin-top:4px; display:block;">
                                    Lưu ý: Bác sĩ phải có ca trực bao gồm toàn bộ khoảng thời gian tùy chỉnh này.
                                </small>
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
                            Xác Nhận Đặt Lịch
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

    function handleSlotChange(slot) {
        if (!slot) return;
        var parts = slot.split('-');
        if (parts.length === 2) {
            document.getElementById('startTime').value = parts[0].trim();
            document.getElementById('endTime').value = parts[1].trim();
            document.getElementById('manualStart').value = parts[0].trim();
            document.getElementById('manualEnd').value = parts[1].trim();
        }
    }

    function toggleManualTime() {
        var row = document.getElementById('manualTimeRow');
        var btn = document.getElementById('btnToggleManual');
        if (row.style.display === 'none' || row.style.display === '') {
            row.style.display = 'block';
            btn.innerText = 'Đóng tùy chỉnh giờ';
            var s = document.getElementById('startTime').value;
            var e = document.getElementById('endTime').value;
            if (s) document.getElementById('manualStart').value = s;
            if (e) document.getElementById('manualEnd').value = e;
        } else {
            row.style.display = 'none';
            btn.innerText = 'Tùy chỉnh giờ tự do...';
        }
    }

    function syncManualStart(val) {
        document.getElementById('startTime').value = val;
        // clear selected slot if manual custom
        document.getElementById('timeSlot').value = '';
    }

    function syncManualEnd(val) {
        document.getElementById('endTime').value = val;
        // clear selected slot if manual custom
        document.getElementById('timeSlot').value = '';
    }

    // Auto-select slot if appt.startTime and endTime exist
    window.addEventListener('DOMContentLoaded', function() {
        var s = document.getElementById('startTime').value;
        var e = document.getElementById('endTime').value;
        if (s && e) {
            var candidate = s.substring(0, 5) + '-' + e.substring(0, 5);
            var select = document.getElementById('timeSlot');
            for (var i = 0; i < select.options.length; i++) {
                if (select.options[i].value === candidate) {
                    select.selectedIndex = i;
                    return;
                }
            }
            // If custom slot not in list, open manual row
            toggleManualTime();
        }
    });
</script>

</body>
</html>

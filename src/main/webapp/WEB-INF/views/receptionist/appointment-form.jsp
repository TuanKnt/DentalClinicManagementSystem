<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Hẹn Mới — DCMS</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --alert-red: #ef4444;
            --alert-bg: #fee2e2;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        body { background-color: var(--bg); color: var(--text-main); min-height: 100vh; }
        
        .navbar { background: #ffffff; border-bottom: 1px solid var(--border); padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { font-size: 18px; font-weight: 700; color: var(--primary); text-decoration: none; }
        
        .container { max-width: 760px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; border-radius: 16px; border: 1px solid var(--border); padding: 36px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }

        .header { margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border); }
        .header h1 { font-size: 20px; font-weight: 700; }
        .header p { font-size: 13px; color: var(--text-muted); margin-top: 4px; }

        .form-group { margin-bottom: 18px; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; }
        .required { color: var(--alert-red); }

        input[type="text"], input[type="date"], input[type="time"], select, textarea {
            width: 100%; padding: 10px 14px; border-radius: 8px; border: 1px solid var(--border); font-size: 14px; outline: none; background: #f8fafc;
        }
        input:focus, select:focus, textarea:focus {
            border-color: var(--primary); background: white; box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
        }

        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        .alert-box { padding: 12px 16px; border-radius: 8px; font-size: 13px; margin-bottom: 20px; background: var(--alert-bg); border: 1px solid #fecaca; color: #b91c1c; }

        .patient-search-box { position: relative; }
        .search-results { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid var(--border); border-radius: 8px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); max-height: 200px; overflow-y: auto; z-index: 10; display: none; }
        .search-item { padding: 10px 14px; border-bottom: 1px solid var(--border); cursor: pointer; font-size: 13px; }
        .search-item:hover { background-color: #f1f5f9; }

        .selected-badge { display: inline-flex; align-items: center; gap: 8px; background: #e0f2fe; color: #0369a1; padding: 6px 12px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-top: 8px; }

        .btn-group { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }
        .btn { padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
        .btn-primary { background: var(--primary); color: white; border: none; }
        .btn-primary:hover { background: var(--primary-hover); }
        .btn-secondary { background: white; border-color: var(--border); color: var(--text-main); }
        .btn-secondary:hover { background: #f1f5f9; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/reception/appointments" class="nav-brand">🦷 DCMS Clinic</a>
</nav>

<div class="container">
    <div class="card">
        <div class="header">
            <h1>Đặt Lịch Hẹn Khám Bệnh Mới</h1>
            <p>Hệ thống tự động kiểm tra ca trực của Bác sĩ và chặn trùng giờ khám (BF-01)</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-box">
                ⚠️ ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reception/appointments/create" method="POST">
            <!-- Hidden Patient ID -->
            <input type="hidden" id="patientId" name="patientId" value="${selectedPatient != null ? selectedPatient.patientId : appt.patientId}" required />

            <div class="form-group patient-search-box">
                <label for="patientSearch">Chọn Bệnh Nhân <span class="required">*</span></label>
                <input type="text" id="patientSearch" placeholder="Gõ số điện thoại hoặc tên bệnh nhân để tìm kiếm..." autocomplete="off" 
                       value="${selectedPatient != null ? selectedPatient.fullName : ''}" />
                <div id="searchResults" class="search-results"></div>

                <div id="selectedPatientBadge" class="selected-badge" style="${selectedPatient != null ? '' : 'display:none;'}">
                    <span>👤 <span id="selectedPatientName">${selectedPatient.fullName}</span> (<span id="selectedPatientPhone">${selectedPatient.phone}</span>)</span>
                </div>
            </div>

            <div class="form-group">
                <label for="dentistId">Bác Sĩ Điều Trị <span class="required">*</span></label>
                <select id="dentistId" name="dentistId" required>
                    <option value="">-- Chọn bác sĩ phụ trách --</option>
                    <c:forEach var="d" items="${dentists}">
                        <option value="${d.dentistId}" ${appt.dentistId == d.dentistId ? 'selected' : ''}>
                            ${d.fullName} — ${d.specialization} (${d.roomNumber != null ? d.roomNumber : 'Ghế khám'})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="appointmentDate">Ngày Hẹn <span class="required">*</span></label>
                    <input type="date" id="appointmentDate" name="appointmentDate" value="${appt.appointmentDate}" required />
                </div>
                <div></div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="startTime">Giờ Bắt Đầu <span class="required">*</span></label>
                    <input type="time" id="startTime" name="startTime" value="${appt.startTime}" required />
                </div>
                <div class="form-group">
                    <label for="endTime">Giờ Kết Thúc Dự Kiến <span class="required">*</span></label>
                    <input type="time" id="endTime" name="endTime" value="${appt.endTime}" required />
                </div>
            </div>

            <div class="form-group">
                <label for="reason">Lý Do Đến Khám</label>
                <input type="text" id="reason" name="reason" value="${appt.reason}" placeholder="Ví dụ: Đau răng hàm dưới, trám răng sâu, tư vấn chỉnh nha..." />
            </div>

            <div class="form-group">
                <label for="notes">Ghi Chú Thêm</label>
                <textarea id="notes" name="notes" rows="2" placeholder="Ghi chú thêm về yêu cầu đặc biệt của khách hàng...">${appt.notes}</textarea>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-secondary">Quay Lại</a>
                <button type="submit" class="btn btn-primary">Xác Nhận Đặt Lịch</button>
            </div>
        </form>
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
            fetch('${pageContext.request.contextPath}/reception/patients/search-ajax?q=' + encodeURIComponent(q))
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    resultsBox.innerHTML = '';
                    if (data.length === 0) {
                        resultsBox.innerHTML = '<div class="search-item" style="color:#64748b;">Không tìm thấy bệnh nhân. Hãy tạo mới hồ sơ trước.</div>';
                    } else {
                        data.forEach(function(p) {
                            var item = document.createElement('div');
                            item.className = 'search-item';
                            item.innerHTML = '<strong>' + p.fullName + '</strong> - SĐT: ' + p.phone + (p.citizenId ? ' (CCCD: ' + p.citizenId + ')' : '');
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
                });
        }, 300);
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

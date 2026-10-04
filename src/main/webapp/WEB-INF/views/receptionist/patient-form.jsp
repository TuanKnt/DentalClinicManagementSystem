<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh Sửa' : 'Thêm Mới'} Hồ Sơ Bệnh Nhân — DCMS</title>
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
        
        .container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; border-radius: 16px; border: 1px solid var(--border); padding: 36px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }

        .header { margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border); }
        .header h1 { font-size: 20px; font-weight: 700; }
        .header p { font-size: 13px; color: var(--text-muted); margin-top: 4px; }

        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; }
        .required { color: var(--alert-red); }

        input[type="text"], input[type="date"], select, textarea {
            width: 100%; padding: 10px 14px; border-radius: 8px; border: 1px solid var(--border); font-size: 14px; outline: none; background: #f8fafc;
        }
        input:focus, select:focus, textarea:focus {
            border-color: var(--primary); background: white; box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
        }

        .alert-box { padding: 12px 16px; border-radius: 8px; font-size: 13px; margin-bottom: 20px; background: var(--alert-bg); border: 1px solid #fecaca; color: #b91c1c; }

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
    <a href="${pageContext.request.contextPath}/reception/patients" class="nav-brand">🦷 DCMS Clinic</a>
</nav>

<div class="container">
    <div class="card">
        <div class="header">
            <h1>${isEdit ? 'Chỉnh Sửa Hồ Sơ Bệnh Nhân' : 'Tạo Hồ Sơ Bệnh Nhân Mới'}</h1>
            <p>Nhập thông tin hành chính, tiền sử dị ứng và bệnh lý theo chuẩn quy định BF-01</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-box">
                ⚠️ ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reception/patients${isEdit ? '/edit' : '/create'}" method="POST">
            <c:if test="${isEdit}">
                <input type="hidden" name="patientId" value="${patient.patientId}" />
            </c:if>

            <div class="grid-2">
                <div class="form-group">
                    <label for="fullName">Họ & Tên <span class="required">*</span></label>
                    <input type="text" id="fullName" name="fullName" value="${patient.fullName}" placeholder="Ví dụ: Nguyễn Văn An" required />
                </div>
                <div class="form-group">
                    <label for="phone">Số Điện Thoại (10 số) <span class="required">*</span></label>
                    <input type="text" id="phone" name="phone" value="${patient.phone}" placeholder="Ví dụ: 0988123456" required />
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="gender">Giới Tính <span class="required">*</span></label>
                    <select id="gender" name="gender" required>
                        <option value="Nam" ${patient.gender eq 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${patient.gender eq 'Nữ' ? 'selected' : ''}>Nữ</option>
                        <option value="Khác" ${patient.gender eq 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="dob">Ngày Tháng Năm Sinh</label>
                    <input type="date" id="dob" name="dob" value="${patient.dob}" />
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="citizenId">Số CCCD / Hộ Chiếu</label>
                    <input type="text" id="citizenId" name="citizenId" value="${patient.citizenId}" placeholder="001099..." />
                </div>
                <div class="form-group">
                    <label for="emergencyContact">Người Liên Hệ Khẩn Cấp</label>
                    <input type="text" id="emergencyContact" name="emergencyContact" value="${patient.emergencyContact}" placeholder="Tên và SĐT người thân" />
                </div>
            </div>

            <div class="form-group">
                <label for="address">Địa Chỉ Thường Trú</label>
                <input type="text" id="address" name="address" value="${patient.address}" placeholder="Số nhà, tên đường, quận/huyện, tỉnh thành" />
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="medicalAlerts" style="color: #b91c1c;">⚠️ Cảnh Báo Bệnh Lý Nền (Nếu có)</label>
                    <textarea id="medicalAlerts" name="medicalAlerts" rows="2" placeholder="Ví dụ: Cao huyết áp, tiểu đường, máu khó đông, tim mạch...">${patient.medicalAlerts}</textarea>
                </div>
                <div class="form-group">
                    <label for="allergies" style="color: #b91c1c;">⚡ Tiền Sử Dị Ứng Thuốc (Nếu có)</label>
                    <textarea id="allergies" name="allergies" rows="2" placeholder="Ví dụ: Dị ứng thuốc tê Lidocaine, Penicillin, Paracetamol...">${patient.allergies}</textarea>
                </div>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/reception/patients" class="btn btn-secondary">Hủy Bỏ</a>
                <button type="submit" class="btn btn-primary">Lưu Hồ Sơ</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>

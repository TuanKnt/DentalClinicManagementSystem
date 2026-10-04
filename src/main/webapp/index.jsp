<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dental Clinic Management System (DCMS) — Cổng Quản Lý Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .portal-navbar {
            height: 70px;
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
        }

        .portal-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .portal-hero {
            text-align: center;
            padding: 60px 24px 40px;
            max-width: 800px;
            margin: 0 auto;
        }

        .portal-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            border-radius: var(--radius-full);
            background: var(--success-light);
            border: 1px solid var(--success-border);
            color: var(--success);
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .portal-hero h1 {
            font-size: 36px;
            font-weight: 800;
            color: var(--text-primary);
            letter-spacing: -0.8px;
            line-height: 1.2;
            margin-bottom: 16px;
        }

        .portal-hero h1 span {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .portal-hero p {
            font-size: 16px;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .portal-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            max-width: 1100px;
            margin: 0 auto 60px;
            padding: 0 24px;
        }

        .portal-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 28px;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }

        .portal-card:hover {
            transform: translateY(-4px);
            border-color: #cbd5e1;
            box-shadow: var(--shadow-lg);
        }

        .portal-card-icon {
            width: 52px;
            height: 52px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .portal-card h3 {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 8px;
            letter-spacing: -0.3px;
        }

        .portal-card p {
            font-size: 13.5px;
            color: var(--text-secondary);
            line-height: 1.5;
            margin-bottom: 20px;
        }

        .portal-card-footer {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 700;
            color: var(--primary);
        }

        .portal-footer {
            text-align: center;
            padding: 32px 24px;
            border-top: 1px solid var(--border);
            background: #ffffff;
            font-size: 13px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="portal-navbar">
    <a href="${pageContext.request.contextPath}/" class="portal-brand">
        <div class="brand-icon">🦷</div>
        <div>
            <div style="font-size: 16px; font-weight: 800; color: var(--text-primary);">DCMS Dental System</div>
            <div style="font-size: 11px; font-weight: 600; color: var(--primary); text-transform: uppercase;">Phòng Khám Nha Khoa Thông Minh</div>
        </div>
    </a>

    <div style="display:flex; align-items:center; gap:16px;">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <span style="font-size: 13.5px; font-weight: 600; color: var(--text-secondary);">
                    Xin chào, <strong>${sessionScope.currentUser.fullName}</strong> (${sessionScope.role})
                </span>
                <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-primary btn-sm">
                    Vào Bàn Làm Việc
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm">
                    Đăng Xuất
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                    <span>🔐</span> Đăng Nhập Hệ Thống
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Hero Section -->
<div class="portal-hero">
    <div class="portal-badge">
        <span class="pulse-dot"></span>
        <span>Hệ Thống Đang Trực Tuyến &bull; Iteration 1 Sẵn Sàng</span>
    </div>
    <h1>Nền Tảng Quản Lý <span>Phòng Khám Nha Khoa</span> Chuẩn Y Khoa</h1>
    <p>Kiến trúc Java Servlet MVC tách bạch luồng nghiệp vụ: Lịch hẹn không đồng nhất Lượt khám thực tế, hồ sơ bệnh nhân chuẩn hóa theo tiêu chuẩn FDI & quản lý an toàn y tế.</p>
</div>

<!-- Quick Module Cards -->
<div class="portal-grid">
    <!-- Card 1: Receptionist / Appointments -->
    <a href="${pageContext.request.contextPath}/reception/appointments" class="portal-card">
        <div>
            <div class="portal-card-icon" style="background: #e0f2fe; color: #0284c7;">📅</div>
            <h3>Quản Lý Lịch Hẹn</h3>
            <p>Điều phối khung giờ khám của bệnh nhân, tự động kiểm tra ca trực bác sĩ và chống trùng lặp giờ khám tuyệt đối.</p>
        </div>
        <div class="portal-card-footer">
            <span>Truy cập Lịch Hẹn</span>
            <span>→</span>
        </div>
    </a>

    <!-- Card 2: Check-in / Reception -->
    <a href="${pageContext.request.contextPath}/reception/checkin" class="portal-card">
        <div>
            <div class="portal-card-icon" style="background: #dcfce7; color: #15803d;">🚪</div>
            <h3>Tiếp Đón & Check-in</h3>
            <p>Biến Lịch hẹn thành Lượt khám thực tế khi bệnh nhân có mặt tại quầy, tiếp nhận khách vãng lai và đưa vào hàng đợi ghế.</p>
        </div>
        <div class="portal-card-footer">
            <span>Vào Bàn Tiếp Đón</span>
            <span>→</span>
        </div>
    </a>

    <!-- Card 3: Patient Records -->
    <a href="${pageContext.request.contextPath}/reception/patients" class="portal-card">
        <div>
            <div class="portal-card-icon" style="background: #fef3c7; color: #b45309;">👥</div>
            <h3>Hồ Sơ Bệnh Nhân</h3>
            <p>Tra cứu nhanh qua SĐT/CCCD, lưu trữ tiền sử dị ứng thuốc và cảnh báo bệnh lý nền để bác sĩ xử trí an toàn.</p>
        </div>
        <div class="portal-card-footer">
            <span>Tra Cứu Hồ Sơ</span>
            <span>→</span>
        </div>
    </a>

    <!-- Card 4: Clinical Dentist Queue -->
    <a href="${pageContext.request.contextPath}/dentist/queue" class="portal-card">
        <div>
            <div class="portal-card-icon" style="background: #f3e8ff; color: #7e22ce;">🩺</div>
            <h3>Khu Khám Lâm Sàng</h3>
            <p>Hàng đợi thời gian thực tại ghế nha khoa, hỗ trợ bác sĩ mời bệnh nhân vào khám và kích hoạt phiên khám lâm sàng.</p>
        </div>
        <div class="portal-card-footer">
            <span>Hàng Đợi Ghế Khám</span>
            <span>→</span>
        </div>
    </a>
</div>

<!-- Footer -->
<footer class="portal-footer">
    <div><strong>Dental Clinic Management System (DCMS)</strong> &bull; Đồ Án SWP Nhóm G3_SE2064</div>
    <div style="margin-top: 6px; font-size: 12px; color: #94a3b8;">Mô hình phân tầng MVC thuần JDBC + Microsoft SQL Server &bull; Tuân thủ 10 Nguyên tắc Thép Baseline v2.0</div>
</footer>

</body>
</html>

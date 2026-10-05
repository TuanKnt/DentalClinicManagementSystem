<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.dcms.dao.DentistDAO" %>
<%@ page import="com.dcms.model.Dentist" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%
    List<Dentist> dentistList = null;
    try {
        DentistDAO dentistDAO = new DentistDAO();
        dentistList = dentistDAO.listAllDentists();
    } catch (Exception ignored) {}
    request.setAttribute("dentistList", dentistList);
    request.setAttribute("todayStr", LocalDate.now().toString());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nha khoa Dr.Smile — Cổng Thông Tin & Quản Trị DCMS</title>
    <meta name="description" content="Nha khoa Dr.Smile chuyên gia răng sứ thẩm mỹ, niềng răng, implant và điều trị nha khoa kỹ thuật cao với hơn 17 năm kinh nghiệm.">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/Logo-PS.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        :root {
            --portal-navy: #003366;
            --portal-navy-dark: #001d3d;
            --portal-blue: #0052cc;
            --portal-cyan: #00a8cc;
            --portal-cyan-light: #e0f7fa;
            --portal-gold: #d4af37;
        }

        body {
            background-color: #f4f8fc;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: #1e293b;
        }

        /* Top bar liên hệ */
        .portal-topbar {
            background: var(--portal-navy-dark);
            color: #94a3b8;
            font-size: 13px;
            padding: 8px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .portal-topbar-left, .portal-topbar-right {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }

        .portal-topbar-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .portal-topbar-item a {
            color: #38bdf8;
            text-decoration: none;
            font-weight: 600;
        }

        .portal-topbar-item a:hover {
            text-decoration: underline;
        }

        /* Header chính */
        .portal-header {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 14px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(0, 51, 102, 0.05);
        }

        .portal-brand {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
        }

        .portal-brand img {
            height: 48px;
            object-fit: contain;
        }

        .portal-brand-text {
            display: flex;
            flex-direction: column;
        }

        .portal-brand-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--portal-navy);
            letter-spacing: -0.3px;
            line-height: 1.2;
        }

        .portal-brand-sub {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .portal-header-actions {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .btn-portal-hotline {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: var(--radius-full);
            color: var(--portal-navy);
            font-size: 13.5px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-portal-hotline:hover {
            background: #dbeafe;
            border-color: #93c5fd;
            transform: translateY(-1px);
        }

        .btn-portal-login {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 9px 20px;
            background: linear-gradient(135deg, var(--portal-navy) 0%, var(--portal-blue) 100%);
            border-radius: var(--radius-full);
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 700;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
            transition: all 0.2s ease;
        }

        .btn-portal-login:hover {
            box-shadow: 0 6px 18px rgba(0, 51, 102, 0.3);
            transform: translateY(-1px);
        }

        /* Khung hiển thị trung tâm */
        .portal-main {
            flex: 1;
            max-width: 1240px;
            width: 100%;
            margin: 0 auto;
            padding: 32px 24px 48px;
            display: flex;
            flex-direction: column;
            gap: 36px;
        }

        /* Hero Showcase: 2 Cột cân bằng */
        .portal-hero-showcase {
            display: grid;
            grid-template-columns: 1.15fr 1fr;
            gap: 32px;
            align-items: stretch;
            background: linear-gradient(135deg, #ffffff 0%, #f0f7fd 100%);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 36px 40px;
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .portal-hero-showcase::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--portal-navy) 0%, var(--portal-cyan) 60%, var(--portal-gold) 100%);
        }

        .hero-info-col {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .hero-badge-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            border-radius: var(--radius-full);
            background: rgba(0, 168, 204, 0.12);
            border: 1px solid rgba(0, 168, 204, 0.25);
            color: #0369a1;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 18px;
            width: fit-content;
        }

        .hero-main-title {
            font-size: 32px;
            font-weight: 800;
            color: var(--portal-navy);
            line-height: 1.25;
            margin-bottom: 12px;
            letter-spacing: -0.6px;
        }

        .hero-main-title span {
            background: linear-gradient(135deg, #0052cc 0%, #00a8cc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-motto-quote {
            font-size: 14.5px;
            font-weight: 600;
            color: #475569;
            font-style: italic;
            border-left: 3px solid var(--portal-gold);
            padding-left: 14px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        /* 4 Trụ cột cam kết nhỏ gọn */
        .hero-trust-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 24px;
        }

        .trust-chip {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 12.5px;
            font-weight: 600;
            color: #334155;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }

        .trust-chip strong {
            color: var(--portal-navy);
        }

        /* Thẻ đặt lịch khám nhanh bên phải */
        .hero-booking-card {
            background: #ffffff;
            border: 1px solid #dce6f0;
            border-radius: var(--radius-lg);
            padding: 26px 28px;
            box-shadow: 0 8px 24px rgba(0, 51, 102, 0.08);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .booking-card-header {
            margin-bottom: 18px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .booking-card-header h3 {
            font-size: 18px;
            font-weight: 800;
            color: var(--portal-navy);
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 4px 0;
        }

        .booking-card-header p {
            font-size: 12.5px;
            color: var(--text-muted);
            margin: 0;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }

        .booking-input-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .booking-input-group label {
            font-size: 12px;
            font-weight: 700;
            color: #334155;
        }

        .booking-input-group .form-control {
            padding: 9px 12px;
            font-size: 13px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            transition: all 0.2s ease;
        }

        .booking-input-group .form-control:focus {
            background: #ffffff;
            border-color: var(--portal-blue);
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 82, 204, 0.12);
        }

        .btn-submit-booking {
            background: linear-gradient(135deg, #0052cc 0%, #00a8cc 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(0, 82, 204, 0.25);
            transition: all 0.2s ease;
            margin-top: 6px;
        }

        .btn-submit-booking:hover {
            box-shadow: 0 6px 18px rgba(0, 82, 204, 0.35);
            transform: translateY(-1px);
        }

        /* Thẻ Cổng Tác Nghiệp Nội Bộ (3 Thẻ ngang hàng) */
        .portal-roles-section {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .roles-section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding-bottom: 8px;
            border-bottom: 2px solid #e2e8f0;
        }

        .roles-section-header h2 {
            font-size: 20px;
            font-weight: 800;
            color: var(--portal-navy);
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .roles-section-header p {
            font-size: 13px;
            color: var(--text-secondary);
            margin: 0;
        }

        .portal-roles-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .role-portal-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
        }

        .role-portal-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--card-accent, var(--portal-navy));
            opacity: 0.8;
            transition: height 0.2s ease;
        }

        .role-portal-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -4px rgba(0, 51, 102, 0.12);
            border-color: #cbd5e1;
        }

        .role-portal-card:hover::before {
            height: 6px;
        }

        .role-card-top {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 16px;
        }

        .role-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--icon-bg, #eff6ff);
            color: var(--icon-color, var(--portal-navy));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .role-card-title h3 {
            font-size: 17px;
            font-weight: 800;
            color: var(--portal-navy);
            margin: 0 0 4px 0;
        }

        .role-card-title span {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
        }

        .role-card-desc {
            font-size: 13px;
            color: #475569;
            line-height: 1.55;
            margin-bottom: 20px;
        }

        .role-card-features {
            list-style: none;
            padding: 0;
            margin: 0 0 20px 0;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .role-card-features li {
            font-size: 12.5px;
            color: #334155;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .role-card-features li::before {
            content: '✓';
            color: #059669;
            font-weight: 800;
            font-size: 11px;
        }

        .btn-role-action {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 16px;
            border-radius: 8px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            font-size: 13px;
            font-weight: 700;
            color: var(--portal-navy);
            transition: all 0.2s ease;
        }

        .role-portal-card:hover .btn-role-action {
            background: var(--portal-navy);
            color: #ffffff;
            border-color: var(--portal-navy);
        }

        /* Footer Tinh Gọn */
        .portal-footer {
            background: var(--portal-navy-dark);
            color: #94a3b8;
            font-size: 13px;
            padding: 28px 36px 20px;
            margin-top: auto;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .footer-inner {
            max-width: 1240px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            padding-bottom: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .footer-bottom {
            max-width: 1240px;
            margin: 12px auto 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #64748b;
        }

        /* Floating Hotline Widget */
        .floating-call-widget {
            position: fixed;
            bottom: 28px;
            right: 28px;
            z-index: 999;
            display: flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
            padding: 10px 18px;
            border-radius: var(--radius-full);
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
            box-shadow: 0 8px 24px rgba(5, 150, 105, 0.35);
            transition: transform 0.2s ease;
        }

        .floating-call-widget:hover {
            transform: scale(1.05);
        }

        /* Modal xác nhận đặt lịch */
        .booking-modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 29, 61, 0.65);
            backdrop-filter: blur(4px);
            z-index: 10000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .booking-modal-content {
            background: #ffffff;
            border-radius: 16px;
            padding: 32px;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            text-align: center;
            animation: modalPop 0.25s ease-out;
        }

        @keyframes modalPop {
            0% { transform: scale(0.92); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        /* Responsive */
        @media (max-width: 992px) {
            .portal-hero-showcase {
                grid-template-columns: 1fr;
            }
            .portal-roles-grid {
                grid-template-columns: 1fr;
            }
            .portal-topbar {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- 1. TOPBAR LIÊN HỆ -->
    <div class="portal-topbar">
        <div class="portal-topbar-left">
            <div class="portal-topbar-item">
                <span>📍</span>
                <span>Cơ sở chính: <strong>Số 41, phố Núi Trúc, P. Giảng Võ, Ba Đình, Hà Nội</strong></span>
            </div>
            <div class="portal-topbar-item">
                <span>🕒</span>
                <span>Giờ làm việc: <strong>08:30 – 18:30</strong> (Tất cả các ngày trong tuần)</span>
            </div>
        </div>
        <div class="portal-topbar-right">
            <div class="portal-topbar-item">
                <span>✉️</span>
                <a href="mailto:drsmile.vn@gmail.com">drsmile.vn@gmail.com</a>
            </div>
            <div class="portal-topbar-item">
                <span>📞</span>
                <span>Hotline: <a href="tel:0966692286">096 669 2286</a></span>
            </div>
        </div>
    </div>

    <!-- 2. HEADER ĐÓN TIẾP & ĐIỀU HƯỚNG -->
    <header class="portal-header">
        <a href="${pageContext.request.contextPath}/" class="portal-brand">
            <img src="${pageContext.request.contextPath}/assets/images/Logo-PS.png" alt="Nha Khoa Dr.Smile">
            <div class="portal-brand-text">
                <span class="portal-brand-title">Nha Khoa Dr.Smile</span>
                <span class="portal-brand-sub">Dental Clinic Management System (DCMS)</span>
            </div>
        </a>

        <div class="portal-header-actions">
            <a href="tel:0966692286" class="btn-portal-hotline">
                <span>📞</span>
                <span>Hotline: 096 669 2286</span>
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn-portal-login">
                <span>🔐</span>
                <span>Cổng Tác Nghiệp &rarr;</span>
            </a>
        </div>
    </header>

    <!-- 3. KHU VỰC NỘI DUNG CHÍNH (TINH GỌN, KHÔNG SECTION CUỘN DÀI) -->
    <main class="portal-main">

        <!-- A. HERO SHOWCASE & ĐẶT LỊCH HẸN NHANH -->
        <div class="portal-hero-showcase">
            <!-- Cột trái: Thông điệp & Cam kết chất lượng Dr.Smile -->
            <div class="hero-info-col">
                <div class="hero-badge-chip">
                    <span>✨</span>
                    <span>Hệ Thống Nha Khoa Kỹ Thuật Số Chuẩn Y Khoa</span>
                </div>

                <h1 class="hero-main-title">
                    Nơi khởi nguồn cho<br>
                    <span>nụ cười rạng rỡ & tự tin</span>
                </h1>

                <div class="hero-motto-quote">
                    "Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"
                </div>

                <div class="hero-trust-chips">
                    <div class="trust-chip">
                        <span>👨‍⚕️</span>
                        <span>BS.CKI ĐH Y Hà Nội <strong>17+ Năm</strong></span>
                    </div>
                    <div class="trust-chip">
                        <span>🌟</span>
                        <span>Hơn <strong>10.000+</strong> Khách hàng</span>
                    </div>
                    <div class="trust-chip">
                        <span>🦷</span>
                        <span>Răng sứ & Implant <strong>Kỹ thuật số 4.0</strong></span>
                    </div>
                    <div class="trust-chip">
                        <span>🛡️</span>
                        <span>Vô trùng tuyệt đối <strong>Tiêu chuẩn Bộ Y Tế</strong></span>
                    </div>
                </div>

                <p style="font-size: 13.5px; color: #64748b; line-height: 1.6; margin: 0;">
                    Phục hình răng sứ thẩm mỹ, dán sứ Veneer, niềng răng trong suốt Invisalign, cấy ghép Implant và nhổ răng khôn không đau bằng sóng siêu âm Piezosurgical.
                </p>
            </div>

            <!-- Cột phải: Form đặt lịch khám trực tuyến nhanh cho Guest -->
            <div class="hero-booking-card">
                <div class="booking-card-header">
                    <h3><span>📅</span> Đặt Lịch Hẹn Khám Trực Tuyến</h3>
                    <p>Đăng ký lịch khám ưu tiên, miễn phí khám tổng quát & chụp phim</p>
                </div>

                <form id="quickBookingForm" onsubmit="handleQuickBooking(event)">
                    <div class="booking-form-grid">
                        <div class="booking-input-group">
                            <label>Họ và tên bệnh nhân *</label>
                            <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
                        </div>
                        <div class="booking-input-group">
                            <label>Số điện thoại *</label>
                            <input type="tel" name="phoneNumber" class="form-control" placeholder="09xxxxxxxx" pattern="[0-9]{10,11}" required>
                        </div>
                    </div>

                    <div class="booking-form-grid">
                        <div class="booking-input-group">
                            <label>Ngày hẹn khám *</label>
                            <input type="date" name="appointmentDate" class="form-control" value="${todayStr}" min="${todayStr}" required>
                        </div>
                        <div class="booking-input-group">
                            <label>Khung giờ dự kiến *</label>
                            <select name="timeSlot" class="form-control" required>
                                <option value="09:00">09:00 - 09:45 (Sáng)</option>
                                <option value="10:00" selected>10:00 - 10:45 (Sáng)</option>
                                <option value="11:00">11:00 - 11:45 (Trưa)</option>
                                <option value="14:00">14:00 - 14:45 (Chiều)</option>
                                <option value="15:30">15:30 - 16:15 (Chiều)</option>
                                <option value="17:00">17:00 - 17:45 (Tối)</option>
                            </select>
                        </div>
                    </div>

                    <div class="booking-form-grid">
                        <div class="booking-input-group">
                            <label>Chọn Bác sĩ phụ trách</label>
                            <select name="dentistId" class="form-control">
                                <option value="">-- Bác sĩ phù hợp nhất --</option>
                                <c:forEach var="d" items="${dentistList}">
                                    <option value="${d.dentistId}">${d.fullName} (${empty d.specialization ? 'Nha khoa tổng quát' : d.specialization})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="booking-input-group">
                            <label>Dịch vụ mong muốn</label>
                            <select name="reason" class="form-control">
                                <option value="Khám tổng quát & Lấy cao răng">Khám tổng quát & Lấy cao răng</option>
                                <option value="Tư vấn Răng sứ & Dán sứ Veneer">Tư vấn Răng sứ & Dán sứ Veneer</option>
                                <option value="Niềng răng thẩm mỹ Invisalign">Niềng răng thẩm mỹ Invisalign</option>
                                <option value="Trồng răng Implant kỹ thuật số">Trồng răng Implant kỹ thuật số</option>
                                <option value="Nhổ răng khôn sóng siêu âm">Nhổ răng khôn sóng siêu âm</option>
                                <option value="Tẩy trắng răng đèn Led">Tẩy trắng răng đèn Led</option>
                                <option value="Đau răng / Điều trị tủy">Đau răng / Điều trị tủy</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" id="btnSubmitBooking" class="btn-submit-booking">
                        <span>✨</span>
                        <span>Xác Nhận Đặt Lịch Khám Ngay</span>
                    </button>
                    <div id="bookingMsg" style="font-size: 12px; text-align: center; margin-top: 8px; min-height: 18px;"></div>
                </form>
            </div>
        </div>

        <!-- B. CỔNG TÁC NGHIỆP PHÂN HỆ NỘI BỘ (3 THẺ VAI TRÒ CHÍNH) -->
        <div class="portal-roles-section">
            <div class="roles-section-header">
                <div>
                    <h2><span>🏢</span> Cổng Tác Nghiệp Hệ Thống Nội Bộ DCMS</h2>
                    <p>Truy cập nhanh vào bàn làm việc phân quyền theo vị trí chuyên môn</p>
                </div>
                <a href="${pageContext.request.contextPath}/login" style="font-size: 13px; font-weight: 700; color: var(--portal-blue); text-decoration: none;">
                    Đăng nhập tài khoản &rarr;
                </a>
            </div>

            <div class="portal-roles-grid">
                <!-- Thẻ 1: Lễ Tân & Tiếp Đón -->
                <a href="${pageContext.request.contextPath}/reception/checkin" class="role-portal-card" style="--card-accent: #0284c7; --icon-bg: #e0f2fe; --icon-color: #0369a1;">
                    <div>
                        <div class="role-card-top">
                            <div class="role-card-icon">🚪</div>
                            <div class="role-card-title">
                                <h3>Quầy Tiếp Đón & Lịch Hẹn</h3>
                                <span>Phân Hệ Lễ Tân (Receptionist)</span>
                            </div>
                        </div>
                        <p class="role-card-desc">
                            Tiếp đón bệnh nhân đến quầy, thực hiện Check-in chuyển đổi Lịch hẹn thành Lượt khám thực tế tại ghế và tiếp nhận khách vãng lai cấp cứu.
                        </p>
                        <ul class="role-card-features">
                            <li>Lịch hẹn toàn viện & Calendar trực quan</li>
                            <li>Check-in hàng đợi ghế khám thời gian thực</li>
                            <li>Hồ sơ bệnh nhân 360° & Tiền sử dị ứng</li>
                            <li>Tiếp nhận vãng lai/cấp cứu không cần hẹn</li>
                        </ul>
                    </div>
                    <div class="btn-role-action">
                        <span>Vào Quầy Tiếp Đón</span>
                        <span>&rarr;</span>
                    </div>
                </a>

                <!-- Thẻ 2: Bàn Làm Việc Bác Sĩ -->
                <a href="${pageContext.request.contextPath}/dentist/dashboard" class="role-portal-card" style="--card-accent: #003366; --icon-bg: #e8f4fd; --icon-color: #003366;">
                    <div>
                        <div class="role-card-top">
                            <div class="role-card-icon">🩺</div>
                            <div class="role-card-title">
                                <h3>Bàn Làm Việc Bác Sĩ</h3>
                                <span>Khu Khám Lâm Sàng (Dentist Workbench)</span>
                            </div>
                        </div>
                        <p class="role-card-desc">
                            Theo dõi danh sách bệnh nhân chờ tại ghế, ghi chép chẩn đoán bệnh lý, tương tác trực quan trên Sơ đồ răng FDI và lưu kết quả sinh hiệu.
                        </p>
                        <ul class="role-card-features">
                            <li>Hàng đợi ghế khám công thái học</li>
                            <li>Sơ đồ răng SVG Odontogram 11-48 & 5 mặt răng</li>
                            <li>Đánh giá sinh hiệu & Đủ điều kiện thủ thuật</li>
                            <li>Lưu trữ phim chụp X-quang chẩn đoán</li>
                        </ul>
                    </div>
                    <div class="btn-role-action">
                        <span>Mở Bàn Bác Sĩ</span>
                        <span>&rarr;</span>
                    </div>
                </a>

                <!-- Thẻ 3: Quản Trị Hệ Thống -->
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="role-portal-card" style="--card-accent: #7c3aed; --icon-bg: #f3e8ff; --icon-color: #6d28d9;">
                    <div>
                        <div class="role-card-top">
                            <div class="role-card-icon">⚙️</div>
                            <div class="role-card-title">
                                <h3>Bảng Điều Khiển Quản Trị</h3>
                                <span>Hệ Thống Quản Lý (Admin & Manager)</span>
                            </div>
                        </div>
                        <p class="role-card-desc">
                            Giám sát toàn diện nhân sự phòng khám, quản lý danh mục bác sĩ nha khoa, theo dõi khối lượng khám chữa bệnh và sức khỏe máy chủ.
                        </p>
                        <ul class="role-card-features">
                            <li>Thống kê tổng quan hoạt động phòng khám</li>
                            <li>Danh mục đội ngũ Bác sĩ & Chuyên môn</li>
                            <li>Hồ sơ bệnh nhân mới đăng ký toàn hệ thống</li>
                            <li>Giám sát hạ tầng máy chủ Tomcat 10 / Jakarta EE</li>
                        </ul>
                    </div>
                    <div class="btn-role-action">
                        <span>Mở Trang Quản Trị</span>
                        <span>&rarr;</span>
                    </div>
                </a>
            </div>
        </div>

    </main>

    <!-- 4. FOOTER PHÁP LÝ & LIÊN HỆ TINH GỌN -->
    <footer class="portal-footer">
        <div class="footer-inner">
            <div>
                <strong style="color: #ffffff; font-size: 15px;">Nha Khoa Dr.Smile — Hệ Thống Quản Trị DCMS</strong>
                <p style="margin: 4px 0 0 0; font-size: 12.5px; color: #94a3b8;">
                    Cơ sở 1: Số 41, phố Núi Trúc, P. Giảng Võ, Ba Đình, Hà Nội &bull; Cơ sở 2: 124 Phố Huế, Hai Bà Trưng, Hà Nội
                </p>
            </div>
            <div style="display: flex; gap: 20px; align-items: center;">
                <span>Hotline: <strong style="color: #38bdf8;">096 669 2286</strong></span>
                <span>MST: <strong>0109138207</strong></span>
                <span>Giấy phép hoạt động BYT</span>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2026 Nha Khoa Dr.Smile DCMS — G3_SE2064 Dental Care Management. All rights reserved.</span>
            <span>Phiên bản v1.3.0 &bull; Tomcat 10.1.8 / Jakarta EE 10</span>
        </div>
    </footer>

    <!-- 5. FLOATING HOTLINE WIDGET -->
    <a href="tel:0966692286" class="floating-call-widget" title="Gọi Hotline 24/7">
        <span>📞</span>
        <span>096 669 2286</span>
    </a>

    <!-- 6. MODAL XÁC NHẬN ĐẶT LỊCH HẸN THÀNH CÔNG -->
    <div id="bookingSuccessModal" class="booking-modal-overlay">
        <div class="booking-modal-content">
            <div style="width: 64px; height: 64px; border-radius: 50%; background: #ecfdf5; color: #059669; font-size: 32px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                ✓
            </div>
            <h3 style="font-size: 20px; font-weight: 800; color: var(--portal-navy); margin-bottom: 8px;">
                Đặt Lịch Khám Thành Công!
            </h3>
            <p style="font-size: 13.5px; color: #475569; line-height: 1.5; margin-bottom: 20px;">
                Lịch hẹn của bạn đã được ghi nhận vào hệ thống phòng khám Dr.Smile. Quầy tiếp đón sẽ liên hệ xác nhận trong ít phút.
            </p>
            <div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 10px; padding: 14px; margin-bottom: 24px; text-align: left; font-size: 13px;">
                <div style="margin-bottom: 6px;">Mã lịch hẹn: <strong id="modalApptCode" style="color: #0369a1; font-size: 14px;">#APT-...</strong></div>
                <div style="margin-bottom: 6px;">Bệnh nhân: <strong id="modalPatientName">-</strong></div>
                <div style="margin-bottom: 6px;">Thời gian: <strong id="modalApptTime">-</strong></div>
                <div>Ghi chú: <span id="modalApptReason">Khám nha tổng quát</span></div>
            </div>
            <button onclick="closeBookingModal()" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 700;">
                Hoàn Tất & Đóng
            </button>
        </div>
    </div>

    <!-- SCRIPT XỬ LÝ AJAX ĐẶT LỊCH NHANH -->
    <script>
        function handleQuickBooking(e) {
            e.preventDefault();
            const form = document.getElementById('quickBookingForm');
            const submitBtn = document.getElementById('btnSubmitBooking');
            const msgEl = document.getElementById('bookingMsg');

            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span>⏳</span><span>Đang xử lý đặt lịch...</span>';
            msgEl.innerText = '';

            const formData = new FormData(form);
            const params = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                params.append(key, value);
            }

            fetch('${pageContext.request.contextPath}/booking', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<span>✨</span><span>Xác Nhận Đặt Lịch Khám Ngay</span>';
                
                if (data.success) {
                    document.getElementById('modalApptCode').innerText = '#APT-' + (data.appointmentId || 'SUCCESS');
                    document.getElementById('modalPatientName').innerText = form.fullName.value;
                    document.getElementById('modalApptTime').innerText = form.appointmentDate.value + ' lúc ' + form.timeSlot.value;
                    document.getElementById('modalApptReason').innerText = form.reason.value;
                    
                    document.getElementById('bookingSuccessModal').style.display = 'flex';
                    form.reset();
                } else {
                    msgEl.style.color = '#dc2626';
                    msgEl.innerText = '❌ ' + (data.message || 'Lỗi khi đặt lịch. Vui lòng thử lại!');
                }
            })
            .catch(err => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<span>✨</span><span>Xác Nhận Đặt Lịch Khám Ngay</span>';
                msgEl.style.color = '#dc2626';
                msgEl.innerText = '❌ Lỗi kết nối máy chủ. Vui lòng gọi Hotline 096 669 2286 để được hỗ trợ.';
            });
        }

        function closeBookingModal() {
            document.getElementById('bookingSuccessModal').style.display = 'none';
        }
    </script>
</body>
</html>

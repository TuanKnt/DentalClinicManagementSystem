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
    <title>Nha khoa Dr.Smile — Nơi khởi nguồn cho nụ cười rạng rỡ</title>
    <meta name="description" content="Nha khoa Dr.Smile chuyên gia răng thẩm mỹ, thiết kế nụ cười, chỉnh nha, implant và điều trị các vấn đề răng miệng trong suốt hơn 17 năm qua.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        html {
            scroll-behavior: smooth;
        }

        /* Dr.Smile Signature Top Bar */
        .ds-topbar {
            background: var(--drsmile-navy);
            color: #e2e8f0;
            font-size: 13px;
            padding: 9px 48px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .ds-topbar-left, .ds-topbar-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .ds-topbar-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .ds-topbar-item a {
            color: #38bdf8;
            text-decoration: none;
            font-weight: 700;
        }
        .ds-topbar-item a:hover {
            color: #7dd3fc;
            text-decoration: underline;
        }

        /* Dr.Smile Main Header Navigation */
        .ds-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border);
            height: 78px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
            box-shadow: 0 2px 12px rgba(0, 51, 102, 0.05);
        }
        .ds-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }
        .ds-brand-logo {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #003366 0%, #0052cc 60%, #00a8cc 100%);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: 0 4px 14px rgba(0, 51, 102, 0.25);
            color: #ffffff;
        }
        .ds-brand-text h1 {
            font-size: 20px;
            font-weight: 800;
            color: var(--drsmile-navy);
            letter-spacing: -0.5px;
            line-height: 1.1;
            margin: 0;
        }
        .ds-brand-text span {
            font-size: 11px;
            font-weight: 700;
            color: var(--drsmile-cyan);
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }
        .ds-nav-menu {
            display: flex;
            align-items: center;
            gap: 26px;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .ds-nav-link {
            text-decoration: none;
            color: var(--drsmile-navy);
            font-size: 14.5px;
            font-weight: 700;
            transition: color var(--transition-fast);
            position: relative;
            padding: 6px 0;
        }
        .ds-nav-link:hover {
            color: var(--drsmile-blue);
        }
        .ds-nav-link.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--drsmile-blue);
            border-radius: 2px;
        }
        .ds-nav-actions {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        /* Dr.Smile Hero Section */
        .ds-hero {
            background: linear-gradient(180deg, #f0f7fd 0%, #ffffff 100%);
            padding: 70px 48px 60px;
            position: relative;
            overflow: hidden;
            border-bottom: 1px solid var(--border);
        }
        .ds-hero-inner {
            max-width: 1220px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 52px;
            align-items: center;
        }
        .ds-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--drsmile-gold-light);
            border: 1px solid #fde047;
            color: var(--drsmile-gold-dark);
            padding: 6px 18px;
            border-radius: var(--radius-full);
            font-size: 13px;
            font-weight: 800;
            margin-bottom: 22px;
            box-shadow: 0 2px 8px rgba(212, 175, 55, 0.15);
        }
        .ds-hero-title {
            font-size: 44px;
            font-weight: 800;
            color: var(--drsmile-navy);
            line-height: 1.2;
            letter-spacing: -1px;
            margin-bottom: 18px;
        }
        .ds-hero-title span {
            background: linear-gradient(135deg, #0052cc 0%, #00a8cc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .ds-hero-subtitle {
            font-size: 16.5px;
            line-height: 1.65;
            color: var(--text-secondary);
            margin-bottom: 32px;
        }
        .ds-hero-btns {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 36px;
            flex-wrap: wrap;
        }

        /* Dr.Smile 4 Core Pillars */
        .ds-pillars-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 36px;
        }
        .ds-pillar-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 18px;
            box-shadow: var(--shadow-xs);
            transition: all var(--transition-normal);
        }
        .ds-pillar-card:hover {
            transform: translateY(-3px);
            border-color: #93c5fd;
            box-shadow: var(--shadow-md);
        }
        .ds-pillar-icon {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .ds-pillar-title {
            font-size: 13.5px;
            font-weight: 800;
            color: var(--drsmile-navy);
            margin-bottom: 6px;
            line-height: 1.3;
        }
        .ds-pillar-desc {
            font-size: 12px;
            color: var(--text-secondary);
            line-height: 1.45;
        }

        /* Hero Right Preview Frame */
        .ds-hero-card {
            background: #ffffff;
            border: 2px solid #e0f2fe;
            border-radius: var(--radius-xl);
            padding: 32px;
            box-shadow: 0 20px 45px -10px rgba(0, 51, 102, 0.12);
            position: relative;
        }
        .ds-hero-card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 22px;
            padding-bottom: 18px;
            border-bottom: 1px solid var(--border);
        }
        .ds-card-badge {
            display: inline-block;
            background: #ecfeff;
            color: #0891b2;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        /* Doctor Spotlight Section (BS. Lý Thị Thủy) */
        .ds-doctor-spotlight {
            background: linear-gradient(135deg, #002244 0%, #003366 60%, #0052cc 100%);
            color: #ffffff;
            padding: 80px 48px;
            position: relative;
            overflow: hidden;
        }
        .ds-doctor-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            gap: 52px;
            align-items: center;
        }
        .ds-doctor-avatar-box {
            position: relative;
            text-align: center;
        }
        .ds-doctor-avatar {
            width: 280px;
            height: 280px;
            border-radius: var(--radius-xl);
            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 110px;
            border: 5px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.3);
        }
        .ds-doctor-motto-box {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: var(--radius-lg);
            padding: 22px 26px;
            margin-top: 24px;
            backdrop-filter: blur(8px);
        }
        .ds-doctor-motto-title {
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #fde047;
            margin-bottom: 8px;
        }
        .ds-doctor-motto-quote {
            font-size: 16px;
            font-weight: 800;
            color: #ffffff;
            font-style: italic;
            line-height: 1.5;
        }
        .ds-doctor-creds {
            list-style: none;
            margin: 22px 0 28px;
            padding: 0;
        }
        .ds-doctor-cred-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 12px;
            font-size: 14.5px;
            color: #e0f2fe;
            line-height: 1.55;
        }
        .ds-doctor-cred-item span {
            color: #fde047;
            font-size: 16px;
            font-weight: 800;
        }

        /* Services Grid (6 Core Services of Dr.Smile) */
        .ds-services-section {
            padding: 80px 48px;
            max-width: 1220px;
            margin: 0 auto;
        }
        .ds-services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 28px;
        }
        .ds-service-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }
        .ds-service-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #0052cc 0%, #00a8cc 100%);
            opacity: 0;
            transition: opacity var(--transition-fast);
        }
        .ds-service-card:hover {
            transform: translateY(-5px);
            border-color: #93c5fd;
            box-shadow: 0 16px 32px -8px rgba(0, 51, 102, 0.12);
        }
        .ds-service-card:hover::before {
            opacity: 1;
        }
        .ds-service-icon-wrap {
            width: 56px;
            height: 56px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 20px;
        }
        .ds-service-card h3 {
            font-size: 19px;
            font-weight: 800;
            color: var(--drsmile-navy);
            margin-bottom: 10px;
        }
        .ds-service-card p {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
            margin-bottom: 22px;
        }
        .ds-service-cta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 18px;
            border-top: 1px solid var(--border-light);
        }

        /* Testimonials / Treatment Results */
        .ds-testimonials {
            background: #f8fafc;
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            padding: 80px 48px;
        }
        .ds-testimonials-grid {
            max-width: 1220px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        .ds-testimonial-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 26px;
            box-shadow: var(--shadow-xs);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .ds-stars {
            color: #f59e0b;
            font-size: 14px;
            margin-bottom: 12px;
        }
        .ds-quote-text {
            font-size: 14px;
            font-style: italic;
            color: var(--text-primary);
            line-height: 1.6;
            margin-bottom: 18px;
        }
        .ds-reviewer {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .ds-reviewer-avatar {
            width: 40px;
            height: 40px;
            border-radius: var(--radius-full);
            background: #e0f2fe;
            color: #0284c7;
            font-weight: 800;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Booking Section */
        .ds-booking-wrap {
            padding: 80px 48px;
            background: linear-gradient(180deg, #ffffff 0%, #f0f7fd 100%);
        }
        .ds-booking-container {
            max-width: 1100px;
            margin: 0 auto;
            background: #ffffff;
            border: 2px solid #bae6fd;
            border-radius: var(--radius-xl);
            box-shadow: 0 24px 50px -12px rgba(0, 51, 102, 0.16);
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            overflow: hidden;
        }
        .ds-booking-side {
            background: linear-gradient(135deg, #003366 0%, #0052cc 100%);
            color: #ffffff;
            padding: 44px 38px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .ds-booking-side h3 {
            font-size: 26px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 14px;
        }
        .ds-booking-side p {
            font-size: 14.5px;
            color: #e0f2fe;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        .ds-booking-form-side {
            padding: 44px 38px;
        }

        /* Dr.Smile Corporate Footer */
        .ds-footer {
            background: #001f3f;
            color: #94a3b8;
            padding: 64px 48px 32px;
            border-top: 2px solid #0052cc;
        }
        .ds-footer-grid {
            max-width: 1220px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1.2fr;
            gap: 40px;
            margin-bottom: 40px;
        }
        .ds-footer-brand h4 {
            color: #ffffff;
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 12px;
        }
        .ds-footer-col h5 {
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 16px;
        }
        .ds-footer-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .ds-footer-links li {
            margin-bottom: 10px;
        }
        .ds-footer-links a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 13.5px;
            transition: color var(--transition-fast);
        }
        .ds-footer-links a:hover {
            color: #38bdf8;
        }
        .ds-footer-bottom {
            max-width: 1220px;
            margin: 0 auto;
            padding-top: 24px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12.5px;
        }

        @media (max-width: 992px) {
            .ds-hero-inner {
                grid-template-columns: 1fr;
            }
            .ds-pillars-grid {
                grid-template-columns: 1fr 1fr;
            }
            .ds-doctor-inner {
                grid-template-columns: 1fr;
            }
            .ds-booking-container {
                grid-template-columns: 1fr;
            }
            .ds-footer-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
        @media (max-width: 768px) {
            .ds-topbar {
                display: none;
            }
            .ds-navbar {
                padding: 0 20px;
            }
            .ds-nav-menu {
                display: none;
            }
            .ds-pillars-grid {
                grid-template-columns: 1fr;
            }
            .ds-footer-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<!-- Floating 24/7 Hotline & Chat Widget (Dr.Smile Signature) -->
<div class="drsmile-floating-call">
    <a href="#booking" class="btn btn-drsmile btn-sm" style="box-shadow: 0 4px 16px rgba(0,82,204,0.35); font-weight:800; border-radius: var(--radius-full);">
        <span>🗓️</span> Đặt Lịch Khám
    </a>
    <a href="https://zalo.me/0966692286" target="_blank" rel="noopener noreferrer" class="drsmile-zalo-btn" title="Chat Zalo Tư Vấn: 096 669 2286">
        Zalo
    </a>
    <a href="https://m.me/www.Dr.Smile" target="_blank" rel="noopener noreferrer" class="drsmile-fb-btn" title="Nhắn tin Facebook Dr.Smile">
        💬
    </a>
    <a href="tel:0966692286" class="drsmile-call-btn" title="Gọi Hotline 24/7: 096 669 2286">
        📞
    </a>
</div>

<!-- Dr.Smile Top Contact Bar -->
<div class="ds-topbar">
    <div class="ds-topbar-left">
        <div class="ds-topbar-item">
            <span>📍</span> <span>Số 41, phố Núi Trúc, phường Giảng Võ, Ba Đình, TP Hà Nội</span>
        </div>
        <div class="ds-topbar-item">
            <span>🕒</span> <span>Thứ 2 – Chủ nhật: 08h30 – 18h30</span>
        </div>
    </div>
    <div class="ds-topbar-right">
        <div class="ds-topbar-item">
            <span>📞</span> <span>Hotline: <a href="tel:0966692286">096 669 2286</a> &bull; <a href="tel:0865428768">08 6542 8768</a></span>
        </div>
        <div class="ds-topbar-item">
            <a href="#booking" class="badge-drsmile-gold" style="text-decoration:none;">
                <span>🎁</span> Đăng ký tư vấn — Nhận ưu đãi miễn phí
            </a>
        </div>
    </div>
</div>

<!-- Dr.Smile Main Header Navigation -->
<nav class="ds-navbar">
    <a href="${pageContext.request.contextPath}/" class="ds-brand">
        <div class="ds-brand-logo">🦷</div>
        <div class="ds-brand-text">
            <h1>Nha Khoa Dr.Smile</h1>
            <span>Nơi khởi nguồn cho nụ cười rạng rỡ</span>
        </div>
    </a>

    <ul class="ds-nav-menu">
        <li><a href="#hero" class="ds-nav-link active">Trang Chủ</a></li>
        <li><a href="#about" class="ds-nav-link">Giới Thiệu</a></li>
        <li><a href="#services" class="ds-nav-link">Dịch Vụ Nha Khoa</a></li>
        <li><a href="#doctor" class="ds-nav-link">Bác Sĩ Phụ Trách</a></li>
        <li><a href="#testimonials" class="ds-nav-link">Hiệu Quả Điều Trị</a></li>
        <li><a href="#articles" class="ds-nav-link">Kiến Thức</a></li>
        <li><a href="#booking" class="ds-nav-link">Đặt Lịch Hẹn</a></li>
        <li><a href="#contact" class="ds-nav-link">Liên Hệ</a></li>
    </ul>

    <div class="ds-nav-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-primary btn-sm">
                    <span>⚡</span> Bàn Làm Việc (${sessionScope.role})
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm">
                    Đăng Xuất
                </a>
            </c:when>
            <c:otherwise>
                <a href="#booking" class="btn btn-primary btn-sm">
                    <span>📅</span> Đặt Lịch Tư Vấn
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm" title="Dành cho Bác sĩ, Lễ tân & Quản trị viên">
                    <span>🔐</span> Cổng Nhân Viên
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Hero Section (Dr.Smile Identity) -->
<section id="hero" class="ds-hero">
    <div class="ds-hero-inner">
        <!-- Left Content -->
        <div>
            <div class="ds-hero-badge">
                <span>⭐</span>
                <span>Chuyên Gia Răng Thẩm Mỹ & Niềng Răng Hơn 17 Năm Kinh Nghiệm</span>
            </div>
            <h1 class="ds-hero-title">
                Nha Khoa Dr.Smile — <span>Nơi Khởi Nguồn Cho Nụ Cười Rạng Rỡ</span>
            </h1>
            <p class="ds-hero-subtitle">
                Được thành lập từ năm 2015, Dr.Smile tự hào là địa chỉ nha khoa tin cậy tại Hà Nội. Với trang thiết bị hiện đại 4.0, đội ngũ Bác sĩ CKI Đại học Y Hà Nội và hệ thống phòng khám vô trùng tuyệt đối, chúng tôi cam kết mang đến trải nghiệm điều trị an toàn, nhẹ nhàng và hiệu quả nhất.
            </p>

            <div class="ds-hero-btns">
                <a href="#booking" class="btn btn-drsmile btn-lg" style="box-shadow: var(--shadow-glow);">
                    <span>🗓️</span> Đặt Lịch Tư Vấn & Nhận Ưu Đãi
                </a>
                <a href="#services" class="btn btn-secondary btn-lg">
                    <span>📋</span> Xem Dịch Vụ & Bảng Giá
                </a>
            </div>

            <!-- 4 Core Pillars of Dr.Smile -->
            <div class="ds-pillars-grid">
                <div class="ds-pillar-card">
                    <div class="ds-pillar-icon">🏥</div>
                    <div class="ds-pillar-title">Quy Trình Chuẩn Y Khoa</div>
                    <div class="ds-pillar-desc">Thăm khám kỹ lưỡng, phác đồ rõ ràng, an toàn tuyệt đối.</div>
                </div>

                <div class="ds-pillar-card">
                    <div class="ds-pillar-icon">🔬</div>
                    <div class="ds-pillar-title">Công Nghệ Hiện Đại 4.0</div>
                    <div class="ds-pillar-desc">Chẩn đoán 3D, scan iTero 5D, nhổ răng sóng siêu âm.</div>
                </div>

                <div class="ds-pillar-card">
                    <div class="ds-pillar-icon">👨‍⚕️</div>
                    <div class="ds-pillar-title">Bác Sĩ Giàu Kinh Nghiệm</div>
                    <div class="ds-pillar-desc">100% Bác sĩ CKI ĐH Y Hà Nội, trên 17 năm lâm sàng.</div>
                </div>

                <div class="ds-pillar-card">
                    <div class="ds-pillar-icon">🛡️</div>
                    <div class="ds-pillar-title">Bảo Hành Thấu Đáo</div>
                    <div class="ds-pillar-desc">Thẻ bảo hành điện tử chính hãng minh bạch lâu dài.</div>
                </div>
            </div>
        </div>

        <!-- Right Quick Overview Card -->
        <div class="ds-hero-card">
            <div class="ds-hero-card-header">
                <div style="width: 52px; height: 52px; border-radius: var(--radius-lg); background: #e0f2fe; display: flex; align-items: center; justify-content: center; font-size: 26px;">
                    ✨
                </div>
                <div>
                    <span class="ds-card-badge">Uy Tín & Chất Lượng</span>
                    <h3 style="font-size: 18px; font-weight: 800; color: var(--drsmile-navy); margin: 4px 0 0;">Nha Khoa Thẩm Mỹ Dr.Smile</h3>
                </div>
            </div>

            <div style="background: var(--drsmile-bg-soft); border: 1px solid #bae6fd; border-radius: var(--radius-md); padding: 18px; margin-bottom: 20px;">
                <div style="font-size: 13px; font-weight: 800; color: var(--drsmile-navy); text-transform: uppercase; margin-bottom: 8px;">
                    🌟 Ưu Đãi Đặc Quyền Tháng Này:
                </div>
                <ul style="font-size: 13.5px; color: var(--text-primary); line-height: 1.6; margin: 0; padding-left: 20px;">
                    <li><strong>Miễn phí 100%</strong> khám và chụp phim chẩn đoán ban đầu.</li>
                    <li><strong>Ưu đãi 30%</strong> dịch vụ Tẩy trắng răng bằng đèn Led.</li>
                    <li><strong>Tặng gói vệ sinh răng miệng</strong> khi niềng răng hoặc dán sứ.</li>
                </ul>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 22px;">
                <div style="background: #ffffff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: var(--drsmile-blue);">5.000+</div>
                    <div style="font-size: 12px; color: var(--text-secondary); font-weight: 600;">Ca phục hình thành công</div>
                </div>
                <div style="background: #ffffff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: #10b981;">100%</div>
                    <div style="font-size: 12px; color: var(--text-secondary); font-weight: 600;">Vô trùng y khoa chuẩn Bộ Y Tế</div>
                </div>
            </div>

            <a href="#booking" class="btn btn-drsmile btn-block">
                <span>✍️</span> Đăng Ký Tư Vấn Ngay
            </a>
        </div>
    </div>
</section>

<!-- About Dr.Smile Story -->
<section id="about" style="padding: 70px 48px; background: #ffffff; border-bottom: 1px solid var(--border);">
    <div style="max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr 1fr; gap: 48px; align-items: center;">
        <div>
            <span class="section-tag">Về Nha Khoa Dr.Smile</span>
            <h2 class="section-title">Hành Trình Kiến Tạo Nụ Cười Rạng Rỡ</h2>
            <p style="font-size: 15.5px; color: var(--text-secondary); line-height: 1.7; margin-bottom: 20px;">
                Dr.Smile được thành lập từ năm 2015, tự hào là địa chỉ chăm sóc răng miệng tin cậy tại Hà Nội. Với trang thiết bị hiện đại, đội ngũ bác sĩ chuyên môn cao, giàu kinh nghiệm và hệ thống phòng khám vô trùng tuyệt đối, chúng tôi cam kết mang đến trải nghiệm điều trị an toàn, nhẹ nhàng và hiệu quả nhất cho từng khách hàng.
            </p>
            <p style="font-size: 14.5px; color: var(--text-secondary); line-height: 1.65; margin-bottom: 24px;">
                Chúng tôi hiểu rằng nụ cười đẹp không chỉ mang lại vẻ ngoài cuốn hút mà còn là chìa khóa mở ra sự tự tin trong cuộc sống và công việc. Mỗi phác đồ điều trị tại Dr.Smile đều được may đo riêng biệt, hướng tới tính thẩm mỹ tự nhiên và độ bền vững trọn đời.
            </p>
            <div style="display: flex; gap: 14px; flex-wrap: wrap;">
                <div class="badge-drsmile-navy">Giấy phép BYT: 0109138207</div>
                <div class="badge-drsmile-gold">Bảo hành điện tử chính hãng</div>
                <div class="badge-drsmile-navy">Công nghệ 4.0 bảo tồn răng thật</div>
            </div>
        </div>

        <div style="background: var(--drsmile-bg-soft); border: 2px solid #bae6fd; border-radius: var(--radius-xl); padding: 36px; box-shadow: var(--shadow-sm);">
            <div style="font-size: 13px; font-weight: 800; color: var(--drsmile-navy); text-transform: uppercase; margin-bottom: 16px;">
                4 NGUYÊN TẮC VÀNG TẠI DR.SMILE
            </div>
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="display: flex; gap: 12px; align-items: flex-start;">
                    <div style="width: 32px; height: 32px; background: #0052cc; color: #ffffff; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-weight: 800; flex-shrink: 0;">1</div>
                    <div>
                        <strong style="color: var(--drsmile-navy); font-size: 14.5px;">Khám Kỹ Lưỡng:</strong>
                        <div style="font-size: 13px; color: var(--text-secondary);">Thăm khám tỉ mỉ, chẩn đoán đúng bệnh, phân tích cấu trúc xương hàm 3D.</div>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; align-items: flex-start;">
                    <div style="width: 32px; height: 32px; background: #0052cc; color: #ffffff; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-weight: 800; flex-shrink: 0;">2</div>
                    <div>
                        <strong style="color: var(--drsmile-navy); font-size: 14.5px;">Tư Vấn Rõ Ràng:</strong>
                        <div style="font-size: 13px; color: var(--text-secondary);">Minh bạch phương án, chi phí trọn gói rõ ràng, không phát sinh chi phí ẩn.</div>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; align-items: flex-start;">
                    <div style="width: 32px; height: 32px; background: #0052cc; color: #ffffff; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-weight: 800; flex-shrink: 0;">3</div>
                    <div>
                        <strong style="color: var(--drsmile-navy); font-size: 14.5px;">Điều Trị Nhẹ Nhàng:</strong>
                        <div style="font-size: 13px; color: var(--text-secondary);">Ứng dụng công nghệ sóng siêu âm và thuốc tê an toàn, êm ái, hạn chế tối đa ê buốt.</div>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; align-items: flex-start;">
                    <div style="width: 32px; height: 32px; background: #0052cc; color: #ffffff; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-weight: 800; flex-shrink: 0;">4</div>
                    <div>
                        <strong style="color: var(--drsmile-navy); font-size: 14.5px;">Bảo Hành Thấu Đáo:</strong>
                        <div style="font-size: 13px; color: var(--text-secondary);">Thẻ bảo hành chính hãng, chăm sóc hậu điều trị tận tâm và nhắc hẹn định kỳ.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Doctor Spotlight Section (BS. Lý Thị Thủy - Dr.Smile Director) -->
<section id="doctor" class="ds-doctor-spotlight">
    <div class="ds-doctor-inner">
        <!-- Avatar & Motto -->
        <div class="ds-doctor-avatar-box">
            <div class="ds-doctor-avatar">
                <svg width="140" height="140" viewBox="0 0 24 24" fill="none" stroke="#003366" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="7" r="4"/>
                    <path d="M5.5 21v-2a6.5 6.5 0 0 1 13 0v2"/>
                    <path d="M12 14v4"/>
                    <path d="M10 16h4"/>
                </svg>
            </div>
            <div style="margin-top: -18px; text-align: center; position: relative; z-index: 2;">
                <span class="badge-drsmile-gold" style="background: linear-gradient(135deg, #d4af37 0%, #f59e0b 100%); color: #ffffff; font-weight: 800; border: 2px solid #ffffff; box-shadow: 0 4px 14px rgba(0,0,0,0.25); padding: 6px 18px;">
                    ⭐ 17+ NĂM KINH NGHIỆM
                </span>
            </div>
            <div class="ds-doctor-motto-box">
                <div class="ds-doctor-motto-title">Kim Chỉ Nam Y Đức Của Bác Sĩ</div>
                <div class="ds-doctor-motto-quote">
                    “Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo”
                </div>
            </div>
        </div>

        <!-- Info & Credentials -->
        <div>
            <div style="display: inline-block; background: rgba(253, 224, 71, 0.2); color: #fde047; padding: 4px 14px; border-radius: var(--radius-full); font-size: 12px; font-weight: 800; margin-bottom: 14px;">
                GIÁM ĐỐC – PHỤ TRÁCH CHUYÊN MÔN NHA KHOA DR.SMILE
            </div>
            <h2 style="font-size: 34px; font-weight: 800; color: #ffffff; margin-bottom: 8px;">
                BS.CKI Lý Thị Thủy
            </h2>
            <div style="font-size: 16px; color: #93c5fd; font-weight: 700; margin-bottom: 18px;">
                Chuyên Gia Phục Hình Răng Sứ, Chỉnh Nha Thẩm Mỹ & Cấy Ghép Implant
            </div>

            <p style="font-size: 14.5px; color: #e2e8f0; line-height: 1.65;">
                Luôn đặt mình trong vai trò của khách hàng, thấu hiểu những lo lắng, những khúc mắc, những mong đợi, Bác sĩ Lý Thủy cùng đội ngũ Y, Bác sĩ Nha khoa Dr.Smile luôn đồng hành cùng nụ cười của từng bệnh nhân.
            </p>

            <ul class="ds-doctor-creds">
                <li class="ds-doctor-cred-item">
                    <span>✓</span>
                    <div>Tốt nghiệp <strong>Bác sĩ CKI Răng Hàm Mặt – Đại học Y Hà Nội</strong>.</div>
                </li>
                <li class="ds-doctor-cred-item">
                    <span>✓</span>
                    <div>Tu nghiệp chuyên sâu về <strong>Phục hình răng sứ; Răng thẩm mỹ; Niềng răng; Cấy ghép Implant</strong>.</div>
                </li>
                <li class="ds-doctor-cred-item">
                    <span>✓</span>
                    <div>Thường xuyên tham gia đào tạo về các Kỹ thuật mới trong ngành Nha khoa trong và ngoài nước.</div>
                </li>
                <li class="ds-doctor-cred-item">
                    <span>✓</span>
                    <div><strong>Trên 17 năm kinh nghiệm</strong> với hơn <strong>5.000 ca</strong> phục hình Răng sứ thẩm mỹ và Điều trị răng.</div>
                </li>
            </ul>

            <div style="display: flex; gap: 14px;">
                <a href="#booking" class="btn btn-drsmile-gold" style="background:#f59e0b; color:#ffffff; font-weight:800; border-radius:var(--radius-full); padding: 12px 28px; text-decoration:none;">
                    <span>📅</span> Đặt Lịch Khám Cùng Bác Sĩ Thủy
                </a>
            </div>
        </div>
    </div>
</section>

<!-- 6 Core Services of Dr.Smile -->
<section id="services" class="ds-services-section">
    <div class="section-header">
        <span class="section-tag">Dịch Vụ Nha Khoa Trọng Tâm</span>
        <h2 class="section-title">Giải Pháp Điều Trị & Thẩm Mỹ Nụ Cười Chuẩn 4.0</h2>
        <p class="section-subtitle">
            Khám phá 6 dịch vụ nha khoa chuyên sâu hàng đầu tại Dr.Smile. Mọi quy trình đều được thực hiện theo tiêu chuẩn y khoa nghiêm ngặt.
        </p>
    </div>

    <div class="ds-services-grid">
        <!-- Service 1: Răng sứ & Veneer -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #e0f2fe; color: #0052cc;">💎</div>
                <h3>Răng Sứ & Dán Sứ Veneer 4.0</h3>
                <p>Khám phá giải pháp bọc sứ và dán Veneer công nghệ 4.0 giúp sở hữu nụ cười trắng sáng tự nhiên mà không cần mài nhỏ răng thật, bảo tồn tối đa cấu trúc răng gốc.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Từ 3.500.000 đ/răng</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Răng sứ & Dán sứ Veneer')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>

        <!-- Service 2: Niềng răng -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #fdf2f8; color: #db2777;">✨</div>
                <h3>Niềng Răng Thẩm Mỹ & Invisalign</h3>
                <p>Công nghệ chỉnh nha 3M Unitek và máng trong suốt Invisalign giúp điều chỉnh hàm răng đều đẹp, chuẩn khớp cắn nhẹ nhàng và thẩm mỹ tuyệt đối.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Ưu đãi trả góp 0%</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Niềng răng thẩm mỹ & Invisalign')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>

        <!-- Service 3: Implant -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #f0fdf4; color: #16a34a;">🔩</div>
                <h3>Trồng Răng Implant Kỹ Thuật Số</h3>
                <p>Giải pháp phục hình răng đã mất tối ưu nhất hiện nay, khôi phục chức năng ăn nhai và thẩm mỹ như răng thật với trụ Implant chính hãng bảo hành trọn đời.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Từ 12.500.000 đ</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Trồng răng Implant kỹ thuật số')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>

        <!-- Service 4: Tẩy trắng Led -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #fefce8; color: #ca8a04;">💡</div>
                <h3>Tẩy Trắng Răng Bằng Đèn Led</h3>
                <p>Sở hữu nụ cười rạng rỡ chỉ sau 45 phút với công nghệ tẩy trắng bằng đèn Led an toàn, không ê buốt. Tẩy trắng răng hiệu quả lâu dài và an toàn cho men răng.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Trọn gói 1.800.000 đ</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Tẩy trắng răng bằng đèn Led')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>

        <!-- Service 5: Nhổ răng khôn -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #fee2e2; color: #dc2626;">⚡</div>
                <h3>Quy Trình Nhổ Răng Khôn Không Đau</h3>
                <p>Quy trình nhổ răng khôn bằng sóng siêu âm Piezosurgical hiện đại, giúp vết thương mau lành và hạn chế tối đa cảm giác sưng đau hay ê buốt sau nhổ.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Từ 1.000.000 đ</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Nhổ răng khôn sóng siêu âm Piezosurgical')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>

        <!-- Service 6: Nha khoa tổng quát -->
        <div class="ds-service-card">
            <div>
                <div class="ds-service-icon-wrap" style="background: #f3e8ff; color: #7e22ce;">🩺</div>
                <h3>Nha Khoa Tổng Quát & Bệnh Lý</h3>
                <p>Chăm sóc toàn diện sức khỏe răng miệng với các dịch vụ thăm khám, điều trị tủy răng vi phẫu không đau, hàn trám răng thẩm mỹ và lấy cao răng siêu âm.</p>
            </div>
            <div>
                <div class="ds-service-cta-row">
                    <span style="font-weight: 800; color: var(--drsmile-blue); font-size: 15px;">Từ 250.000 đ</span>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Nha khoa tổng quát & Điều trị bệnh lý')">
                        Đặt Lịch Ngay
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials / Real Transformations (From drsmile.vn) -->
<section id="testimonials" class="ds-testimonials">
    <div class="section-header">
        <span class="section-tag">Hiệu Quả Điều Trị Tại Dr.Smile</span>
        <h2 class="section-title">Khách Hàng Nói Gì Về Chúng Tôi</h2>
        <p class="section-subtitle">
            Hàng ngàn nụ cười đã tự tin tỏa sáng sau hành trình điều trị tận tâm và êm ái tại Nha khoa Dr.Smile.
        </p>
    </div>

    <div class="ds-testimonials-grid">
        <div class="ds-testimonial-card">
            <div>
                <div class="ds-stars">⭐⭐⭐⭐⭐</div>
                <div class="badge-drsmile-gold" style="margin-bottom:12px;">Niềng Răng Mắc Cài Sứ</div>
                <div class="ds-quote-text">
                    “Mình niềng mắc cài sứ ở Dr.Smile gần 2 năm, giờ nhìn lại mới thấy đáng công sức đến thế — hàm răng khấp khểnh ngày xưa giờ đã đều tăm tắp, cười tự tin hẳn ra.”
                </div>
            </div>
            <div class="ds-reviewer">
                <div class="ds-reviewer-avatar">HA</div>
                <div>
                    <strong style="color:var(--drsmile-navy); font-size:14px;">Bạn Hoàng Anh</strong>
                    <div style="font-size:12px; color:var(--text-muted);">24 tuổi &bull; Hà Nội</div>
                </div>
            </div>
        </div>

        <div class="ds-testimonial-card">
            <div>
                <div class="ds-stars">⭐⭐⭐⭐⭐</div>
                <div class="badge-drsmile-gold" style="margin-bottom:12px;">Bọc Răng Sứ Thẩm Mỹ</div>
                <div class="ds-quote-text">
                    “Tôi rất hài lòng với trải nghiệm làm răng sứ tại DR.SMILE. Nụ cười mới trông tự nhiên, hài hòa và giúp tôi cảm thấy tự tin hơn rất nhiều khi giao tiếp với đối tác.”
                </div>
            </div>
            <div class="ds-reviewer">
                <div class="ds-reviewer-avatar">TH</div>
                <div>
                    <strong style="color:var(--drsmile-navy); font-size:14px;">Chị Thu Hương</strong>
                    <div style="font-size:12px; color:var(--text-muted);">34 tuổi &bull; Giảng Võ</div>
                </div>
            </div>
        </div>

        <div class="ds-testimonial-card">
            <div>
                <div class="ds-stars">⭐⭐⭐⭐⭐</div>
                <div class="badge-drsmile-gold" style="margin-bottom:12px;">Nhổ Răng Khôn Piezosurgical</div>
                <div class="ds-quote-text">
                    “Bác sĩ rất tâm lý và thao tác nhẹ nhàng. Quá trình nhổ răng khôn diễn ra thoải mái, tôi không cảm thấy đau và sau đó cũng hoàn toàn không bị sưng.”
                </div>
            </div>
            <div class="ds-reviewer">
                <div class="ds-reviewer-avatar">MT</div>
                <div>
                    <strong style="color:var(--drsmile-navy); font-size:14px;">Anh Minh Tuấn</strong>
                    <div style="font-size:12px; color:var(--text-muted);">28 tuổi &bull; Ba Đình</div>
                </div>
            </div>
        </div>

        <div class="ds-testimonial-card">
            <div>
                <div class="ds-stars">⭐⭐⭐⭐⭐</div>
                <div class="badge-drsmile-gold" style="margin-bottom:12px;">Chỉnh Nha Trẻ Em</div>
                <div class="ds-quote-text">
                    “BS Thủy thăm khám và làm rất nhẹ nhàng. Con tôi cảm thấy rất hứng khởi và chủ động nhắc mẹ đưa đi khám định kỳ từ sáng sớm luôn.”
                </div>
            </div>
            <div class="ds-reviewer">
                <div class="ds-reviewer-avatar">PL</div>
                <div>
                    <strong style="color:var(--drsmile-navy); font-size:14px;">Chị Phương Lan</strong>
                    <div style="font-size:12px; color:var(--text-muted);">Phụ huynh bé Gia Bảo</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Dental Health Knowledge & Blog (From drsmile.vn) -->
<section id="articles" style="padding: 80px 48px; background: #ffffff; border-bottom: 1px solid var(--border);">
    <div style="max-width: 1220px; margin: 0 auto;">
        <div class="section-header">
            <span class="section-tag">Cẩm Nang Nha Khoa</span>
            <h2 class="section-title">Kiến Thức & Lời Khuyên Từ Chuyên Gia Dr.Smile</h2>
            <p class="section-subtitle">
                Cập nhật những thông tin chuyên môn chính xác về chăm sóc răng miệng, phục hình thẩm mỹ và các kỹ thuật nha khoa 4.0 tiên tiến.
            </p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(270px, 1fr)); gap: 24px;">
            <!-- Article 1 -->
            <div class="ds-article-card">
                <div class="ds-article-thumb" style="background: linear-gradient(135deg, #0284c7 0%, #003366 100%);">
                    💎
                    <div class="ds-article-date-badge">28 Tháng 9</div>
                </div>
                <div class="ds-article-body">
                    <div>
                        <div class="badge-drsmile-navy" style="margin-bottom: 8px; font-size: 11px;">Răng Sứ Thẩm Mỹ</div>
                        <h4 class="ds-article-title">Dán sứ Veneer: Ưu nhược điểm và đánh giá khách quan</h4>
                        <p class="ds-article-excerpt">
                            Trong các giải pháp nha khoa thẩm mỹ hiện nay, dán sứ Veneer được đánh giá là bước tiến đột phá nhờ khả năng bảo tồn tối đa răng gốc mà vẫn mang lại nụ cười trắng sáng tự nhiên.
                        </p>
                    </div>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Răng sứ & Dán sứ Veneer')">Tư Vấn Thêm →</a>
                </div>
            </div>

            <!-- Article 2 -->
            <div class="ds-article-card">
                <div class="ds-article-thumb" style="background: linear-gradient(135deg, #0ea5e9 0%, #0369a1 100%);">
                    🦷
                    <div class="ds-article-date-badge">27 Tháng 9</div>
                </div>
                <div class="ds-article-body">
                    <div>
                        <div class="badge-drsmile-navy" style="margin-bottom: 8px; font-size: 11px;">Phục Hình Răng</div>
                        <h4 class="ds-article-title">Răng sứ kim loại có tốt không? Đánh giá chi tiết</h4>
                        <p class="ds-article-excerpt">
                            Trong các dòng sứ hiện nay, răng sứ kim loại là dòng sứ ra đời sớm nhất và vẫn được nhiều khách hàng cân nhắc nhờ chi phí hợp lý và khả năng chịu lực ăn nhai tốt.
                        </p>
                    </div>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Răng sứ & Dán sứ Veneer')">Tư Vấn Thêm →</a>
                </div>
            </div>

            <!-- Article 3 -->
            <div class="ds-article-card">
                <div class="ds-article-thumb" style="background: linear-gradient(135deg, #f43f5e 0%, #9f1239 100%);">
                    ⚡
                    <div class="ds-article-date-badge">26 Tháng 9</div>
                </div>
                <div class="ds-article-body">
                    <div>
                        <div class="badge-drsmile-navy" style="margin-bottom: 8px; font-size: 11px;">Tiểu Phẫu Sóng Siêu Âm</div>
                        <h4 class="ds-article-title">Quy trình nhổ răng khôn Piezosurgical không đau</h4>
                        <p class="ds-article-excerpt">
                            Kỹ thuật nhổ răng khôn sóng siêu âm Piezosurgical hạn chế tối đa xâm lấn mô mềm, không gây sưng đau và giúp vết thương nhanh chóng lành sau tiểu phẫu.
                        </p>
                    </div>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Nhổ răng khôn sóng siêu âm Piezosurgical')">Tư Vấn Thêm →</a>
                </div>
            </div>

            <!-- Article 4 -->
            <div class="ds-article-card">
                <div class="ds-article-thumb" style="background: linear-gradient(135deg, #10b981 0%, #065f46 100%);">
                    ✨
                    <div class="ds-article-date-badge">22 Tháng 9</div>
                </div>
                <div class="ds-article-body">
                    <div>
                        <div class="badge-drsmile-navy" style="margin-bottom: 8px; font-size: 11px;">Nha Khoa Tổng Quát</div>
                        <h4 class="ds-article-title">Lấy cao răng có đau không? Những điều cần biết</h4>
                        <p class="ds-article-excerpt">
                            Lấy cao răng là phương pháp vệ sinh răng miệng định kỳ nhằm loại bỏ mảng bám vôi hóa, phòng ngừa bệnh nha chu và bảo vệ hơi thở luôn thơm mát.
                        </p>
                    </div>
                    <a href="#booking" class="btn btn-secondary btn-sm" onclick="selectServiceForBooking('Nha khoa tổng quát & Điều trị bệnh lý')">Tư Vấn Thêm →</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Guest Online Booking Section -->
<section id="booking" class="ds-booking-wrap">
    <div class="ds-booking-container">
        <!-- Left Banner -->
        <div class="ds-booking-side">
            <div>
                <span class="badge-drsmile-gold" style="background:rgba(255,255,255,0.2); border-color:rgba(255,255,255,0.4); color:#ffffff; margin-bottom:16px;">
                    ĐẶT LỊCH TRỰC TUYẾN DÀNH CHO KHÁCH (GUEST)
                </span>
                <h3>Đăng Ký Tư Vấn & Nhận Ưu Đãi Miễn Phí</h3>
                <p>
                    Quý khách chỉ cần để lại thông tin, đội ngũ Bác sĩ và Chuyên viên Dr.Smile sẽ chủ động liên hệ tư vấn chuyên môn và giữ khung giờ khám ưu tiên không phải chờ đợi.
                </p>

                <div style="background:rgba(255,255,255,0.1); border:1px solid rgba(255,255,255,0.2); border-radius:var(--radius-md); padding:16px; margin-bottom:20px;">
                    <div style="font-size:13px; font-weight:800; color:#fde047; margin-bottom:6px;">Ưu Đãi Khi Đặt Hẹn Trước:</div>
                    <div style="font-size:13px; color:#ffffff; line-height:1.5;">
                        ✓ Miễn phí 100% chi phí khám tổng quát & chụp phim.<br>
                        ✓ Giữ lịch hẹn trực tiếp cùng Bác sĩ CKI ĐH Y Hà Nội.<br>
                        ✓ Không mất thời gian xếp hàng tại quầy.
                    </div>
                </div>
            </div>

            <div style="background:rgba(0,0,0,0.2); border-radius:var(--radius-md); padding:18px;">
                <div style="font-size:12px; text-transform:uppercase; color:#bae6fd; font-weight:700;">Hotline Hỗ Trợ 24/7</div>
                <div style="font-size:22px; font-weight:800; color:#ffffff; margin:4px 0;">
                    <a href="tel:0966692286" style="color:#ffffff; text-decoration:none;">096 669 2286</a>
                </div>
                <div style="font-size:12px; color:#e0f2fe;">(Hỗ trợ tư vấn và giải đáp chi phí miễn phí)</div>
            </div>
        </div>

        <!-- Right Booking Form -->
        <div class="ds-booking-form-side">
            <h4 style="font-size: 22px; font-weight: 800; color: var(--drsmile-navy); margin-bottom: 20px;">
                Phiếu Đăng Ký Khám & Tư Vấn
            </h4>

            <!-- Result Alerts -->
            <div id="bookingSuccessBanner" class="booking-banner success" style="${param.bookingSuccess eq '1' ? 'display:block;' : 'display:none;'}">
                <strong>🎉 Đặt lịch hẹn thành công tại Dr.Smile!</strong><br>
                Mã lịch hẹn của Quý khách là <strong id="resApptId">#${param.apptId}</strong>. Đội ngũ Lễ tân Dr.Smile sẽ gọi điện xác nhận khung giờ trong ít phút.
            </div>

            <div id="bookingErrorBanner" class="booking-banner error" style="${not empty param.bookingError ? 'display:block;' : 'display:none;'}">
                <strong>⚠️ Không thể đặt lịch:</strong> <span id="resErrorMsg">${param.bookingError}</span>
            </div>

            <form id="guestBookingForm" action="${pageContext.request.contextPath}/booking" method="POST" onsubmit="handleGuestBookingSubmit(event)">
                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="guestFullName">Họ và tên Quý khách <span class="required">*</span></label>
                        <input type="text" id="guestFullName" name="fullName" class="form-control" placeholder="Ví dụ: Hoàng Minh Khôi" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="guestPhone">Số điện thoại liên hệ <span class="required">*</span></label>
                        <input type="tel" id="guestPhone" name="phone" class="form-control" placeholder="Ví dụ: 0966692286" pattern="[0-9]{10,11}" required>
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="guestEmail">Email nhận thư xác nhận</label>
                        <input type="email" id="guestEmail" name="email" class="form-control" placeholder="email@example.com">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="guestDentist">Bác sĩ phụ trách</label>
                        <select id="guestDentist" name="dentistId" class="form-control">
                            <option value="">-- Dr.Smile chỉ định Bác sĩ phù hợp --</option>
                            <c:forEach var="d" items="${dentistList}">
                                <option value="${d.dentistId}">${d.fullName} (${d.specialization})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="guestDate">Ngày hẹn mong muốn <span class="required">*</span></label>
                        <input type="date" id="guestDate" name="appointmentDate" class="form-control" min="${todayStr}" value="${todayStr}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="guestTimeSlot">Khung giờ khám <span class="required">*</span></label>
                        <select id="guestTimeSlot" name="timeSlot" class="form-control" required>
                            <optgroup label="Buổi Sáng">
                                <option value="08:30 - 09:30">08:30 – 09:30 (Sáng)</option>
                                <option value="09:30 - 10:30" selected>09:30 – 10:30 (Sáng)</option>
                                <option value="10:30 - 11:30">10:30 – 11:30 (Sáng)</option>
                            </optgroup>
                            <optgroup label="Buổi Chiều">
                                <option value="14:00 - 15:00">14:00 – 15:00 (Chiều)</option>
                                <option value="15:00 - 16:00">15:00 – 16:00 (Chiều)</option>
                                <option value="16:00 - 17:00">16:00 – 17:00 (Chiều)</option>
                                <option value="17:00 - 18:30">17:00 – 18:30 (Cuối ngày)</option>
                            </optgroup>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="guestReason">Dịch vụ quan tâm</label>
                    <select id="guestReason" name="reason" class="form-control">
                        <option value="Khám & tư vấn tổng quát">Khám & tư vấn tổng quát (Miễn phí)</option>
                        <option value="Răng sứ & Dán sứ Veneer">Răng sứ & Dán sứ Veneer 4.0</option>
                        <option value="Niềng răng thẩm mỹ & Invisalign">Niềng răng thẩm mỹ / Invisalign</option>
                        <option value="Trồng răng Implant kỹ thuật số">Trồng răng Implant kỹ thuật số</option>
                        <option value="Tẩy trắng răng bằng đèn Led">Tẩy trắng răng bằng đèn Led</option>
                        <option value="Nhổ răng khôn sóng siêu âm Piezosurgical">Nhổ răng khôn sóng siêu âm Piezosurgical</option>
                        <option value="Điều trị tủy răng & Chữa răng sâu">Điều trị tủy răng & Chữa răng sâu</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="guestNotes">Mô tả tình trạng răng hoặc yêu cầu đặc biệt</label>
                    <textarea id="guestNotes" name="notes" class="form-control" rows="2" placeholder="Ví dụ: Răng hàm bị đau nhức khi nhai, mong muốn bác sĩ Thủy khám..."></textarea>
                </div>

                <button type="submit" id="btnSubmitBooking" class="btn btn-drsmile btn-block btn-lg" style="margin-top: 14px;">
                    <span>✓</span> Xác Nhận Đăng Ký Khám
                </button>
                <div style="font-size: 12px; color: var(--text-muted); text-align: center; margin-top: 12px;">
                    🔒 Thông tin của Quý khách được bảo mật tuyệt đối theo Quy định Y tế của Dr.Smile.
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Staff Intranet Access Bar -->
<section class="staff-portal-bar">
    <div class="staff-portal-inner">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="section-tag" style="margin-bottom: 4px;">Dành Cho Đội Ngũ Y Bác Sĩ & Nhân Sự</span>
                <h3 style="font-size: 22px; font-weight: 800; color: var(--drsmile-navy); margin: 0;">
                    Cổng Tác Nghiệp Nội Bộ DCMS (Staff Intranet)
                </h3>
            </div>
            <div>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-primary">
                            <span>⚡</span> Vào Bàn Làm Việc (${sessionScope.currentUser.fullName})
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">
                            <span>🔐</span> Đăng Nhập Cán Bộ Phòng Khám
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 20px;">
            <a href="${pageContext.request.contextPath}/reception/appointments" class="card" style="padding: 20px; text-decoration: none; color: inherit; transition: all var(--transition-fast);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                    <span style="font-size: 24px;">📅</span>
                    <strong style="font-size: 15px; color: var(--drsmile-navy);">Quản Lý Lịch Hẹn</strong>
                </div>
                <div style="font-size: 13px; color: var(--text-secondary);">Calendar lịch hẹn, kiểm tra ca trực và chống trùng giờ khám.</div>
            </a>

            <a href="${pageContext.request.contextPath}/reception/checkin" class="card" style="padding: 20px; text-decoration: none; color: inherit; transition: all var(--transition-fast);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                    <span style="font-size: 24px;">🚪</span>
                    <strong style="font-size: 15px; color: var(--drsmile-navy);">Tiếp Đón & Check-in</strong>
                </div>
                <div style="font-size: 13px; color: var(--text-secondary);">Chuyển lịch hẹn thành lượt khám thực tế, tiếp nhận vãng lai.</div>
            </a>

            <a href="${pageContext.request.contextPath}/reception/patients" class="card" style="padding: 20px; text-decoration: none; color: inherit; transition: all var(--transition-fast);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                    <span style="font-size: 24px;">👥</span>
                    <strong style="font-size: 15px; color: var(--drsmile-navy);">Hồ Sơ Bệnh Nhân</strong>
                </div>
                <div style="font-size: 13px; color: var(--text-secondary);">Tra cứu hồ sơ 360°, cảnh báo dị ứng thuốc Lidocaine/Penicillin.</div>
            </a>

            <a href="${pageContext.request.contextPath}/dentist/queue" class="card" style="padding: 20px; text-decoration: none; color: inherit; transition: all var(--transition-fast);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                    <span style="font-size: 24px;">🩺</span>
                    <strong style="font-size: 15px; color: var(--drsmile-navy);">Bàn Khám Lâm Sàng</strong>
                </div>
                <div style="font-size: 13px; color: var(--text-secondary);">Hàng đợi ghế nha sĩ, sơ đồ răng FDI 11–48 & phim X-quang.</div>
            </a>
        </div>
    </div>
</section>

<!-- Contact & Locations (Official Dr.Smile Info) -->
<section id="contact" style="padding: 70px 48px; background: #ffffff;">
    <div style="max-width: 1220px; margin: 0 auto;">
        <div class="section-header">
            <span class="section-tag">Hệ Thống Phòng Khám</span>
            <h2 class="section-title">Thông Tin Liên Hệ Nha Khoa Dr.Smile</h2>
            <p class="section-subtitle">
                Đón tiếp quý khách từ 08h30 đến 18h30 tất cả các ngày trong tuần (kể cả Thứ 7 và Chủ Nhật).
            </p>
        </div>

        <div style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 36px;">
            <div class="card" style="padding: 36px; border-left: 5px solid var(--drsmile-blue);">
                <div style="font-size: 13px; font-weight: 800; color: var(--drsmile-blue); text-transform: uppercase; margin-bottom: 8px;">Trụ sở chính Hà Nội</div>
                <h3 style="font-size: 20px; font-weight: 800; color: var(--drsmile-navy); margin-bottom: 14px;">CÔNG TY TNHH NHA KHOA DR.SMILE</h3>
                <div style="font-size: 14.5px; color: var(--text-secondary); line-height: 1.7; margin-bottom: 20px;">
                    📍 <strong>Địa chỉ:</strong> Số 41, phố Núi Trúc, phường Giảng Võ, Ba Đình, TP Hà Nội<br>
                    📞 <strong>Hotline 24/7:</strong> <a href="tel:0966692286" style="color:var(--drsmile-blue); font-weight:700;">096 669 2286</a> &bull; <strong>Điện thoại:</strong> 08 6542 8768<br>
                    📧 <strong>Email:</strong> drsmile.vn@gmail.com &bull; contact@drsmile.vn<br>
                    🕒 <strong>Thời gian làm việc:</strong> Thứ 2 – Chủ nhật, 08h30 – 18h30<br>
                    🚗 <strong>Chỗ để xe:</strong> Có chỗ đỗ ô tô và xe máy rộng rãi, an ninh 24/24
                </div>
                <div style="display:flex; gap:12px;">
                    <a href="tel:0966692286" class="btn btn-drsmile btn-sm">Gọi Hotline Ngay</a>
                    <a href="#booking" class="btn btn-secondary btn-sm">Đặt Hẹn Trực Tuyến</a>
                </div>
            </div>

            <div class="card" style="padding: 36px; background: var(--drsmile-bg-soft);">
                <div style="font-size: 13px; font-weight: 800; color: var(--drsmile-navy); text-transform: uppercase; margin-bottom: 12px;">Pháp Lý & Bản Quyền</div>
                <p style="font-size: 13.5px; color: var(--text-secondary); line-height: 1.65; margin-bottom: 18px;">
                    <strong>Số ĐK kinh doanh/MST:</strong> 0109138207 do Sở Kế hoạch & Đầu tư Thành phố Hà Nội cấp lần đầu ngày 23 tháng 3 năm 2020.<br><br>
                    <strong>Tiêu chuẩn y khoa:</strong> Đạt kiểm định an toàn kiểm soát nhiễm khuẩn của Bộ Y Tế, chứng nhận vật liệu sứ chính hãng từ Đức, Thụy Sĩ và Hoa Kỳ.
                </p>
                <div class="badge-drsmile-gold">
                    ✓ Chứng Nhận FDI Dental Clinic
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Dr.Smile Corporate Footer -->
<footer class="ds-footer">
    <div class="ds-footer-grid">
        <div class="ds-footer-brand">
            <h4>🦷 NHA KHOA DR.SMILE</h4>
            <p style="font-size: 13.5px; line-height: 1.65; color: #94a3b8; margin-bottom: 16px;">
                Nơi khởi nguồn cho nụ cười rạng rỡ. Chuyên gia răng thẩm mỹ, thiết kế nụ cười, chỉnh nha, implant và điều trị các vấn đề răng miệng trong suốt hơn 17 năm qua.
            </p>
            <div style="font-size: 12px; color: #64748b;">
                MST: <strong>0109138207</strong> &bull; ĐKKD Sở KH&ĐT TP Hà Nội cấp<br>
                Trụ sở: Số 41 Núi Trúc, P. Giảng Võ, Ba Đình, Hà Nội
            </div>
        </div>

        <div class="ds-footer-col">
            <h5>Dịch Vụ Dr.Smile</h5>
            <ul class="ds-footer-links">
                <li><a href="#services">Răng Sứ Thẩm Mỹ 4.0</a></li>
                <li><a href="#services">Dán Sứ Veneer</a></li>
                <li><a href="#services">Niềng Răng Invisalign</a></li>
                <li><a href="#services">Cấy Ghép Răng Implant</a></li>
                <li><a href="#services">Tẩy Trắng Răng Bằng Led</a></li>
                <li><a href="#services">Nhổ Răng Khôn Piezosurgical</a></li>
            </ul>
        </div>

        <div class="ds-footer-col">
            <h5>Về Chúng Tôi</h5>
            <ul class="ds-footer-links">
                <li><a href="#about">Về Nha Khoa Dr.Smile</a></li>
                <li><a href="#doctor">BS.CKI Lý Thị Thủy</a></li>
                <li><a href="#about">Sứ Mệnh – Tầm Nhìn</a></li>
                <li><a href="#testimonials">Hiệu Quả Điều Trị Thực Tế</a></li>
                <li><a href="${pageContext.request.contextPath}/login">Cổng Nhân Viên Nội Bộ</a></li>
            </ul>
        </div>

        <div class="ds-footer-col">
            <h5>Hotline Hỗ Trợ 24/7</h5>
            <div style="font-size: 22px; font-weight: 800; color: #38bdf8; margin-bottom: 8px;">096 669 2286</div>
            <div style="font-size: 14px; font-weight: 700; color: #ffffff; margin-bottom: 12px;">08 6542 8768</div>
            <p style="font-size: 12.5px; color: #94a3b8; line-height: 1.5; margin-bottom: 16px;">
                Đăng ký tư vấn và nhận ưu đãi miễn phí khám, chụp phim ngay hôm nay.
            </p>
            <a href="#booking" class="btn btn-drsmile btn-sm btn-block" style="text-align:center;">
                Đăng Ký Tư Vấn Ngay
            </a>
        </div>
    </div>

    <div class="ds-footer-bottom">
        <div>&copy; 2026 <strong>CÔNG TY TNHH NHA KHOA DR.SMILE</strong> &bull; DCMS Dental System G3_SE2064</div>
        <div style="color: #64748b;">Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo</div>
    </div>
</footer>

<script>
    function selectServiceForBooking(serviceName) {
        var reasonSelect = document.getElementById('guestReason');
        if (reasonSelect) {
            for (var i = 0; i < reasonSelect.options.length; i++) {
                if (reasonSelect.options[i].text.indexOf(serviceName) !== -1 || reasonSelect.options[i].value.indexOf(serviceName) !== -1) {
                    reasonSelect.selectedIndex = i;
                    break;
                }
            }
            reasonSelect.focus();
        }
    }

    function handleGuestBookingSubmit(event) {
        event.preventDefault();
        var form = event.target;
        var btn = document.getElementById('btnSubmitBooking');
        var successBanner = document.getElementById('bookingSuccessBanner');
        var errorBanner = document.getElementById('bookingErrorBanner');
        var resApptId = document.getElementById('resApptId');
        var resErrorMsg = document.getElementById('resErrorMsg');

        // Hide previous banners
        successBanner.style.display = 'none';
        errorBanner.style.display = 'none';

        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<span>⏳</span> Đang gửi đăng ký tư vấn...';

        var formData = new FormData(form);
        var params = new URLSearchParams(formData);
        params.append('format', 'json');

        fetch(form.action, {
            method: 'POST',
            body: params,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            }
        })
        .then(function(response) {
            return response.json().then(function(data) {
                return { ok: response.ok, data: data };
            });
        })
        .then(function(res) {
            btn.disabled = false;
            btn.innerHTML = originalText;

            if (res.ok && res.data.success) {
                resApptId.textContent = '#' + res.data.appointmentId;
                successBanner.style.display = 'block';
                form.reset();
                successBanner.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                resErrorMsg.textContent = res.data.message || 'Lỗi gửi đăng ký tư vấn';
                errorBanner.style.display = 'block';
                errorBanner.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerHTML = originalText;
            resErrorMsg.textContent = 'Lỗi kết nối máy chủ. Vui lòng gọi trực tiếp hotline 096 669 2286 để được hỗ trợ.';
            errorBanner.style.display = 'block';
        });
    }
</script>

</body>
</html>

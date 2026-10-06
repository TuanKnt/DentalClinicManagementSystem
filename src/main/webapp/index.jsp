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
    <title>Nha khoa Dr.Smile — Nơi khởi nguồn cho nụ cười rạng rỡ | DCMS</title>
    <meta name="description" content="Nha khoa Dr.Smile chuyên gia răng sứ thẩm mỹ, niềng răng, implant và điều trị nha khoa kỹ thuật cao với hơn 17 năm kinh nghiệm tại Hà Nội.">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/Logo-PS.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        :root {
            --dr-navy: #003366;
            --dr-navy-dark: #001d3d;
            --dr-navy-light: #0a2540;
            --dr-blue: #0052cc;
            --dr-cyan: #00a8cc;
            --dr-cyan-light: #e0f7fa;
            --dr-gold: #d4af37;
            --dr-gold-dark: #b8860b;
            --dr-gold-light: #fef9c3;
            --dr-bg: #f4f8fc;
            --dr-border: #dce6f0;
        }

        body {
            background-color: var(--dr-bg);
            color: #1e293b;
            font-family: 'Plus Jakarta Sans', 'Inter', -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0;
            padding: 0;
        }

        /* Topbar liên hệ */
        .dr-topbar {
            background: var(--dr-navy-dark);
            color: #94a3b8;
            font-size: 13px;
            padding: 8px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .dr-topbar-left, .dr-topbar-right {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }

        .dr-topbar-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .dr-topbar-item a {
            color: #38bdf8;
            text-decoration: none;
            font-weight: 600;
        }

        .dr-topbar-item a:hover {
            text-decoration: underline;
        }

        /* Header chính */
        .dr-header-main {
            background: #ffffff;
            border-bottom: 1px solid var(--dr-border);
            padding: 12px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dr-brand-link {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
        }

        .dr-brand-link img {
            height: 48px;
            object-fit: contain;
        }

        .dr-brand-text {
            display: flex;
            flex-direction: column;
        }

        .dr-brand-name {
            font-size: 19px;
            font-weight: 800;
            color: var(--dr-navy);
            letter-spacing: -0.3px;
            line-height: 1.2;
        }

        .dr-brand-motto {
            font-size: 11.5px;
            color: #64748b;
            font-weight: 600;
        }

        .dr-header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .dr-action-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px;
            border-radius: var(--radius-full);
            text-decoration: none;
            font-size: 13px;
            transition: all 0.2s ease;
        }

        .dr-action-hotline {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: var(--dr-navy);
        }

        .dr-action-hotline:hover {
            background: #dbeafe;
            transform: translateY(-1px);
        }

        .dr-action-staff {
            background: linear-gradient(135deg, var(--dr-navy) 0%, var(--dr-blue) 100%);
            color: #ffffff;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
        }

        .dr-action-staff:hover {
            box-shadow: 0 6px 18px rgba(0, 51, 102, 0.3);
            transform: translateY(-1px);
        }

        /* =====================================================================
           MEGA TAB NAVIGATION BAR (STICKY) — CÁC TAB CỦA DRSMILE.VN
           ===================================================================== */
        .dr-tab-navbar {
            background: #ffffff;
            border-bottom: 2px solid #e2e8f0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 14px rgba(0, 51, 102, 0.06);
            display: flex;
            justify-content: center;
            padding: 0 40px;
        }

        .dr-tab-nav-list {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            gap: 4px;
            overflow-x: auto;
            scrollbar-width: none;
        }

        .dr-tab-nav-list::-webkit-scrollbar {
            display: none;
        }

        .dr-tab-nav-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 16px 20px;
            font-size: 14.5px;
            font-weight: 700;
            color: #475569;
            background: transparent;
            border: none;
            cursor: pointer;
            position: relative;
            white-space: nowrap;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .dr-tab-nav-btn:hover {
            color: var(--dr-blue);
            background: #f8fafc;
        }

        .dr-tab-nav-btn.active {
            color: var(--dr-navy);
            font-weight: 800;
        }

        .dr-tab-nav-btn.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--dr-navy) 0%, var(--dr-cyan) 100%);
            border-radius: 3px 3px 0 0;
        }

        .dr-tab-badge {
            font-size: 10px;
            padding: 2px 7px;
            border-radius: var(--radius-full);
            font-weight: 800;
            background: #fef3c7;
            color: #b45309;
        }

        /* Container của các nội dung Tab */
        .dr-main-content {
            flex: 1;
            max-width: 1240px;
            width: 100%;
            margin: 0 auto;
            padding: 32px 24px 60px;
        }

        /* Hiển thị / Ẩn các Tab Panel */
        .dr-tab-pane {
            display: none;
            animation: fadeIn 0.25s ease-out;
        }

        .dr-tab-pane.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* =====================================================================
           TAB 1: TRANG CHỦ (HOME PANEL)
           ===================================================================== */
        .home-hero-banner {
            background: linear-gradient(rgba(0, 29, 61, 0.75), rgba(0, 51, 102, 0.85)), url('${pageContext.request.contextPath}/assets/images/HERO-BANNER-1572x600.jpg');
            background-size: cover;
            background-position: center;
            border-radius: 20px;
            padding: 56px 48px;
            color: #ffffff;
            box-shadow: 0 10px 30px rgba(0, 51, 102, 0.15);
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 32px;
        }

        .hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            border-radius: var(--radius-full);
            background: rgba(0, 168, 204, 0.25);
            border: 1px solid rgba(0, 168, 204, 0.5);
            color: #a5f3fc;
            font-size: 13px;
            font-weight: 700;
            width: fit-content;
        }

        .hero-heading {
            font-size: 38px;
            font-weight: 800;
            line-height: 1.25;
            letter-spacing: -0.6px;
            margin: 0;
        }

        .hero-heading span {
            color: #38bdf8;
        }

        .hero-lead {
            font-size: 16px;
            color: #e2e8f0;
            max-width: 720px;
            line-height: 1.6;
            margin: 0;
        }

        .hero-btn-row {
            display: flex;
            gap: 14px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .btn-hero-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 26px;
            background: linear-gradient(135deg, #00a8cc 0%, #0052cc 100%);
            color: white;
            border-radius: 10px;
            font-size: 14.5px;
            font-weight: 700;
            text-decoration: none;
            box-shadow: 0 4px 14px rgba(0, 168, 204, 0.35);
            cursor: pointer;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-hero-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 168, 204, 0.45);
        }

        .btn-hero-secondary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            font-size: 14.5px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-hero-secondary:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
        }

        /* Thanh đếm thống kê Dr.Smile */
        .dr-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 32px;
        }

        .dr-stat-box {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 14px;
            padding: 20px 24px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }

        .dr-stat-num {
            font-size: 30px;
            font-weight: 800;
            color: var(--dr-navy);
            margin-bottom: 4px;
        }

        .dr-stat-desc {
            font-size: 13px;
            color: #64748b;
            font-weight: 600;
        }

        /* 4 Trụ cột cam kết Dr.Smile */
        .commitments-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 36px;
        }

        .commitment-card {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 14px;
            padding: 24px 20px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
        }

        .commitment-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: #cbd5e1;
        }

        .commitment-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .commitment-icon img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .commitment-card h4 {
            font-size: 15px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 6px 0;
        }

        .commitment-card p {
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.5;
            margin: 0;
        }

        /* Khối Cổng Tác Nghiệp DCMS */
        .home-portals-section {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 28px 32px;
            box-shadow: var(--shadow-sm);
        }

        .home-portals-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .home-portals-header h3 {
            font-size: 18px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .portal-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .portal-item-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
        }

        .portal-item-card:hover {
            background: #ffffff;
            border-color: var(--portal-color, var(--dr-blue));
            box-shadow: 0 8px 20px rgba(0, 51, 102, 0.08);
            transform: translateY(-2px);
        }

        /* =====================================================================
           TAB 2: DỊCH VỤ NHA KHOA (SERVICES PANEL CÓ SUB-TABS)
           ===================================================================== */
        .services-header {
            text-align: center;
            margin-bottom: 28px;
        }

        .services-header h2 {
            font-size: 28px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 8px 0;
        }

        .services-header p {
            font-size: 14.5px;
            color: #64748b;
            margin: 0;
        }

        /* Sub-tabs dịch vụ */
        .subtab-nav {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .subtab-btn {
            padding: 10px 22px;
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: var(--radius-full);
            font-size: 14px;
            font-weight: 700;
            color: #475569;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .subtab-btn:hover {
            border-color: var(--dr-cyan);
            color: var(--dr-navy);
        }

        .subtab-btn.active {
            background: var(--dr-navy);
            color: #ffffff;
            border-color: var(--dr-navy);
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
        }

        .subtab-pane {
            display: none;
            animation: fadeIn 0.25s ease-out;
        }

        .subtab-pane.active {
            display: block;
        }

        .service-cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .service-box {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            transition: all 0.25s ease;
        }

        .service-box:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: #cbd5e1;
        }

        .service-box-img {
            height: 180px;
            width: 100%;
            object-fit: cover;
            background: #e2e8f0;
        }

        .service-box-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
            justify-content: space-between;
        }

        .service-box-title {
            font-size: 17px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 8px 0;
        }

        .service-box-desc {
            font-size: 13px;
            color: #475569;
            line-height: 1.55;
            margin-bottom: 16px;
        }

        .btn-book-service {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 9px 14px;
            background: #f0f7fd;
            border: 1px solid #bae6fd;
            border-radius: 8px;
            color: #0369a1;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-book-service:hover {
            background: #0284c7;
            color: #ffffff;
            border-color: #0284c7;
        }

        /* =====================================================================
           TAB 3: GIỚI THIỆU (ABOUT PANEL)
           ===================================================================== */
        .about-story-row {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 36px;
            align-items: center;
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 36px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 32px;
        }

        .about-story-text h2 {
            font-size: 26px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 14px 0;
        }

        .about-story-text p {
            font-size: 14px;
            color: #475569;
            line-height: 1.65;
            margin-bottom: 14px;
        }

        .facility-gallery-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 24px;
        }

        .facility-img-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            height: 160px;
        }

        .facility-img-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .facility-img-card:hover img {
            transform: scale(1.05);
        }

        /* =====================================================================
           TAB 4: ĐỘI NGŨ BÁC SĨ (DOCTORS PANEL)
           ===================================================================== */
        .doctor-hero-card {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 20px;
            padding: 36px 40px;
            box-shadow: var(--shadow-md);
            display: grid;
            grid-template-columns: 1fr 1.3fr;
            gap: 36px;
            align-items: center;
            margin-bottom: 32px;
        }

        .doctor-portrait-box {
            position: relative;
            text-align: center;
            border-radius: 16px;
            overflow: hidden;
            background: linear-gradient(180deg, #f0f7fd 0%, #e0f2fe 100%);
            border: 3px solid var(--dr-cyan);
            box-shadow: 0 8px 24px rgba(0, 51, 102, 0.1);
        }

        .doctor-portrait-box img {
            width: 100%;
            max-width: 360px;
            height: auto;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }

        .doctor-info-box h2 {
            font-size: 26px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 6px 0;
        }

        .doctor-title-badge {
            display: inline-block;
            background: #fef3c7;
            color: #b45309;
            font-size: 13px;
            font-weight: 800;
            padding: 4px 14px;
            border-radius: var(--radius-full);
            margin-bottom: 16px;
        }

        .doctor-bio {
            font-size: 14px;
            color: #475569;
            line-height: 1.65;
            margin-bottom: 20px;
        }

        .doctor-cert-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 24px;
        }

        .doctor-cert-item {
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            height: 90px;
        }

        .doctor-cert-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* =====================================================================
           TAB 5: BẢNG GIÁ & ƯU ĐÃI (PRICING & DEALS PANEL)
           ===================================================================== */
        .deals-grid-4 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }

        .deal-card {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .deal-badge-gold {
            background: linear-gradient(135deg, #d4af37 0%, #f59e0b 100%);
            color: white;
            font-size: 22px;
            font-weight: 800;
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.35);
        }

        .deal-details h4 {
            font-size: 16px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 6px 0;
        }

        .deal-details p {
            font-size: 13px;
            color: #64748b;
            margin: 0 0 10px 0;
            line-height: 1.5;
        }

        .pricing-table-card {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        .pricing-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
        }

        .pricing-table th, .pricing-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f5f9;
        }

        .pricing-table th {
            background: #f8fafc;
            color: var(--dr-navy);
            font-weight: 700;
            text-align: left;
        }

        /* =====================================================================
           TAB 6: TIN TỨC & KIẾN THỨC (NEWS PANEL)
           ===================================================================== */
        .news-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .news-card {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            transition: all 0.2s ease;
        }

        .news-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .news-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .news-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex: 1;
            justify-content: space-between;
        }

        .news-title {
            font-size: 14.5px;
            font-weight: 800;
            color: var(--dr-navy);
            margin: 0 0 8px 0;
            line-height: 1.4;
        }

        .news-excerpt {
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 12px;
        }

        /* =====================================================================
           TAB 7: ĐẶT LỊCH KHÁM & LIÊN HỆ (BOOKING PANEL)
           ===================================================================== */
        .booking-page-layout {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 32px;
            align-items: start;
        }

        .booking-form-box {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 32px;
            box-shadow: var(--shadow-md);
        }

        .booking-info-box {
            background: #ffffff;
            border: 1px solid var(--dr-border);
            border-radius: 16px;
            padding: 32px;
            box-shadow: var(--shadow-sm);
        }

        /* Footer */
        .dr-footer {
            background: var(--dr-navy-dark);
            color: #94a3b8;
            font-size: 13px;
            padding: 36px 40px 24px;
            margin-top: auto;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .dr-footer-inner {
            max-width: 1240px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .dr-footer-bottom {
            max-width: 1240px;
            margin: 14px auto 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #64748b;
        }

        /* Modal xác nhận đặt lịch */
        .modal-overlay {
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

        .modal-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 32px;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            text-align: center;
            animation: fadeIn 0.25s ease-out;
        }

        @media (max-width: 992px) {
            .dr-topbar { display: none; }
            .dr-stats-row, .commitments-grid, .portal-grid-3, .service-cards-grid, .doctor-cert-grid, .news-grid { grid-template-columns: repeat(2, 1fr); }
            .doctor-hero-card, .about-story-row, .booking-page-layout, .deals-grid-4 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <!-- 1. TOPBAR LIÊN HỆ CHUẨN DR.SMILE -->
    <div class="dr-topbar">
        <div class="dr-topbar-left">
            <div class="dr-topbar-item">
                <span>📍</span>
                <span>Cơ sở chính: <strong>Số 41, phố Núi Trúc, P. Giảng Võ, Ba Đình, Hà Nội</strong></span>
            </div>
            <div class="dr-topbar-item">
                <span>🕒</span>
                <span>Giờ làm việc: <strong>08:30 – 18:30</strong> (Tất cả các ngày trong tuần)</span>
            </div>
        </div>
        <div class="dr-topbar-right">
            <div class="dr-topbar-item">
                <span>✉️</span>
                <a href="mailto:drsmile.vn@gmail.com">drsmile.vn@gmail.com</a>
            </div>
            <div class="dr-topbar-item">
                <span>📞</span>
                <span>Hotline: <a href="tel:0966692286">096 669 2286</a></span>
            </div>
        </div>
    </div>

    <!-- 2. HEADER THƯƠNG HIỆU & HÀNH ĐỘNG NHANH -->
    <header class="dr-header-main">
        <a href="#home" onclick="switchTab('home')" class="dr-brand-link">
            <img src="${pageContext.request.contextPath}/assets/images/Logo-PS.png" alt="Nha Khoa Dr.Smile">
            <div class="dr-brand-text">
                <span class="dr-brand-name">Nha Khoa Dr.Smile</span>
                <span class="dr-brand-motto">Nơi khởi nguồn cho nụ cười rạng rỡ</span>
            </div>
        </a>

        <div class="dr-header-actions">
            <a href="tel:0966692286" class="dr-action-link dr-action-hotline" title="Gọi hotline 24/7">
                <img src="${pageContext.request.contextPath}/assets/images/drsmile-hotline-support.svg" width="18" height="18" alt="Hotline">
                <span><strong>096 669 2286</strong> &bull; Hỗ trợ 24/7</span>
            </a>

            <button onclick="switchTab('booking')" class="dr-action-link" style="background:#fef3c7; border:1px solid #fde68a; color:#b45309; font-weight:700; cursor:pointer;">
                <img src="${pageContext.request.contextPath}/assets/images/drsmile-customer-support.svg" width="18" height="18" alt="Tư vấn">
                <span>Đăng ký tư vấn miễn phí</span>
            </button>

            <a href="${pageContext.request.contextPath}/login" class="dr-action-link dr-action-staff" title="Cổng tác nghiệp nhân sự">
                <span>🔐</span>
                <span>Cổng Tác Nghiệp DCMS &rarr;</span>
            </a>
        </div>
    </header>

    <!-- 3. MEGA TAB NAVIGATION BAR — CÁC TAB CỦA DRSMILE.VN -->
    <nav class="dr-tab-navbar">
        <div class="dr-tab-nav-list">
            <button class="dr-tab-nav-btn active" id="tabNav-home" onclick="switchTab('home')">
                <span>🏠</span>
                <span>Trang chủ</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-services" onclick="switchTab('services')">
                <span>🦷</span>
                <span>Dịch vụ nha khoa</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-about" onclick="switchTab('about')">
                <span>ℹ️</span>
                <span>Giới thiệu</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-doctors" onclick="switchTab('doctors')">
                <span>👨‍⚕️</span>
                <span>Đội ngũ Bác sĩ</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-pricing" onclick="switchTab('pricing')">
                <span>🏷️</span>
                <span>Bảng giá & Ưu đãi</span>
                <span class="dr-tab-badge">Hot</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-news" onclick="switchTab('news')">
                <span>📰</span>
                <span>Tin tức & Cẩm nang</span>
            </button>
            <button class="dr-tab-nav-btn" id="tabNav-booking" onclick="switchTab('booking')">
                <span>📅</span>
                <span>Đặt lịch khám online</span>
            </button>
        </div>
    </nav>

    <!-- 4. KHU VỰC HIỂN THỊ NỘI DUNG TỪNG TAB -->
    <main class="dr-main-content">

        <!-- =================================================================
             TAB 1: TRANG CHỦ (HOME PANE)
             ================================================================= -->
        <div class="dr-tab-pane active" id="pane-home">
            <!-- Hero Banner -->
            <div class="home-hero-banner">
                <div class="hero-chip">
                    <span>✨</span>
                    <span>Nha Khoa Kỹ Thuật Số Chuẩn Y Khoa — Dr.Smile Inspired</span>
                </div>
                <h1 class="hero-heading">
                    Nơi khởi nguồn cho<br>
                    <span>nụ cười rạng rỡ & bền lâu</span>
                </h1>
                <p class="hero-lead">
                    Kim chỉ nam y đức: <em>"Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"</em>. Hơn 17 năm tiên phong trong răng sứ thẩm mỹ, dán sứ Veneer, niềng răng trong suốt Invisalign và cấy ghép Implant 4.0.
                </p>
                <div class="hero-btn-row">
                    <button onclick="switchTab('booking')" class="btn-hero-primary">
                        <span>📅</span> Đặt Lịch Khám Ưu Tiên
                    </button>
                    <button onclick="switchTab('services')" class="btn-hero-secondary">
                        <span>🔍</span> Khám Phá Các Dịch Vụ
                    </button>
                    <button onclick="switchTab('doctors')" class="btn-hero-secondary">
                        <span>👨‍⚕️</span> Gặp Gỡ Bác Sĩ CKI
                    </button>
                </div>
            </div>

            <!-- 4 Số liệu thống kê của Dr.Smile -->
            <div class="dr-stats-row">
                <div class="dr-stat-box">
                    <div class="dr-stat-num">5.000+</div>
                    <div class="dr-stat-desc">Ca phục hình răng sứ thẩm mỹ</div>
                </div>
                <div class="dr-stat-box">
                    <div class="dr-stat-num">17+</div>
                    <div class="dr-stat-desc">Năm kinh nghiệm chuyên sâu</div>
                </div>
                <div class="dr-stat-box">
                    <div class="dr-stat-num">10.000+</div>
                    <div class="dr-stat-desc">Khách hàng trao gửi nụ cười</div>
                </div>
                <div class="dr-stat-box">
                    <div class="dr-stat-num">100%</div>
                    <div class="dr-stat-desc">Vô trùng chuẩn Bộ Y Tế</div>
                </div>
            </div>

            <!-- 4 Trụ cột cam kết Dr.Smile -->
            <div class="commitments-grid">
                <div class="commitment-card">
                    <div class="commitment-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icon1-400x400.png" alt="Quy trình y khoa">
                    </div>
                    <h4>Quy trình chuẩn y khoa</h4>
                    <p>Khám kỹ lưỡng, phác đồ rõ ràng, vô trùng tuyệt đối đảm bảo an toàn tối đa.</p>
                </div>
                <div class="commitment-card">
                    <div class="commitment-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icon2-400x400.png" alt="Công nghệ 4.0">
                    </div>
                    <h4>Công nghệ hiện đại 4.0</h4>
                    <p>Chẩn đoán 3D Cone Beam, quét dấu iTero 5D, nhổ răng sóng siêu âm Piezosurgical.</p>
                </div>
                <div class="commitment-card">
                    <div class="commitment-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icon3-400x400.png" alt="Đội ngũ bác sĩ">
                    </div>
                    <h4>Bác sĩ CKI giàu kinh nghiệm</h4>
                    <p>Tốt nghiệp ĐH Y Hà Nội, trên 17 năm gắn bó với hàng ngàn ca thẩm mỹ thành công.</p>
                </div>
                <div class="commitment-card">
                    <div class="commitment-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icon4-400x400.png" alt="Bảo hành thấu đáo">
                    </div>
                    <h4>Bảo hành thấu đáo</h4>
                    <p>Thẻ bảo hành điện tử chính hãng minh bạch, đồng hành trọn đời cùng nụ cười bạn.</p>
                </div>
            </div>

            <!-- Cổng Tác Nghiệp Hệ Thống Nội Bộ DCMS -->
            <div class="home-portals-section">
                <div class="home-portals-header">
                    <h3><span>🏢</span> Cổng Tác Nghiệp Quản Trị Hệ Thống DCMS</h3>
                    <a href="${pageContext.request.contextPath}/login" style="font-size:13px; font-weight:700; color:var(--dr-blue); text-decoration:none;">
                        Đăng nhập phân hệ nhân sự &rarr;
                    </a>
                </div>
                <div class="portal-grid-3">
                    <a href="${pageContext.request.contextPath}/reception/checkin" class="portal-item-card" style="--portal-color:#0284c7;">
                        <div>
                            <div style="font-size:24px; margin-bottom:8px;">🚪</div>
                            <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Quầy Tiếp Đón (Receptionist)</h4>
                            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Check-in khách đến khám, tiếp nhận vãng lai cấp cứu, theo dõi lịch hẹn toàn viện.</p>
                        </div>
                        <span style="font-size:12.5px; font-weight:700; color:#0284c7;">Vào Quầy Tiếp Đón &rarr;</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/dentist/dashboard" class="portal-item-card" style="--portal-color:#003366;">
                        <div>
                            <div style="font-size:24px; margin-bottom:8px;">🩺</div>
                            <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Bàn Làm Việc Bác Sĩ (Dentist)</h4>
                            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Hàng đợi ghế khám, sơ đồ răng FDI Odontogram, lưu kết quả sinh hiệu và phim X-quang.</p>
                        </div>
                        <span style="font-size:12.5px; font-weight:700; color:#003366;">Vào Bàn Bác Sĩ &rarr;</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="portal-item-card" style="--portal-color:#7c3aed;">
                        <div>
                            <div style="font-size:24px; margin-bottom:8px;">⚙️</div>
                            <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Quản Trị Viên (Admin)</h4>
                            <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Tổng quan hoạt động phòng khám, danh mục bác sĩ, theo dõi hạ tầng Tomcat 10.</p>
                        </div>
                        <span style="font-size:12.5px; font-weight:700; color:#7c3aed;">Vào Trang Quản Trị &rarr;</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- =================================================================
             TAB 2: DỊCH VỤ NHA KHOA (SERVICES PANE CÓ 4 SUB-TABS)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-services">
            <div class="services-header">
                <h2>Danh Mục Dịch Vụ Nha Khoa Toàn Diện</h2>
                <p>Ứng dụng công nghệ kỹ thuật số 4.0 bảo tồn tối đa răng thật và kiến tạo nụ cười hoàn mỹ</p>
            </div>

            <!-- Sub-tab Navigation (Răng sứ, Niềng răng, Thẩm mỹ, Bệnh lý) -->
            <div class="subtab-nav">
                <button class="subtab-btn active" id="subNav-ceramic" onclick="switchSubTab('ceramic')">
                    💎 Răng Sứ & Dán Sứ Veneer
                </button>
                <button class="subtab-btn" id="subNav-braces" onclick="switchSubTab('braces')">
                    ✨ Niềng Răng Thẩm Mỹ
                </button>
                <button class="subtab-btn" id="subNav-implant" onclick="switchSubTab('implant')">
                    🦷 Cấy Ghép Implant & Thẩm Mỹ
                </button>
                <button class="subtab-btn" id="subNav-general" onclick="switchSubTab('general')">
                    🩺 Điều Trị Bệnh Lý & Nhổ Răng Khôn
                </button>
            </div>

            <!-- Sub-tab 1: Răng sứ thẩm mỹ -->
            <div class="subtab-pane active" id="subPane-ceramic">
                <div class="service-cards-grid">
                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/rang-su-672x400.jpg" alt="Bọc răng sứ 4.0" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Bọc Răng Sứ Công Nghệ 4.0</h3>
                                <p class="service-box-desc">Sử dụng phôi sứ chính hãng từ Đức, Thụy Sĩ (Ceramill, Lava, Zirconia). Độ chịu lực gấp 5 lần răng thật, màu sắc tự nhiên trong suốt.</p>
                            </div>
                            <button onclick="prefillBooking('Bọc răng sứ công nghệ 4.0')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/dan-su-veneer-715x400.png" alt="Dán sứ Veneer" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Dán Sứ Veneer Bảo Tồn</h3>
                                <p class="service-box-desc">Mặt dán sứ siêu mỏng chỉ 0.2 - 0.5mm, bảo tồn tối đa 100% tủy răng thật, không ê buốt, độ bền lên đến 20 năm.</p>
                            </div>
                            <button onclick="prefillBooking('Dán sứ Veneer bảo tồn')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/rang-su-kim-loai-715x400.png" alt="Mão răng sứ cao cấp" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Răng Sứ Bio Ceramic & Katana</h3>
                                <p class="service-box-desc">Dòng sứ tương thích sinh học tuyệt đối, không gây thâm đen viền nướu, bảo hành điện tử chính hãng minh bạch 10 - 15 năm.</p>
                            </div>
                            <button onclick="prefillBooking('Răng sứ Bio Ceramic & Katana')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sub-tab 2: Niềng răng -->
            <div class="subtab-pane" id="subPane-braces">
                <div class="service-cards-grid">
                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/mckimloai-600x400.png" alt="Niềng răng mắc cài 3M" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Niềng Răng Mắc Cài 3M Unitek</h3>
                                <p class="service-box-desc">Hệ thống mắc cài kim loại & sứ thông minh từ Mỹ, lực siết êm ái, rút ngắn thời gian điều trị từ 4 - 6 tháng, chi phí hợp lý.</p>
                            </div>
                            <button onclick="prefillBooking('Niềng răng mắc cài 3M Unitek')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/nieng-rang-mac-cai-kim-loai-co-dau-khong-3-280x280.jpg" alt="Khay niềng Invisalign" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Niềng Răng Trong Suốt Invisalign</h3>
                                <p class="service-box-desc">Khay chỉnh nha vô hình chuẩn Hoa Kỳ. Tháo lắp linh hoạt, ăn uống thoải mái, mô phỏng kết quả 3D trước khi gắn khay.</p>
                            </div>
                            <button onclick="prefillBooking('Niềng răng trong suốt Invisalign')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00262-600x400.webp" alt="Chỉnh nha trẻ em" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Hàm Chỉnh Nha Tăng Trưởng Trẻ Em</h3>
                                <p class="service-box-desc">Can thiệp sớm từ 6 - 12 tuổi giúp định hướng phát triển xương hàm, ngăn ngừa tình trạng hô, móm, lệch lạc cấu trúc khớp cắn.</p>
                            </div>
                            <button onclick="prefillBooking('Chỉnh nha tăng trưởng trẻ em')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sub-tab 3: Nha khoa thẩm mỹ & Implant -->
            <div class="subtab-pane" id="subPane-implant">
                <div class="service-cards-grid">
                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/implant-tedavisi-3661-1-533x400.jpg" alt="Trồng răng Implant" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Cấy Ghép Răng Implant Kỹ Thuật Số</h3>
                                <p class="service-box-desc">Phục hình răng mất hoàn hảo từ chân răng đến thân răng. Trụ Implant Thụy Sĩ, Hàn Quốc tích hợp xương nhanh, ăn nhai trọn đời.</p>
                            </div>
                            <button onclick="prefillBooking('Cấy ghép Implant kỹ thuật số')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/20221206_tay-trang-rang-1-582x400.png" alt="Tẩy trắng răng Led" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Tẩy Trắng Răng Đèn Led Laser</h3>
                                <p class="service-box-desc">Bật 3 - 5 tone men răng chỉ sau 45 phút điều trị tại ghế. Hoàn toàn êm dịu, không gây ê buốt buồng tủy, an toàn men răng.</p>
                            </div>
                            <button onclick="prefillBooking('Tẩy trắng răng đèn Led Laser')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00483-600x400.webp" alt="Cắt lợi thẩm mỹ" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Cắt Lợi Thẩm Mỹ Cười Hở Lợi</h3>
                                <p class="service-box-desc">Điều chỉnh đường viền nướu bằng công nghệ vi phẫu không sưng đau, cân đối tỷ lệ răng - nướu - môi tạo nụ cười rạng rỡ.</p>
                            </div>
                            <button onclick="prefillBooking('Cắt lợi thẩm mỹ cười hở lợi')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sub-tab 4: Bệnh lý & Nhổ răng khôn -->
            <div class="subtab-pane" id="subPane-general">
                <div class="service-cards-grid">
                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00518-600x400.webp" alt="Nhổ răng khôn Piezosurgical" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Nhổ Răng Khôn Sóng Siêu Âm</h3>
                                <p class="service-box-desc">Công nghệ Piezosurgical cắt tách dây chằng quanh răng bằng sóng siêu âm cao tần, hạn chế chảy máu, không sưng má, liền thương nhanh.</p>
                            </div>
                            <button onclick="prefillBooking('Nhổ răng khôn sóng siêu âm')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/han-rang-sau-715x400.png" alt="Điều trị tủy & Hàn răng" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Hàn Răng Sâu & Điều Trị Tủy Vi Phẫu</h3>
                                <p class="service-box-desc">Làm sạch ống tủy dưới kính hiển vi quang học, trám bít kín khít bằng vật liệu sinh học ngăn chặn tái phát nhiễm trùng chóp răng.</p>
                            </div>
                            <button onclick="prefillBooking('Hàn răng sâu & Điều trị tủy')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="service-box">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00225-600x400.webp" alt="Lấy cao răng siêu âm" class="service-box-img">
                        <div class="service-box-body">
                            <div>
                                <h3 class="service-box-title">Lấy Cao Răng Siêu Âm & Đánh Bóng</h3>
                                <p class="service-box-desc">Làm sạch sâu mảng bám dưới nướu không làm xước men răng, kết hợp đánh bóng loại bỏ ố vàng cho hơi thở thơm tho, nướu khỏe mạnh.</p>
                            </div>
                            <button onclick="prefillBooking('Lấy cao răng siêu âm & Đánh bóng')" class="btn-book-service">
                                <span>Đặt lịch tư vấn</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- =================================================================
             TAB 3: GIỚI THIỆU (ABOUT PANE)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-about">
            <div class="about-story-row">
                <div class="about-story-text">
                    <span style="font-size:12.5px; font-weight:800; color:var(--dr-cyan); text-transform:uppercase; letter-spacing:1px;">Về Nha Khoa Dr.Smile</span>
                    <h2>Hơn 17 Năm Kiến Tạo Nụ Cười Hạnh Phúc</h2>
                    <p>
                        Nha khoa Dr.Smile được thành lập bởi nhóm Bác sĩ Chuyên Khoa I Răng Hàm Mặt Đại học Y Hà Nội, hoạt động chính thức theo <strong>Giấy phép hoạt động số 1976/HNO-GPHĐ</strong> do Sở Y Tế Hà Nội cấp.
                    </p>
                    <p>
                        Trải qua hơn 17 năm phục vụ hàng chục ngàn khách hàng trong và ngoài nước, Dr.Smile luôn kiên định với sứ mệnh lấy <strong>"Y đức và Sự an tâm của người bệnh"</strong> làm trọng tâm trong từng thao tác điều trị.
                    </p>
                    <div style="background:#f0f7fd; border-left:4px solid var(--dr-navy); padding:14px 18px; border-radius:0 10px 10px 0; margin-bottom:16px;">
                        <strong style="color:var(--dr-navy);">Triết lý điều trị bất biến:</strong><br>
                        <em>"Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"</em>
                    </div>
                </div>

                <div>
                    <img src="${pageContext.request.contextPath}/assets/images/TDL00518-600x400.webp" alt="Phòng khám Dr.Smile" style="width:100%; border-radius:14px; box-shadow:var(--shadow-md);">
                </div>
            </div>

            <!-- Cơ sở vật chất phòng khám -->
            <div style="background:#ffffff; border:1px solid var(--dr-border); border-radius:16px; padding:28px 32px; box-shadow:var(--shadow-sm);">
                <h3 style="font-size:20px; font-weight:800; color:var(--dr-navy); margin:0 0 8px 0;">Không Gian Vô Trùng & Công Nghệ Nha Khoa 4.0</h3>
                <p style="font-size:13.5px; color:#64748b; margin:0 0 20px 0;">Hệ thống ghế nha khoa thông minh, phòng tiểu phẫu vô khuẩn khép kín tiêu chuẩn Châu Âu tại 41 Núi Trúc, Hà Nội</p>
                
                <div class="facility-gallery-grid">
                    <div class="facility-img-card">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00262-600x400.webp" alt="Phòng tư vấn khách hàng">
                    </div>
                    <div class="facility-img-card">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00483-600x400.webp" alt="Khu điều trị vô trùng">
                    </div>
                    <div class="facility-img-card">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00219-400x600.webp" alt="Hệ thống ghế khám hiện đại">
                    </div>
                    <div class="facility-img-card">
                        <img src="${pageContext.request.contextPath}/assets/images/TDL00225-600x400.webp" alt="Khu tiếp đón bệnh nhân">
                    </div>
                </div>
            </div>
        </div>

        <!-- =================================================================
             TAB 4: ĐỘI NGŨ BÁC SĨ (DOCTORS PANE)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-doctors">
            <div class="doctor-hero-card">
                <div class="doctor-portrait-box">
                    <img src="${pageContext.request.contextPath}/assets/images/bsthuy-e1787212695404-468x600.png" alt="Bác sĩ CKI Lý Thị Thủy">
                </div>

                <div class="doctor-info-box">
                    <span class="doctor-title-badge">Chuyên Gia Răng Hàm Mặt Đầu Ngành</span>
                    <h2>Bác Sĩ CKI Lý Thị Thủy</h2>
                    <p style="color:#0284c7; font-weight:700; font-size:15px; margin-bottom:14px;">
                        Nhà sáng lập Nha Khoa Dr.Smile &bull; Hơn 17 Năm Kinh Nghiệm Lâm Sàng
                    </p>
                    <p class="doctor-bio">
                        Bác sĩ Lý Thị Thủy tốt nghiệp Đại học Y Hà Nội cả hệ Đa khoa và Chuyên khoa I ngành Nha khoa. Đã tham gia hơn 25 khóa đào tạo chuyên sâu trong và ngoài nước về Phục hình răng sứ, Nắn chỉnh nha, Cấy ghép Implant và Nội nha vi phẫu. Với phong cách làm việc tỉ mỉ, nhẹ nhàng và thấu hiểu tâm lý bệnh nhân, bác sĩ Thủy đã điều trị thành công cho hơn 5.000 ca bệnh nhân.
                    </p>

                    <h4 style="font-size:14px; font-weight:800; color:var(--dr-navy); margin-bottom:10px;">Chứng Chỉ Chuyên Khoa Y Tế Đào Tạo:</h4>
                    <div class="doctor-cert-grid">
                        <div class="doctor-cert-item">
                            <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-2-534x400.jpg" alt="Chứng chỉ CKI">
                        </div>
                        <div class="doctor-cert-item">
                            <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-3-533x400.jpg" alt="Chứng chỉ Chỉnh nha">
                        </div>
                        <div class="doctor-cert-item">
                            <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-4-533x400.jpg" alt="Chứng chỉ Implant">
                        </div>
                        <div class="doctor-cert-item">
                            <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-5-533x400.jpg" alt="Chứng chỉ Thẩm mỹ">
                        </div>
                    </div>

                    <button onclick="prefillBooking('', '1')" class="btn-hero-primary" style="font-size:13.5px; padding:10px 20px;">
                        <span>📅</span> Đặt Lịch Khám Trực Tiếp Với Bác Sĩ Lý Thủy
                    </button>
                </div>
            </div>
        </div>

        <!-- =================================================================
             TAB 5: BẢNG GIÁ & ƯU ĐÃI (PRICING & DEALS PANE)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-pricing">
            <div style="text-align:center; margin-bottom:28px;">
                <h2 style="font-size:28px; font-weight:800; color:var(--dr-navy); margin:0 0 6px 0;">Chương Trình Ưu Đãi & Bảng Giá Dịch Vụ</h2>
                <p style="font-size:14px; color:#64748b; margin:0;">Chính sách giá minh bạch, trọn gói, hỗ trợ trả góp 0% lãi suất qua 18 ngân hàng uy tín</p>
            </div>

            <!-- 4 Thẻ Ưu Đãi -->
            <div class="deals-grid-4">
                <div class="deal-card">
                    <div class="deal-badge-gold">0%</div>
                    <div class="deal-details">
                        <h4>Niềng Răng Công Nghệ 3D — Trả Góp 0% Lãi Suất</h4>
                        <p>Miễn phí quét dấu răng 3D iTero 5D mô phỏng kết quả. Hỗ trợ trả góp linh hoạt chỉ từ 1 triệu đồng/tháng, thủ tục xét duyệt trong 15 phút.</p>
                        <button onclick="prefillBooking('Niềng răng trả góp 0%')" class="btn-book-service" style="display:inline-flex;">
                            <span>Nhận ưu đãi ngay</span> &rarr;
                        </button>
                    </div>
                </div>

                <div class="deal-card">
                    <div class="deal-badge-gold">-30%</div>
                    <div class="deal-details">
                        <h4>Ưu Đãi Răng Sứ Chính Hãng Đức & Thụy Sĩ</h4>
                        <p>Giảm đến 30% cho các dòng toàn sứ Cercon HT, Lava Plus, Ceramill Zolid. Tặng kèm gói bảo hành điện tử chính hãng lên tới 15 năm.</p>
                        <button onclick="prefillBooking('Ưu đãi răng sứ thẩm mỹ -30%')" class="btn-book-service" style="display:inline-flex;">
                            <span>Nhận ưu đãi ngay</span> &rarr;
                        </button>
                    </div>
                </div>

                <div class="deal-card">
                    <div class="deal-badge-gold">FREE</div>
                    <div class="deal-details">
                        <h4>Cấy Ghép Implant — Miễn Phí Chụp CT 3D</h4>
                        <p>Tặng gói chụp phim CT Cone Beam 3D trị giá 800.000đ khi cấy ghép trụ Implant. Miễn phí khớp nối Abutment chính hãng.</p>
                        <button onclick="prefillBooking('Cấy ghép Implant tặng gói CT 3D')" class="btn-book-service" style="display:inline-flex;">
                            <span>Nhận ưu đãi ngay</span> &rarr;
                        </button>
                    </div>
                </div>

                <div class="deal-card">
                    <div class="deal-badge-gold">250K</div>
                    <div class="deal-details">
                        <h4>Gói Chăm Sóc Nụ Cười Sáng Toàn Diện</h4>
                        <p>Lấy cao răng siêu âm chuyên sâu + Đánh bóng + Đèn Led tẩy ố vàng men răng chỉ từ 250.000đ dành cho khách hàng đăng ký online.</p>
                        <button onclick="prefillBooking('Gói chăm sóc răng 250K')" class="btn-book-service" style="display:inline-flex;">
                            <span>Nhận ưu đãi ngay</span> &rarr;
                        </button>
                    </div>
                </div>
            </div>

            <!-- Bảng giá dịch vụ niêm yết -->
            <div class="pricing-table-card">
                <h3 style="font-size:18px; font-weight:800; color:var(--dr-navy); margin:0 0 16px 0;">Bảng Giá Dịch Vụ Nha Khoa Niêm Yết Tham Khảo</h3>
                <table class="pricing-table">
                    <thead>
                        <tr>
                            <th>Nhóm Dịch Vụ</th>
                            <th>Tên Dịch Vụ Chi Tiết</th>
                            <th>Đơn Vị</th>
                            <th>Chi Phí Niêm Yết (VNĐ)</th>
                            <th>Bảo Hành</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Răng Sứ</strong></td>
                            <td>Răng toàn sứ Zirconia Dmax</td>
                            <td>Răng</td>
                            <td><strong style="color:var(--dr-navy);">3.500.000 đ</strong></td>
                            <td>10 Năm</td>
                        </tr>
                        <tr>
                            <td><strong>Răng Sứ</strong></td>
                            <td>Dán sứ Veneer Emax Thụy Sĩ</td>
                            <td>Răng</td>
                            <td><strong style="color:var(--dr-navy);">6.500.000 đ</strong></td>
                            <td>15 Năm</td>
                        </tr>
                        <tr>
                            <td><strong>Chỉnh Nha</strong></td>
                            <td>Niềng răng mắc cài kim loại 3M</td>
                            <td>2 Hàm</td>
                            <td><strong style="color:var(--dr-navy);">25.000.000 – 35.000.000 đ</strong></td>
                            <td>Trọn đời phác đồ</td>
                        </tr>
                        <tr>
                            <td><strong>Chỉnh Nha</strong></td>
                            <td>Khay trong suốt Invisalign USA</td>
                            <td>Gói</td>
                            <td><strong style="color:var(--dr-navy);">60.000.000 – 110.000.000 đ</strong></td>
                            <td>Chính hãng Align</td>
                        </tr>
                        <tr>
                            <td><strong>Implant</strong></td>
                            <td>Trụ Implant Dentium Hàn Quốc</td>
                            <td>Trụ</td>
                            <td><strong style="color:var(--dr-navy);">14.500.000 đ</strong></td>
                            <td>Trọn đời</td>
                        </tr>
                        <tr>
                            <td><strong>Tiểu Phẫu</strong></td>
                            <td>Nhổ răng khôn sóng siêu âm Piezosurgical</td>
                            <td>Răng</td>
                            <td><strong style="color:var(--dr-navy);">1.200.000 – 2.500.000 đ</strong></td>
                            <td>Theo dõi lành thương</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- =================================================================
             TAB 6: TIN TỨC & KIẾN THỨC (NEWS PANE)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-news">
            <div style="text-align:center; margin-bottom:28px;">
                <h2 style="font-size:28px; font-weight:800; color:var(--dr-navy); margin:0 0 6px 0;">Cẩm Nang Nha Khoa & Tư Vấn Chuyên Gia</h2>
                <p style="font-size:14px; color:#64748b; margin:0;">Lời khuyên chuyên môn từ Bác sĩ CKI Lý Thị Thủy giúp bạn chăm sóc và bảo vệ hàm răng chắc khỏe</p>
            </div>

            <div class="news-grid">
                <div class="news-card">
                    <img src="${pageContext.request.contextPath}/assets/images/dan-su-veneer-715x400.png" alt="Dán sứ Veneer">
                    <div class="news-body">
                        <div>
                            <span style="font-size:11px; font-weight:700; color:#0284c7; text-transform:uppercase;">Kiến thức thẩm mỹ</span>
                            <h4 class="news-title">Dán Sứ Veneer Là Gì? Ai Nên Dán Sứ Để Bảo Tồn Răng Thật?</h4>
                            <p class="news-excerpt">Tìm hiểu công nghệ dán sứ siêu mỏng không mài nhỏ răng, phân biệt dán sứ với bọc mão răng thông thường.</p>
                        </div>
                        <a href="#services" onclick="switchSubTab('ceramic'); switchTab('services');" style="font-size:12.5px; font-weight:700; color:var(--dr-navy); text-decoration:none;">Đọc chi tiết &rarr;</a>
                    </div>
                </div>

                <div class="news-card">
                    <img src="${pageContext.request.contextPath}/assets/images/TDL00518-600x400.webp" alt="Nhổ răng khôn">
                    <div class="news-body">
                        <div>
                            <span style="font-size:11px; font-weight:700; color:#059669; text-transform:uppercase;">Tiểu phẫu an toàn</span>
                            <h4 class="news-title">Quy Trình Nhổ Răng Khôn Không Đau Bằng Sóng Siêu Âm</h4>
                            <p class="news-excerpt">Vì sao sóng siêu âm Piezosurgical lại là bước đột phá giúp giảm sưng đau và mau lành thương gấp 3 lần?</p>
                        </div>
                        <a href="#services" onclick="switchSubTab('general'); switchTab('services');" style="font-size:12.5px; font-weight:700; color:var(--dr-navy); text-decoration:none;">Đọc chi tiết &rarr;</a>
                    </div>
                </div>

                <div class="news-card">
                    <img src="${pageContext.request.contextPath}/assets/images/mckimloai-600x400.png" alt="Niềng răng">
                    <div class="news-body">
                        <div>
                            <span style="font-size:11px; font-weight:700; color:#d97706; text-transform:uppercase;">Chỉnh nha thẩm mỹ</span>
                            <h4 class="news-title">Độ Tuổi Nào Thích Hợp Nhất Để Niềng Răng Đạt Hiệu Quả?</h4>
                            <p class="news-excerpt">Lời khuyên của chuyên gia về độ tuổi vàng niềng răng từ 6-12 tuổi và khả năng chỉnh nha ở người trưởng thành.</p>
                        </div>
                        <a href="#services" onclick="switchSubTab('braces'); switchTab('services');" style="font-size:12.5px; font-weight:700; color:var(--dr-navy); text-decoration:none;">Đọc chi tiết &rarr;</a>
                    </div>
                </div>

                <div class="news-card">
                    <img src="${pageContext.request.contextPath}/assets/images/TDL00225-600x400.webp" alt="Lấy cao răng">
                    <div class="news-body">
                        <div>
                            <span style="font-size:11px; font-weight:700; color:#7c3aed; text-transform:uppercase;">Nha khoa tổng quát</span>
                            <h4 class="news-title">Bao Lâu Nên Lấy Cao Răng 1 Lần? Có Bị Mòn Men Răng Không?</h4>
                            <p class="news-excerpt">Giải đáp thắc mắc về tần suất lấy cao răng định kỳ để phòng tránh viêm nha chu, hôi miệng và tụt lợi.</p>
                        </div>
                        <a href="#services" onclick="switchSubTab('general'); switchTab('services');" style="font-size:12.5px; font-weight:700; color:var(--dr-navy); text-decoration:none;">Đọc chi tiết &rarr;</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- =================================================================
             TAB 7: ĐẶT LỊCH KHÁM & LIÊN HỆ (BOOKING PANE)
             ================================================================= -->
        <div class="dr-tab-pane" id="pane-booking">
            <div class="booking-page-layout">
                <!-- Form Đặt Lịch Online -->
                <div class="booking-form-box">
                    <div style="border-bottom:1px solid #f1f5f9; padding-bottom:14px; margin-bottom:20px;">
                        <span style="font-size:12.5px; font-weight:800; color:var(--dr-cyan); text-transform:uppercase;">Đặt Hẹn Trực Tuyến</span>
                        <h2 style="font-size:22px; font-weight:800; color:var(--dr-navy); margin:4px 0 0 0;">Đăng Ký Khám & Tư Vấn Miễn Phí</h2>
                    </div>

                    <form id="onlineBookingForm" onsubmit="handleTabBooking(event)">
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px;">
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Họ và tên bệnh nhân *</label>
                                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                            </div>
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Số điện thoại *</label>
                                <input type="tel" name="phoneNumber" class="form-control" placeholder="09xxxxxxxx" pattern="[0-9]{10,11}" required style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                            </div>
                        </div>

                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px;">
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Ngày hẹn khám *</label>
                                <input type="date" name="appointmentDate" class="form-control" value="${todayStr}" min="${todayStr}" required style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                            </div>
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Khung giờ mong muốn *</label>
                                <select name="timeSlot" class="form-control" required style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                                    <option value="09:00">09:00 – 09:45 (Sáng)</option>
                                    <option value="10:00" selected>10:00 – 10:45 (Sáng)</option>
                                    <option value="11:00">11:00 – 11:45 (Trưa)</option>
                                    <option value="14:00">14:00 – 14:45 (Chiều)</option>
                                    <option value="15:30">15:30 – 16:15 (Chiều)</option>
                                    <option value="17:00">17:00 – 17:45 (Tối)</option>
                                </select>
                            </div>
                        </div>

                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px;">
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Bác sĩ phụ trách</label>
                                <select name="dentistId" id="bookingDentistSelect" class="form-control" style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                                    <option value="">-- Bác sĩ phù hợp nhất --</option>
                                    <c:forEach var="d" items="${dentistList}">
                                        <option value="${d.dentistId}">${d.fullName} (${empty d.specialization ? 'Nha khoa tổng quát' : d.specialization})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="booking-input-group">
                                <label style="font-size:12.5px; font-weight:700; color:#334155; margin-bottom:4px; display:block;">Dịch vụ yêu cầu</label>
                                <input type="text" name="reason" id="bookingReasonInput" class="form-control" placeholder="Khám tổng quát, răng sứ, niềng răng..." value="Khám tổng quát & Tư vấn" style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1;">
                            </div>
                        </div>

                        <button type="submit" id="btnSubmitTabBooking" class="btn-hero-primary" style="width:100%; padding:14px; justify-content:center; font-size:15px; margin-top:8px;">
                            <span>✨</span> Xác Nhận Đăng Ký Lịch Khám
                        </button>
                        <div id="tabBookingMsg" style="text-align:center; margin-top:10px; font-size:13px;"></div>
                    </form>
                </div>

                <!-- Thông Tin Liên Hệ & Cơ Sở -->
                <div class="booking-info-box">
                    <h3 style="font-size:18px; font-weight:800; color:var(--dr-navy); margin:0 0 16px 0;">Hệ Thống Cơ Sở Nha Khoa Dr.Smile</h3>
                    
                    <div style="margin-bottom:18px; padding-bottom:14px; border-bottom:1px solid #f1f5f9;">
                        <strong style="color:var(--dr-navy); font-size:14.5px;">📍 Cơ sở chính (Núi Trúc):</strong>
                        <p style="font-size:13px; color:#475569; margin:4px 0;">Số 41, phố Núi Trúc, phường Giảng Võ, quận Ba Đình, Hà Nội</p>
                        <span style="font-size:12.5px; color:#0284c7;">📞 Hotline: 096 669 2286</span>
                    </div>

                    <div style="margin-bottom:18px; padding-bottom:14px; border-bottom:1px solid #f1f5f9;">
                        <strong style="color:var(--dr-navy); font-size:14.5px;">📍 Cơ sở 2 (Phố Huế):</strong>
                        <p style="font-size:13px; color:#475569; margin:4px 0;">Số 124 Phố Huế, quận Hai Bà Trưng, Hà Nội</p>
                        <span style="font-size:12.5px; color:#0284c7;">📞 Hotline: 08 6542 8768</span>
                    </div>

                    <div>
                        <strong style="color:var(--dr-navy); font-size:14.5px;">🕒 Giờ Mở Cửa Phục Vụ:</strong>
                        <p style="font-size:13px; color:#475569; margin:4px 0;">Từ 08:30 đến 18:30 (Thứ 2 đến Chủ Nhật, kể cả ngày lễ)</p>
                        <p style="font-size:12.5px; color:#64748b; margin:0;">Email liên hệ: drsmile.vn@gmail.com &bull; MST: 0109138207</p>
                    </div>
                </div>
            </div>
        </div>

    </main>

    <!-- 5. FOOTER PHÁP LÝ & BẢN QUYỀN -->
    <footer class="dr-footer">
        <div class="dr-footer-inner">
            <div>
                <strong style="color:#ffffff; font-size:16px;">CÔNG TY TNHH NHA KHOA DR.SMILE</strong>
                <p style="margin:4px 0 0 0; font-size:12.5px; color:#94a3b8;">
                    Số ĐKKD/MST: 0109138207 do Sở KH&ĐT TP Hà Nội cấp &bull; Giấy phép hoạt động BYT số 1976/HNO-GPHĐ
                </p>
            </div>
            <div style="display:flex; gap:20px; align-items:center;">
                <span>Hotline: <strong style="color:#38bdf8;">096 669 2286</strong></span>
                <span>Cơ sở: 41 Núi Trúc, Hà Nội</span>
            </div>
        </div>
        <div class="dr-footer-bottom">
            <span>© 2026 Nha Khoa Dr.Smile — DCMS Dental Clinic Management System. All rights reserved.</span>
            <span>Apache Tomcat 10.1.8 &bull; Jakarta EE 10</span>
        </div>
    </footer>

    <!-- 6. MODAL XÁC NHẬN ĐẶT LỊCH THÀNH CÔNG -->
    <div id="successModal" class="modal-overlay">
        <div class="modal-card">
            <div style="width:64px; height:64px; border-radius:50%; background:#ecfdf5; color:#059669; font-size:32px; display:flex; align-items:center; justify-content:center; margin:0 auto 16px;">
                ✓
            </div>
            <h3 style="font-size:20px; font-weight:800; color:var(--dr-navy); margin:0 0 8px;">Đặt Lịch Hẹn Thành Công!</h3>
            <p style="font-size:13.5px; color:#475569; line-height:1.5; margin-bottom:18px;">
                Thông tin lịch hẹn đã được ghi nhận trên hệ thống phòng khám Dr.Smile. Quầy lễ tân sẽ liên hệ xác nhận trong ít phút.
            </p>
            <div style="background:#f8fafc; border:1px dashed #cbd5e1; border-radius:10px; padding:14px; margin-bottom:20px; text-align:left; font-size:13px;">
                <div style="margin-bottom:6px;">Mã lịch hẹn: <strong id="modalCode" style="color:#0369a1; font-size:14px;">#APT-...</strong></div>
                <div style="margin-bottom:6px;">Bệnh nhân: <strong id="modalName">-</strong></div>
                <div style="margin-bottom:6px;">Thời gian: <strong id="modalTime">-</strong></div>
                <div>Dịch vụ: <span id="modalReason">-</span></div>
            </div>
            <button onclick="closeModal()" class="btn-hero-primary" style="width:100%; justify-content:center; padding:12px;">
                Hoàn Tất & Đóng
            </button>
        </div>
    </div>

    <!-- JAVASCRIPT ĐIỀU HƯỚNG TABS & AJAX BOOKING -->
    <script>
        // Chuyển đổi Tab chính (Home, Services, About, Doctors, Pricing, News, Booking)
        function switchTab(tabId) {
            const tabs = ['home', 'services', 'about', 'doctors', 'pricing', 'news', 'booking'];
            tabs.forEach(t => {
                const pane = document.getElementById('pane-' + t);
                const navBtn = document.getElementById('tabNav-' + t);
                if (pane) pane.classList.remove('active');
                if (navBtn) navBtn.classList.remove('active');
            });

            const activePane = document.getElementById('pane-' + tabId);
            const activeNav = document.getElementById('tabNav-' + tabId);
            if (activePane) activePane.classList.add('active');
            if (activeNav) activeNav.classList.add('active');

            window.location.hash = tabId;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // Chuyển đổi Sub-tab trong Dịch vụ (Ceramic, Braces, Implant, General)
        function switchSubTab(subId) {
            const subTabs = ['ceramic', 'braces', 'implant', 'general'];
            subTabs.forEach(s => {
                const pane = document.getElementById('subPane-' + s);
                const btn = document.getElementById('subNav-' + s);
                if (pane) pane.classList.remove('active');
                if (btn) btn.classList.remove('active');
            });

            const activeSubPane = document.getElementById('subPane-' + subId);
            const activeSubBtn = document.getElementById('subNav-' + subId);
            if (activeSubPane) activeSubPane.classList.add('active');
            if (activeSubBtn) activeSubBtn.classList.add('active');
        }

        // Tự động điền dịch vụ hoặc bác sĩ rồi chuyển sang Tab Booking
        function prefillBooking(reasonName, dentistId) {
            switchTab('booking');
            if (reasonName) {
                const reasonInput = document.getElementById('bookingReasonInput');
                if (reasonInput) reasonInput.value = reasonName;
            }
            if (dentistId) {
                const dentistSelect = document.getElementById('bookingDentistSelect');
                if (dentistSelect) dentistSelect.value = dentistId;
            }
        }

        // Khởi tạo tab từ URL hash nếu có (ví dụ #services, #doctors)
        window.addEventListener('DOMContentLoaded', () => {
            const hash = window.location.hash.replace('#', '');
            if (hash && ['home', 'services', 'about', 'doctors', 'pricing', 'news', 'booking'].includes(hash)) {
                switchTab(hash);
            }
        });

        // Xử lý gửi AJAX Đặt lịch
        function handleTabBooking(e) {
            e.preventDefault();
            const form = document.getElementById('onlineBookingForm');
            const submitBtn = document.getElementById('btnSubmitTabBooking');
            const msgEl = document.getElementById('tabBookingMsg');

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
                submitBtn.innerHTML = '<span>✨</span><span>Xác Nhận Đăng Ký Lịch Khám</span>';

                if (data.success) {
                    document.getElementById('modalCode').innerText = '#APT-' + (data.appointmentId || 'SUCCESS');
                    document.getElementById('modalName').innerText = form.fullName.value;
                    document.getElementById('modalTime').innerText = form.appointmentDate.value + ' lúc ' + form.timeSlot.value;
                    document.getElementById('modalReason').innerText = form.reason.value;

                    document.getElementById('successModal').style.display = 'flex';
                    form.reset();
                } else {
                    msgEl.style.color = '#dc2626';
                    msgEl.innerText = '❌ ' + (data.message || 'Lỗi khi đặt lịch. Vui lòng thử lại!');
                }
            })
            .catch(err => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<span>✨</span><span>Xác Nhận Đăng Ký Lịch Khám</span>';
                msgEl.style.color = '#dc2626';
                msgEl.innerText = '❌ Lỗi kết nối máy chủ. Vui lòng gọi Hotline 096 669 2286 để được hỗ trợ.';
            });
        }

        function closeModal() {
            document.getElementById('successModal').style.display = 'none';
        }
    </script>
</body>
</html>

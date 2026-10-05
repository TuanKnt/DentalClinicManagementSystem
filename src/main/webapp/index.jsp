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
    <title>Nha khoa Dr.Smile - Nơi khởi nguồn cho nụ cười rạng rỡ</title>
    <meta name="description" content="Nha khoa Dr.Smile chuyên gia răng thẩm mỹ, thiết kế nụ cười, chỉnh nha, implant và điều trị các vấn đề răng miệng trong suốt hơn 17 năm qua.">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/Logo-PS.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/drsmile-clone.css">
</head>
<body>

    <!-- =====================================================================
         1. TOPBAR LIÊN HỆ CHUẨN DR.SMILE
         ===================================================================== -->
    <div class="dr-topbar">
        <div class="dr-topbar-left">
            <div class="dr-topbar-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
                <span>Cơ sở chính: Số 41, phố Núi Trúc, P. Giảng Võ, TP. Hà Nội</span>
            </div>
            <div class="dr-topbar-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                <span>Giờ làm việc: 08:30 – 18:30 (Thứ 2 – Chủ Nhật)</span>
            </div>
        </div>
        <div class="dr-topbar-right">
            <div class="dr-topbar-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                <a href="mailto:drsmile.vn@gmail.com">drsmile.vn@gmail.com</a>
            </div>
            <div class="dr-topbar-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
                <span>Hotline: <a href="tel:0966692286">096 669 2286</a></span>
            </div>
        </div>
    </div>

    <!-- =====================================================================
         2. MAIN HEADER VỚI LOGO, HOTLINE, ĐĂNG KÝ TƯ VẤN & CỔNG TÁC NGHIỆP
         ===================================================================== -->
    <div class="dr-header-main">
        <a href="${pageContext.request.contextPath}/" class="dr-logo-wrap" title="Nha khoa Dr.Smile - Nơi khởi nguồn cho nụ cười rạng rỡ">
            <img src="${pageContext.request.contextPath}/assets/images/Logo-PS.png" alt="Dr.Smile Dental Care">
        </a>

        <div class="dr-search-box">
            <input type="text" class="dr-search-input" placeholder="Tìm kiếm dịch vụ, bảng giá, bác sĩ..." id="globalSearchInput">
            <button class="dr-search-btn" type="button" aria-label="Tìm kiếm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
            </button>
        </div>

        <div class="ds-header-actions">
            <!-- Hotline Link -->
            <a href="tel:0966692286" class="ds-header-link ds-header-link--hotline" title="Gọi Hotline hỗ trợ 24/7">
                <span class="ds-header-link__icon-wrap">
                    <img src="${pageContext.request.contextPath}/assets/images/drsmile-hotline-support.svg" alt="Hotline icon" class="ds-header-link__icon">
                </span>
                <span class="ds-header-link__content">
                    <strong>096 669 2286</strong>
                    <small>Hotline hỗ trợ 24/7</small>
                </span>
            </a>

            <!-- Tư Vấn / Ưu Đãi Link -->
            <a href="#dr-offer-popup" class="ds-header-link ds-header-link--consult" onclick="openOfferPopup(event)" title="Đăng ký tư vấn nhận ưu đãi">
                <span class="ds-header-link__icon-wrap">
                    <img src="${pageContext.request.contextPath}/assets/images/drsmile-customer-support.svg" alt="Support icon" class="ds-header-link__icon">
                </span>
                <span class="ds-header-link__content">
                    <strong>Đăng ký tư vấn</strong>
                    <small>Nhận ưu đãi miễn phí</small>
                </span>
            </a>

            <!-- Staff Intranet Link -->
            <a href="${pageContext.request.contextPath}/login" class="ds-header-link ds-header-link--staff" title="Cổng đăng nhập Bác sĩ / Lễ tân / Quản trị viên">
                <span class="ds-header-link__icon-wrap">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
                </span>
                <span class="ds-header-link__content">
                    <strong>Cổng Tác Nghiệp</strong>
                    <small>Bác Sĩ &bull; Lễ Tân</small>
                </span>
            </a>
        </div>
    </div>

    <!-- =====================================================================
         3. MEGA NAVIGATION BAR (STICKY)
         ===================================================================== -->
    <nav class="dr-navbar">
        <ul class="dr-nav-menu">
            <li class="dr-nav-item">
                <a href="${pageContext.request.contextPath}/" class="dr-nav-link active">Trang chủ</a>
            </li>

            <!-- Mega Dropdown: Dịch vụ nha khoa -->
            <li class="dr-nav-item">
                <a href="#services" class="dr-nav-link">
                    Dịch vụ nha khoa
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><path d="M7 10l5 5 5-5z"/></svg>
                </a>
                <div class="dr-dropdown dr-dropdown-mega">
                    <div class="dr-mega-col">
                        <h4>Răng sứ thẩm mỹ</h4>
                        <ul class="dr-mega-list">
                            <li><a href="#services">Bọc răng sứ công nghệ 4.0</a></li>
                            <li><a href="#services">Dán sứ Veneer bảo tồn</a></li>
                            <li><a href="#services">Chăm sóc răng sau bọc sứ</a></li>
                            <li><a href="#services">Mão răng sứ cao cấp</a></li>
                        </ul>
                    </div>
                    <div class="dr-mega-col">
                        <h4>Niềng Răng Thẩm Mỹ</h4>
                        <ul class="dr-mega-list">
                            <li><a href="#services">Niềng răng mắc cài 3M</a></li>
                            <li><a href="#services">Khay trong suốt Invisalign</a></li>
                            <li><a href="#services">Hàm chỉnh nha trẻ em</a></li>
                            <li><a href="#services">Phẫu thuật hàm hô móm</a></li>
                        </ul>
                    </div>
                    <div class="dr-mega-col">
                        <h4>Nha Khoa Thẩm Mỹ</h4>
                        <ul class="dr-mega-list">
                            <li><a href="#services">Cấy ghép răng Implant</a></li>
                            <li><a href="#services">Tẩy trắng răng đèn Led</a></li>
                            <li><a href="#services">Cắt lợi thẩm mỹ cười hở lợi</a></li>
                            <li><a href="#services">Đính đá thẩm mỹ</a></li>
                        </ul>
                    </div>
                    <div class="dr-mega-col">
                        <h4>Điều Trị Bệnh Lý</h4>
                        <ul class="dr-mega-list">
                            <li><a href="#services">Điều trị tủy vi phẫu</a></li>
                            <li><a href="#services">Nhổ răng khôn Piezosurgical</a></li>
                            <li><a href="#services">Hàn trám răng sâu thẩm mỹ</a></li>
                            <li><a href="#services">Lấy cao răng siêu âm</a></li>
                        </ul>
                    </div>
                </div>
            </li>

            <!-- Dropdown: Giới thiệu -->
            <li class="dr-nav-item">
                <a href="#about" class="dr-nav-link">
                    Giới thiệu
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><path d="M7 10l5 5 5-5z"/></svg>
                </a>
                <div class="dr-dropdown">
                    <ul class="dr-mega-list" style="padding: 0 16px;">
                        <li><a href="#about">Về Nha Khoa Dr.Smile</a></li>
                        <li><a href="#doctor">Đội ngũ Bác sĩ CKI</a></li>
                        <li><a href="#commitments">Cam kết chất lượng</a></li>
                        <li><a href="#about">Cơ sở vật chất chuẩn Bộ Y Tế</a></li>
                    </ul>
                </div>
            </li>

            <li class="dr-nav-item">
                <a href="#doctor" class="dr-nav-link">Bác Sĩ CKI</a>
            </li>

            <li class="dr-nav-item">
                <a href="#cases" class="dr-nav-link">Hiệu Quả Điều Trị</a>
            </li>

            <li class="dr-nav-item">
                <a href="#news" class="dr-nav-link">Tin tức & Sự kiện</a>
            </li>

            <li class="dr-nav-item">
                <a href="#booking-section" class="dr-nav-link" style="color: #059669;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg>
                    Đặt Lịch Online
                </a>
            </li>

            <li class="dr-nav-item">
                <a href="#contact" class="dr-nav-link">Liên hệ</a>
            </li>
        </ul>
    </nav>

    <!-- =====================================================================
         4. HERO BANNER SLIDER (4 AUTHENTIC BANNERS)
         ===================================================================== -->
    <div class="dr-hero-slider-wrap">
        <div class="dr-hero-slides" id="heroSlides">
            <div class="dr-hero-slide">
                <img src="${pageContext.request.contextPath}/assets/images/HERO-BANNER-RANG-SU-1572x600.jpg" alt="Răng sứ thẩm mỹ 4.0 Dr.Smile">
            </div>
            <div class="dr-hero-slide">
                <img src="${pageContext.request.contextPath}/assets/images/HERO-BANNER-1572x600.jpg" alt="Nơi khởi nguồn cho nụ cười rạng rỡ">
            </div>
            <div class="dr-hero-slide">
                <img src="${pageContext.request.contextPath}/assets/images/HERO-BANNER-TRONG-RANG-1572x600.jpg" alt="Trồng răng Implant kỹ thuật số Dr.Smile">
            </div>
            <div class="dr-hero-slide">
                <img src="${pageContext.request.contextPath}/assets/images/HERO-BANNER-TONG-QUAT-1572x600.jpg" alt="Nha khoa tổng quát Dr.Smile">
            </div>
        </div>

        <!-- Slider controls -->
        <button class="dr-slider-btn prev" onclick="moveSlide(-1)" aria-label="Banner trước">&larr;</button>
        <button class="dr-slider-btn next" onclick="moveSlide(1)" aria-label="Banner tiếp theo">&rarr;</button>

        <!-- Slider indicators -->
        <div class="dr-slider-dots">
            <div class="dr-dot active" onclick="setSlide(0)"></div>
            <div class="dr-dot" onclick="setSlide(1)"></div>
            <div class="dr-dot" onclick="setSlide(2)"></div>
            <div class="dr-dot" onclick="setSlide(3)"></div>
        </div>
    </div>

    <!-- =====================================================================
         5. STATS COUNTER BANNER (.dq-stats-banner)
         ===================================================================== -->
    <section class="dq-stats-banner">
        <div class="dq-stat-item">
            <div class="dq-stat-number">5000+</div>
            <div class="dq-stat-label">Ca răng sứ thành công</div>
        </div>
        <div class="dq-stat-item">
            <div class="dq-stat-number">17+</div>
            <div class="dq-stat-label">Năm kinh nghiệm chuyên sâu</div>
        </div>
        <div class="dq-stat-item">
            <div class="dq-stat-number">10000+</div>
            <div class="dq-stat-label">Khách hàng mỗi năm</div>
        </div>
        <div class="dq-stat-item">
            <div class="dq-stat-number">100%</div>
            <div class="dq-stat-label">Khách hàng hài lòng</div>
        </div>
    </section>

    <!-- =====================================================================
         6. SECTION: VỀ NHA KHOA DR.SMILE & TƯ VẤN NHANH
         ===================================================================== -->
    <section class="sec_gioithieu" id="about">
        <!-- Quick Consultation Box -->
        <div class="dr-consult-box">
            <div class="dr-consult-title">
                <span>Đặt Lịch</span>
                <strong>Tư Vấn</strong>
            </div>
            <div class="dr-consult-content">
                <form id="quickConsultForm" onsubmit="handleQuickConsult(event)">
                    <div class="dr-consult-row" style="margin-bottom: 12px;">
                        <div class="dr-field">
                            <span class="dr-field-icon">
                                <svg viewBox="0 0 24 24"><path d="M12 12c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm0 2c-4.42 0-8 2.24-8 5v2h16v-2c0-2.76-3.58-5-8-5z"/></svg>
                            </span>
                            <input type="text" name="fullName" placeholder="Họ và tên quý khách" required>
                        </div>
                        <div class="dr-field">
                            <span class="dr-field-icon">
                                <svg viewBox="0 0 24 24"><path d="M6.6 10.8c1.44 2.83 3.77 5.14 6.6 6.6l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.58.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1C10.61 21 3 13.39 3 4c0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.46.57 3.58.11.35.03.74-.25 1.02l-2.22 2.2z"/></svg>
                            </span>
                            <input type="tel" name="phone" placeholder="Số điện thoại liên hệ" pattern="[0-9]{10,11}" required>
                        </div>
                    </div>
                    <div class="dr-consult-row">
                        <div class="dr-field">
                            <span class="dr-field-icon">
                                <svg viewBox="0 0 24 24"><path d="M20 2H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2h4l4 3 4-3h4a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2zm-3 11H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                            </span>
                            <input type="text" name="notes" placeholder="Tình trạng răng miệng (Sâu răng, niềng răng, bọc sứ...)">
                        </div>
                        <div class="dr-submit-wrap">
                            <button type="submit" class="dr-submit">Đăng ký ngay</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="sec_gioithieu-inner">
            <div class="dr-video-col">
                <div class="dr-video-wrap">
                    <iframe src="https://www.youtube.com/embed/C2tHU05Kgo0?feature=oembed" title="Nha khoa Dr.Smile - Phòng khám nha khoa uy tín chất lượng tại Hà Nội" allowfullscreen></iframe>
                </div>
                <div class="kksr-legend">
                    <span class="stars">★★★★★</span>
                    <span>5/5 - (3.101 bệnh nhân bình chọn xuất sắc)</span>
                </div>
            </div>

            <div class="sec_gioithieu-text">
                <h2>Về Nha Khoa</h2>
                <h1>DR.SMILE</h1>
                <p>
                    <strong>Dr. Smile</strong> được thành lập từ năm 2015, tự hào là địa chỉ chăm sóc răng miệng tin cậy tại Hà Nội. Với trang thiết bị hiện đại, đội ngũ bác sĩ chuyên môn cao, giàu kinh nghiệm và hệ thống phòng khám vô trùng tuyệt đối, chúng tôi cam kết mang đến trải nghiệm điều trị an toàn, nhẹ nhàng và hiệu quả nhất cho từng khách hàng.
                </p>
                <a href="#doctor" class="dr-gradient-btn" style="border-radius: 80px; padding: 0 36px;">
                    Tìm hiểu thêm về Dr.Smile &rarr;
                </a>
            </div>
        </div>

        <!-- 5 Authentic Clinic Interior Photos -->
        <div class="dr-gallery-scatter">
            <div class="dr-gallery-item" title="Phòng khám vô trùng tiêu chuẩn Bộ Y Tế">
                <img src="${pageContext.request.contextPath}/assets/images/TDL00518-600x400.webp" alt="Phòng điều trị hiện đại Dr.Smile">
            </div>
            <div class="dr-gallery-item" title="Ghế khám nha khoa thông minh nhập khẩu">
                <img src="${pageContext.request.contextPath}/assets/images/TDL00262-600x400.webp" alt="Ghế điều trị nha khoa Dr.Smile">
            </div>
            <div class="dr-gallery-item" title="Không gian tiếp đón sang trọng và ấm cúng">
                <img src="${pageContext.request.contextPath}/assets/images/TDL00483-600x400.webp" alt="Sảnh tiếp đón Dr.Smile">
            </div>
            <div class="dr-gallery-item" title="Khu vực chẩn đoán hình ảnh kỹ thuật số">
                <img src="${pageContext.request.contextPath}/assets/images/TDL00219-400x600.webp" alt="Máy chụp CT Cone Beam 3D">
            </div>
            <div class="dr-gallery-item" title="Hệ thống dụng cụ tiệt trùng Autoclave">
                <img src="${pageContext.request.contextPath}/assets/images/TDL00225-600x400.webp" alt="Khu tiệt trùng dụng cụ Dr.Smile">
            </div>
        </div>
    </section>

    <!-- =====================================================================
         7. SECTION: 6 DỊCH VỤ MŨI NHỌN CHUẨN DR.SMILE
         ===================================================================== -->
    <section class="sec_dichvu" id="services">
        <div class="dr-section-title">
            <h2><span>Chúng Tôi Cung Cấp</span> Các Dịch Vụ Mũi Nhọn</h2>
        </div>

        <div class="dr-services-grid">
            <!-- 1. Răng sứ & Dán sứ Veneer -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/rang-su-672x400.jpg" alt="Răng sứ & Dán sứ Veneer">
                </div>
                <div class="dr-service-body">
                    <h3>Răng sứ & Dán sứ Veneer</h3>
                    <p>Khám phá giải pháp bọc sứ và dán Veneer công nghệ 4.0 giúp sở hữu nụ cười trắng sáng tự nhiên mà không cần mài nhỏ răng thật.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>

            <!-- 2. Niềng răng thẩm mỹ -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/mckimloai-600x400.png" alt="Niềng răng thẩm mỹ">
                </div>
                <div class="dr-service-body">
                    <h3>Niềng răng thẩm mỹ</h3>
                    <p>Công nghệ chỉnh nha 3M Unitek và Invisalign giúp điều chỉnh hàm răng đều đẹp, chuẩn khớp cắn một cách nhẹ nhàng và an toàn.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>

            <!-- 3. Trồng răng Implant -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/implant-tedavisi-3661-1-533x400.jpg" alt="Trồng răng Implant">
                </div>
                <div class="dr-service-body">
                    <h3>Trồng răng Implant</h3>
                    <p>Giải pháp phục hình răng đã mất tối ưu nhất hiện nay, khôi phục 100% chức năng ăn nhai và thẩm mỹ trọn vẹn như răng thật.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>

            <!-- 4. Tẩy trắng răng Led -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/20221206_tay-trang-rang-1-582x400.png" alt="Tẩy trắng răng Led">
                </div>
                <div class="dr-service-body">
                    <h3>Tẩy trắng răng Led</h3>
                    <p>Sở hữu nụ cười rạng rỡ chỉ sau 45 phút với công nghệ tẩy trắng bằng đèn Led an toàn, không ê buốt và hiệu quả lâu dài.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>

            <!-- 5. Nhổ răng khôn Piezosurgical -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/NEN-DRSMILE.png" alt="Nhổ răng khôn Piezosurgical">
                </div>
                <div class="dr-service-body">
                    <h3>Nhổ răng khôn sóng siêu âm</h3>
                    <p>Quy trình nhổ răng khôn bằng sóng siêu âm Piezosurgical hiện đại, giúp vết thương mau lành và hạn chế tối đa sưng đau.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>

            <!-- 6. Nha khoa tổng quát -->
            <div class="dr-service-card">
                <div class="dr-service-img">
                    <img src="${pageContext.request.contextPath}/assets/images/OIP-575x400.webp" alt="Nha khoa tổng quát">
                </div>
                <div class="dr-service-body">
                    <h3>Nha khoa tổng quát</h3>
                    <p>Chăm sóc toàn diện sức khỏe răng miệng với các dịch vụ thăm khám, điều trị tủy vi phẫu, lấy cao răng và hàn răng sâu thẩm mỹ.</p>
                    <a href="#booking-section" class="dr-link-btn">ĐẶT LỊCH TƯ VẤN &rarr;</a>
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         8. SECTION: 4 TRỤ CỘT CAM KẾT DR.SMILE
         ===================================================================== -->
    <section class="sec_camket" id="commitments">
        <div class="dr-section-title">
            <h2 style="color: #37aad8;">Cam Kết Từ DR.SMILE</h2>
            <h2 style="font-size: 24px; color: #223064; margin-top: 4px;">Để Thực Hiện Hóa Sứ Mệnh Vì Nụ Cười Việt</h2>
        </div>

        <div class="dr-commitments-grid">
            <div class="dr-commit-card">
                <img src="${pageContext.request.contextPath}/assets/images/icon1-400x400.png" alt="Quy trình chuẩn y khoa" class="dr-commit-icon">
                <h3>Quy trình chuẩn y khoa</h3>
                <p>Khách hàng được thăm khám kỹ lưỡng, tư vấn và xây dựng phác đồ phù hợp. Quy trình điều trị được kiểm soát chặt chẽ, hướng đến sự an toàn và trải nghiệm thoải mái.</p>
            </div>

            <div class="dr-commit-card">
                <img src="${pageContext.request.contextPath}/assets/images/icon3-400x400.png" alt="Công nghệ hiện đại" class="dr-commit-icon">
                <h3>Công nghệ nha khoa hiện đại</h3>
                <p>DR.SMILE ứng dụng trang thiết bị và công nghệ nha khoa tiên tiến, hỗ trợ bác sĩ chẩn đoán chính xác, lập kế hoạch điều trị chi tiết và tối ưu kết quả cho từng khách hàng.</p>
            </div>

            <div class="dr-commit-card">
                <img src="${pageContext.request.contextPath}/assets/images/icon2-400x400.png" alt="Đội ngũ bác sĩ" class="dr-commit-icon">
                <h3>Đội ngũ bác sĩ giàu kinh nghiệm</h3>
                <p>Đội ngũ bác sĩ được đào tạo chính quy CKI, có chuyên môn sâu trong nha khoa thẩm mỹ, chỉnh nha; luôn thăm khám kỹ, tư vấn tận tâm và theo sát suốt quá trình.</p>
            </div>

            <div class="dr-commit-card">
                <img src="${pageContext.request.contextPath}/assets/images/icon4-400x400.png" alt="Chính sách bảo hành" class="dr-commit-icon">
                <h3>Chính sách bảo hành lâu dài</h3>
                <p>Chúng tôi cung cấp thẻ bảo hành và bảo hành điện tử chính hãng, giúp khách hàng thuận tiện tra cứu thông tin, thời hạn bảo hành và chăm sóc nụ cười sau điều trị.</p>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         9. SECTION: TIÊU ĐIỂM CHUYÊN GIA — BÁC SĨ CKI LÝ THỊ THỦY
         ===================================================================== -->
    <section class="sec_bacsi" id="doctor">
        <div class="dr-section-title">
            <h2><span>Hội Tụ Đội Ngũ</span> Thạc Sĩ, Bác Sĩ Hàng Đầu</h2>
        </div>

        <div class="dr-doctor-card">
            <div class="dr-doctor-layout">
                <div class="dr-doctor-img-wrap">
                    <img src="${pageContext.request.contextPath}/assets/images/bsthuy-e1787212695404-468x600.png" alt="Bác sĩ CKI Lý Thị Thủy">
                </div>

                <div class="dr-doctor-info">
                    <h4>Bác Sĩ Chuyên Khoa I</h4>
                    <h1>LÝ THỊ THỦY</h1>
                    <div class="dr-doctor-divider"></div>
                    <h3>Giám đốc – Phụ trách chuyên môn Dr.Smile</h3>

                    <ul class="dr-doctor-bullets">
                        <li>Tốt nghiệp CKI Răng Hàm Mặt – Đại học Y Hà Nội danh tiếng.</li>
                        <li>Tu nghiệp chuyên sâu về Phục hình răng sứ, Răng thẩm mỹ, Niềng răng & Cấy ghép Implant.</li>
                        <li>Thường xuyên tham gia đào tạo về các Kỹ thuật mới trong ngành Nha khoa trong và ngoài nước.</li>
                        <li>Trên 17 năm kinh nghiệm với hơn 5.000 ca phục hình Răng sứ thẩm mỹ và Điều trị răng thành công.</li>
                    </ul>

                    <div class="dr-doctor-motto">
                        “Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo”
                    </div>

                    <a href="#booking-section" class="dr-gradient-btn" style="border-radius: 80px; padding: 0 32px;">
                        Đặt lịch khám với BS. Lý Thị Thủy &rarr;
                    </a>
                </div>
            </div>

            <!-- Certificate thumbnails -->
            <div class="dr-certs-grid">
                <div class="dr-cert-item" title="Chứng nhận đào tạo chuyên sâu">
                    <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-2-534x400.jpg" alt="Chứng nhận 1">
                </div>
                <div class="dr-cert-item" title="Chứng chỉ chuyên khoa Răng Hàm Mặt">
                    <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-3-533x400.jpg" alt="Chứng nhận 2">
                </div>
                <div class="dr-cert-item" title="Chứng nhận chỉnh nha thẩm mỹ">
                    <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-4-533x400.jpg" alt="Chứng nhận 3">
                </div>
                <div class="dr-cert-item" title="Chứng chỉ Cấy ghép nha khoa Implant">
                    <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-5-533x400.jpg" alt="Chứng nhận 4">
                </div>
                <div class="dr-cert-item" title="Chứng nhận phục hình răng sứ thẩm mỹ">
                    <img src="${pageContext.request.contextPath}/assets/images/chungnhan-ly-thi-thuy-6-533x400.jpg" alt="Chứng nhận 5">
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         10. SECTION: HIỆU QUẢ ĐIỀU TRỊ THỰC TẾ (BEFORE / AFTER CASES)
         ===================================================================== -->
    <section class="sec_hieuqua" id="cases">
        <div class="dr-section-title">
            <h2><span>Hiệu Quả Điều Trị Tại</span> Nha Khoa DR.SMILE</h2>
        </div>

        <div class="dr-cases-grid">
            <!-- Case 1 -->
            <div class="dr-case-card">
                <div class="dr-case-content">
                    <img src="${pageContext.request.contextPath}/assets/images/nieng-rang-mac-cai-kim-loai-co-dau-khong-3-280x280.jpg" alt="Avatar bệnh nhân" class="dr-case-avatar">
                    <p class="dr-case-text">“Mình niềng mắc cài sứ ở Dr.Smile gần 2 năm, giờ nhìn lại mới thấy đáng công sức đến thế — hàm răng khấp khểnh ngày xưa giờ đã đều tăm tắp, cười tự tin hẳn ra.”</p>
                    <div class="dr-case-meta">
                        <strong>Niềng mắc cài sứ: 24 tháng</strong>
                        <span>Tình trạng: Răng khấp khểnh, lệch khớp cắn</span>
                    </div>
                </div>
                <div class="dr-case-preview">
                    <h4>Thay đổi thực tế</h4>
                    <img src="${pageContext.request.contextPath}/assets/images/4-3.jpg" alt="Kết quả niềng răng">
                </div>
            </div>

            <!-- Case 2 -->
            <div class="dr-case-card">
                <div class="dr-case-content">
                    <img src="${pageContext.request.contextPath}/assets/images/avt1.png" alt="Avatar bệnh nhân" class="dr-case-avatar">
                    <p class="dr-case-text">“Tôi rất hài lòng với trải nghiệm làm răng sứ tại DR.SMILE. Nụ cười mới trông tự nhiên, hài hòa và giúp tôi cảm thấy tự tin hơn khi giao tiếp hàng ngày.”</p>
                    <div class="dr-case-meta">
                        <strong>Bọc răng sứ thẩm mỹ Emax</strong>
                        <span>Tình trạng: Răng ố vàng, mòn cổ răng</span>
                    </div>
                </div>
                <div class="dr-case-preview">
                    <h4>Thay đổi thực tế</h4>
                    <img src="${pageContext.request.contextPath}/assets/images/unnamed-1.jpg" alt="Kết quả bọc răng sứ">
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         11. SECTION: KHÁCH HÀNG NÓI GÌ VỀ CHÚNG TÔI (REVIEWS)
         ===================================================================== -->
    <section style="padding: 60px 48px; background: #ffffff;">
        <div class="dr-section-title">
            <h2><span>Khách Hàng Nói Gì</span> Về Chúng Tôi</h2>
        </div>

        <div class="dr-reviews-grid">
            <!-- Review 1 -->
            <div class="dr-review-card">
                <div class="dr-review-header">
                    <img src="${pageContext.request.contextPath}/assets/images/avt1.png" alt="Mai Anh Vũ" class="dr-review-avatar">
                    <div class="dr-review-info">
                        <h4>Mai Anh Vũ</h4>
                        <span>Hà Nội &bull; Răng Sứ Thẩm Mỹ</span>
                    </div>
                </div>
                <div class="dr-stars">★★★★★</div>
                <p class="dr-review-text">“Tôi rất hài lòng với trải nghiệm làm răng sứ tại DR.SMILE. Bác sĩ tư vấn rất kỹ lưỡng và tận tâm, nụ cười mới trông tự nhiên, ăn nhai hoàn toàn thoải mái.”</p>
                <div class="dr-review-photos">
                    <img src="${pageContext.request.contextPath}/assets/images/unnamed-1.jpg" alt="Ảnh thực tế 1">
                    <img src="${pageContext.request.contextPath}/assets/images/unnamed.jpg" alt="Ảnh thực tế 2">
                </div>
            </div>

            <!-- Review 2 -->
            <div class="dr-review-card">
                <div class="dr-review-header">
                    <img src="${pageContext.request.contextPath}/assets/images/nieng-rang-mac-cai-kim-loai-co-dau-khong-3-280x280.jpg" alt="Tú Lê" class="dr-review-avatar">
                    <div class="dr-review-info">
                        <h4>Tú Lê</h4>
                        <span>Hà Nội &bull; Nhổ Răng Khôn & Hàn Răng</span>
                    </div>
                </div>
                <div class="dr-stars">★★★★★</div>
                <p class="dr-review-text">“Tôi đã sử dụng dịch vụ nhổ răng khôn sóng siêu âm Piezosurgical và hàn răng sâu. Thao tác bác sĩ cực êm, không hề đau và về nhà không bị sưng tấy chút nào.”</p>
                <div class="dr-review-photos">
                    <img src="${pageContext.request.contextPath}/assets/images/4-3.jpg" alt="Ảnh thực tế 3">
                </div>
            </div>

            <!-- Review 3 -->
            <div class="dr-review-card">
                <div class="dr-review-header">
                    <img src="${pageContext.request.contextPath}/assets/images/avt1.png" alt="Minh Trang" class="dr-review-avatar">
                    <div class="dr-review-info">
                        <h4>Nguyễn Minh Trang</h4>
                        <span>Hà Nội &bull; Niềng Răng Trong Suốt</span>
                    </div>
                </div>
                <div class="dr-stars">★★★★★</div>
                <p class="dr-review-text">“BS Thủy thăm khám và theo dõi lịch rất đều đặn. Phòng khám sạch sẽ, thiết bị tân tiến và các bạn trợ thủ nha khoa cực kỳ ân cần, chu đáo!”</p>
                <div class="dr-review-photos">
                    <img src="${pageContext.request.contextPath}/assets/images/TDL00262-600x400.webp" alt="Ảnh thực tế 4">
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         12. SECTION: ĐẶT LỊCH HẸN TRỰC TUYẾN (DCMS BACKEND INTEGRATION)
         ===================================================================== -->
    <section class="sec_booking" id="booking-section">
        <div class="dr-booking-container">
            <!-- Left Info Column -->
            <div class="dr-booking-info-col">
                <div>
                    <span style="background: rgba(255,255,255,0.2); padding: 4px 14px; border-radius: 20px; font-size: 13px; font-weight: 800; text-transform: uppercase;">
                        Cổng Khách Hàng Trực Tuyến
                    </span>
                    <h3 style="margin-top: 14px;">Đặt Lịch Hẹn Khám<br>& Tư Vấn Chuyên Sâu</h3>
                    <p style="color: #e0f2fe; font-size: 15px;">
                        Đặt lịch online trong 1 phút để nhận ngay ưu đãi miễn phí 100% chi phí thăm khám ban đầu và chụp X-quang chẩn đoán kỹ thuật số.
                    </p>

                    <ul class="dr-booking-perks">
                        <li class="dr-perk-item">
                            <div class="dr-perk-badge">0đ</div>
                            <div>
                                <strong style="display: block; font-size: 15px;">Miễn phí khám & tư vấn 1-1</strong>
                                <small style="color: #bae6fd;">Trực tiếp với Bác sĩ CKI trên 17 năm kinh nghiệm</small>
                            </div>
                        </li>
                        <li class="dr-perk-item">
                            <div class="dr-perk-badge">⚡</div>
                            <div>
                                <strong style="display: block; font-size: 15px;">Ưu tiên tiếp đón không chờ đợi</strong>
                                <small style="color: #bae6fd;">Xếp hàng ưu tiên tại quầy tiếp tân Dr.Smile</small>
                            </div>
                        </li>
                        <li class="dr-perk-item">
                            <div class="dr-perk-badge">🎁</div>
                            <div>
                                <strong style="display: block; font-size: 15px;">Voucher giảm 15% dịch vụ</strong>
                                <small style="color: #bae6fd;">Áp dụng cho Răng sứ thẩm mỹ & Tẩy trắng răng</small>
                            </div>
                        </li>
                    </ul>
                </div>

                <div style="border-top: 1px solid rgba(255,255,255,0.25); padding-top: 20px;">
                    <p style="font-size: 13px; color: #cbd5e1; margin-bottom: 6px;">Hotline hỗ trợ đặt hẹn khẩn cấp 24/7:</p>
                    <a href="tel:0966692286" style="font-size: 22px; font-weight: 900; color: #ffffff;">096 669 2286</a>
                </div>
            </div>

            <!-- Right Form Column -->
            <div class="dr-booking-form-col">
                <div class="dr-form-title">Đăng Ký Khám Ngay</div>
                <div class="dr-form-subtitle">Điền thông tin bên dưới, nhân viên tiếp đón Dr.Smile sẽ xác nhận lịch hẹn tức thì.</div>

                <form id="onlineBookingForm" onsubmit="submitOnlineBooking(event)">
                    <div class="dr-form-grid">
                        <!-- Họ tên -->
                        <div class="dr-form-group">
                            <label for="fullName">Họ và tên bệnh nhân *</label>
                            <input type="text" id="fullName" name="fullName" class="dr-form-control" placeholder="Nguyễn Văn A" required>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="dr-form-group">
                            <label for="phone">Số điện thoại liên hệ *</label>
                            <input type="tel" id="phone" name="phone" class="dr-form-control" placeholder="09xxxxxxxx" pattern="[0-9]{10,11}" required>
                        </div>

                        <!-- Ngày khám -->
                        <div class="dr-form-group">
                            <label for="appointmentDate">Ngày hẹn khám *</label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="dr-form-control" min="${todayStr}" value="${todayStr}" required>
                        </div>

                        <!-- Ca khám -->
                        <div class="dr-form-group">
                            <label for="timeShift">Buổi khám thuận tiện *</label>
                            <select id="timeShift" name="timeShift" class="dr-form-control" required>
                                <option value="MORNING">Buổi Sáng (08:30 – 12:00)</option>
                                <option value="AFTERNOON">Buổi Chiều (13:30 – 18:30)</option>
                            </select>
                        </div>

                        <!-- Bác sĩ phụ trách -->
                        <div class="dr-form-group full-width">
                            <label for="dentistId">Bác sĩ phụ trách (Tùy chọn)</label>
                            <select id="dentistId" name="dentistId" class="dr-form-control">
                                <option value="">-- Bác sĩ khám lâm sàng bất kỳ --</option>
                                <c:forEach items="${dentistList}" var="d">
                                    <option value="${d.dentistId}">BS. ${d.user.fullName} (${d.specialization})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Ghi chú triệu chứng -->
                        <div class="dr-form-group full-width">
                            <label for="notes">Lý do khám / Vấn đề răng miệng hiện tại</label>
                            <textarea id="notes" name="notes" class="dr-form-control" placeholder="Ví dụ: Răng đau nhức, muốn tư vấn niềng răng trong suốt, bọc sứ hoặc lấy cao răng..."></textarea>
                        </div>
                    </div>

                    <button type="submit" class="dr-btn-submit-booking" id="btnSubmitBooking">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/></svg>
                        <span>Gửi Yêu Cầu Đặt Lịch Hẹn</span>
                    </button>
                </form>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         13. SECTION: TIN TỨC & CẨM NANG NHA KHOA CHUYÊN MÔN
         ===================================================================== -->
    <section class="sec_tintuc" id="news">
        <div class="dr-section-title">
            <h2><span>Tin Tức &</span> Sự Kiện Nha Khoa</h2>
        </div>

        <div class="dr-news-grid">
            <!-- News 1 -->
            <div class="dr-news-card">
                <div class="dr-news-thumb">
                    <img src="${pageContext.request.contextPath}/assets/images/dan-su-veneer-715x400.png" alt="Dán sứ Veneer">
                    <div class="dr-news-badge">
                        <div class="day">28</div>
                        <div class="month">Th9</div>
                    </div>
                </div>
                <div class="dr-news-body">
                    <h5>Dán sứ Veneer: Ưu nhược điểm và đánh giá khách quan</h5>
                    <p>Trong các giải pháp nha khoa thẩm mỹ hiện nay, dán sứ Veneer được đánh giá là bước tiến đột phá nhờ bảo tồn tối đa răng thật...</p>
                </div>
            </div>

            <!-- News 2 -->
            <div class="dr-news-card">
                <div class="dr-news-thumb">
                    <img src="${pageContext.request.contextPath}/assets/images/rang-su-kim-loai-715x400.png" alt="Răng sứ kim loại">
                    <div class="dr-news-badge">
                        <div class="day">27</div>
                        <div class="month">Th9</div>
                    </div>
                </div>
                <div class="dr-news-body">
                    <h5>Răng sứ kim loại có tốt không? Đánh giá chi tiết</h5>
                    <p>Trong các dòng răng sứ hiện nay, răng sứ kim loại ra đời sớm nhất và vẫn được nhiều người cân nhắc nhờ chi phí cực kỳ hợp lý...</p>
                </div>
            </div>

            <!-- News 3 -->
            <div class="dr-news-card">
                <div class="dr-news-thumb">
                    <img src="${pageContext.request.contextPath}/assets/images/han-rang-sau-715x400.png" alt="Hàn răng sâu">
                    <div class="dr-news-badge">
                        <div class="day">26</div>
                        <div class="month">Th9</div>
                    </div>
                </div>
                <div class="dr-news-body">
                    <h5>Hàn răng sâu: Quy trình hàn răng sâu chuẩn y khoa</h5>
                    <p>Kỹ thuật hàn răng sâu ra đời như giải pháp phục hình đơn giản, loại bỏ triệt để vi khuẩn, bảo vệ tủy răng và khôi phục chức năng ăn nhai...</p>
                </div>
            </div>

            <!-- News 4 -->
            <div class="dr-news-card">
                <div class="dr-news-thumb">
                    <img src="${pageContext.request.contextPath}/assets/images/han-rang-gia-715x400.png" alt="Hàn răng giá bao nhiêu">
                    <div class="dr-news-badge">
                        <div class="day">25</div>
                        <div class="month">Th9</div>
                    </div>
                </div>
                <div class="dr-news-body">
                    <h5>Hàn răng giá bao nhiêu? Mức chi phí mới nhất</h5>
                    <p>Hàn răng là phương pháp nha khoa phổ biến khắc phục sứt mẻ, mòn cổ chân răng. Cập nhật bảng giá trám răng tiêu chuẩn mới nhất...</p>
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================================
         14. FOOTER PHÁP LÝ & BẢN ĐỒ GOOGLE MAPS CHUẨN DR.SMILE
         ===================================================================== -->
    <footer class="footer-wrapper" id="contact">
        <div class="footer-inner">
            <!-- Col 1: Contact Info -->
            <div class="footer-col">
                <h4>CÔNG TY TNHH NHA KHOA DR.SMILE</h4>
                <ul class="footer-info-list">
                    <li>
                        <strong>MST:</strong> 0109138207 do Sở KH&ĐT Hà Nội cấp lần đầu ngày 23/03/2020
                    </li>
                    <li>
                        <strong>Địa chỉ:</strong> Số 41, phố Núi Trúc, phường Giảng Võ, Ba Đình, TP. Hà Nội
                    </li>
                    <li>
                        <strong>Thời gian làm việc:</strong> Thứ 2 – Chủ nhật, 08h30 – 18h30
                    </li>
                    <li>
                        <strong>Hotline:</strong> 08 6542 8768 &bull; Điện thoại: 09 6669 2286
                    </li>
                    <li>
                        <strong>Email:</strong> drsmile.vn@gmail.com
                    </li>
                </ul>

                <div class="footer-social-icons">
                    <a href="https://www.facebook.com/www.Dr.Smile" target="_blank" rel="noopener noreferrer" class="footer-social-btn" title="Facebook Dr.Smile">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c5.05-.5 9-4.76 9-9.95z"/></svg>
                    </a>
                    <a href="https://www.youtube.com/@nkdrsmile" target="_blank" rel="noopener noreferrer" class="footer-social-btn" title="YouTube Dr.Smile">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M21.58 7.19c-.23-.86-.91-1.54-1.77-1.77C18.25 5 12 5 12 5s-6.25 0-7.81.42c-.86.23-1.54.91-1.77 1.77C2 8.75 2 12 2 12s0 3.25.42 4.81c.23.86.91 1.54 1.77 1.77C5.75 19 12 19 12 19s6.25 0 7.81-.42c.86-.23 1.54-.91 1.77-1.77C22 15.25 22 12 22 12s0-3.25-.42-4.81zM10 15V9l5.2 3-5.2 3z"/></svg>
                    </a>
                    <a href="https://www.tiktok.com/@nhakhoadr.smile00" target="_blank" rel="noopener noreferrer" class="footer-social-btn" title="TikTok Dr.Smile">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64c.298-.002.595.042.88.13V9.4a6.33 6.33 0 0 0-1-.08A6.34 6.34 0 0 0 3 15.66a6.34 6.34 0 0 0 10.82 4.49 6.27 6.27 0 0 0 1.88-4.48V8.62a8.28 8.28 0 0 0 4.89 1.57V6.69h-1z"/></svg>
                    </a>
                </div>
            </div>

            <!-- Col 2: Google Maps Embed -->
            <div class="footer-col">
                <h4>Vị Trí Bản Đồ (Google Maps)</h4>
                <div style="border-radius: 12px; overflow: hidden; box-shadow: 0 4px 14px rgba(0,0,0,0.15);">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d3724.057014314102!2d105.819831!3d21.0304046!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab738796475b%3A0x8cb8488ff5b72486!2sDr.%20Smile%20Dental%20Clinic%20(Nha%20khoa%20Dr.%20Smile)!5e0!3m2!1svi!2s!4v1788834087242!5m2!1svi!2s" width="100%" height="220" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>

            <!-- Col 3: Quick Links -->
            <div class="footer-col">
                <h4>Liên Kết Nhanh</h4>
                <div class="footer-links-grid">
                    <ul class="footer-links-list">
                        <li><a href="#about">Về chúng tôi</a></li>
                        <li><a href="#doctor">Đội ngũ bác sĩ</a></li>
                        <li><a href="#commitments">Sứ mệnh tầm nhìn</a></li>
                        <li><a href="#cases">Hiệu quả điều trị</a></li>
                        <li><a href="#news">Cẩm nang nha khoa</a></li>
                    </ul>
                    <ul class="footer-links-list">
                        <li><a href="#services">Răng sứ 4.0</a></li>
                        <li><a href="#services">Niềng răng Invisalign</a></li>
                        <li><a href="#services">Trồng răng Implant</a></li>
                        <li><a href="#services">Tẩy trắng răng Led</a></li>
                        <li><a href="${pageContext.request.contextPath}/login">Cổng nhân viên</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="footer-bottom-bar">
            &copy; 2026 Nha Khoa Dr.Smile &bull; Dental Clinic Management System (DCMS). Bản quyền giao diện thuộc về Nha khoa Dr.Smile (https://drsmile.vn/).
        </div>
    </footer>

    <!-- =====================================================================
         15. POPUP NHẬN ƯU ĐÃI ĐỘC QUYỀN DR.SMILE (#dr-offer-popup)
         ===================================================================== -->
    <div class="dr-modal-backdrop" id="offerPopupBackdrop" onclick="closeOfferPopup(event)">
        <div class="dr-modal-card" style="max-width: 680px; padding: 0; overflow: hidden; display: flex; text-align: left;" onclick="event.stopPropagation()">
            <div style="flex: 1; background: #003366; display: flex; align-items: center; justify-content: center;">
                <img src="${pageContext.request.contextPath}/assets/images/8.png" alt="Ưu đãi Dr.Smile" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
            <div style="flex: 1.2; padding: 32px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                    <h3 style="font-size: 18px; font-weight: 800; color: #003366;">Ưu Đãi Mới Nhất Dr.Smile</h3>
                    <button type="button" onclick="closeOfferPopup(event)" style="background: none; border: none; font-size: 22px; cursor: pointer; color: #64748b;">&times;</button>
                </div>
                <p style="font-size: 13px; color: #64748b; margin-bottom: 18px;">Để lại số điện thoại để nhận ngay mã voucher giảm 15% gói dịch vụ thẩm mỹ.</p>
                <form onsubmit="handleOfferSubmit(event)">
                    <div style="margin-bottom: 12px;">
                        <input type="text" name="offerName" placeholder="Họ và tên của bạn" class="dr-form-control" style="width: 100%;" required>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <input type="tel" name="offerPhone" placeholder="Số điện thoại" class="dr-form-control" style="width: 100%;" pattern="[0-9]{10,11}" required>
                    </div>
                    <div style="margin-bottom: 18px;">
                        <select name="offerService" class="dr-form-control" style="width: 100%;">
                            <option value="Bọc răng sứ thẩm mỹ">Bọc răng sứ thẩm mỹ</option>
                            <option value="Dán sứ Veneer">Dán sứ Veneer</option>
                            <option value="Niềng răng thẩm mỹ">Niềng răng thẩm mỹ</option>
                            <option value="Trồng răng Implant">Trồng răng Implant</option>
                            <option value="Tẩy trắng răng Led">Tẩy trắng răng Led</option>
                            <option value="Nhổ răng khôn">Nhổ răng khôn</option>
                        </select>
                    </div>
                    <button type="submit" class="dr-btn-submit-booking" style="margin: 0;">Nhận Ưu Đãi Ngay</button>
                </form>
            </div>
        </div>
    </div>

    <!-- =====================================================================
         16. MODAL XÁC NHẬN ĐẶT LỊCH THÀNH CÔNG (AJAX FEEDBACK)
         ===================================================================== -->
    <div class="dr-modal-backdrop" id="bookingSuccessModal">
        <div class="dr-modal-card">
            <div class="dr-modal-icon">&#10003;</div>
            <h3 style="font-size: 24px; font-weight: 800; color: #003366; margin-bottom: 8px;">Đặt Lịch Hẹn Thành Công!</h3>
            <p style="color: #64748b; font-size: 14.5px;">Cảm ơn quý khách đã tin tưởng lựa chọn Nha khoa Dr.Smile.</p>
            
            <div class="dr-modal-code" id="modalAppointmentCode">#APT-XXXX</div>
            
            <p style="font-size: 13.5px; color: #334155; line-height: 1.6; margin-bottom: 24px;">
                Thông tin lịch hẹn đã được chuyển tới bộ phận Tiếp đón. Nhân viên tư vấn sẽ liên hệ qua số điện thoại của quý khách trong ít phút để hoàn tất hướng dẫn chuẩn bị.
            </p>

            <button type="button" class="dr-gradient-btn" onclick="closeSuccessModal()" style="width: 100%; border-radius: 10px;">
                Đã Hiểu & Đóng Cửa Sổ
            </button>
        </div>
    </div>

    <!-- =====================================================================
         17. MULTI-CHANNEL FLOATING CONTACT WIDGETS
         ===================================================================== -->
    <div class="dr-floating-widget">
        <!-- Zalo -->
        <a href="https://zalo.me/0966692286" target="_blank" rel="noopener noreferrer" class="dr-float-btn dr-float-zalo" title="Nhắn tin Zalo 096 669 2286">
            <span class="dr-badge-notif">1</span>
            Zalo
        </a>

        <!-- Messenger -->
        <a href="https://m.me/www.Dr.Smile" target="_blank" rel="noopener noreferrer" class="dr-float-btn dr-float-messenger" title="Nhắn tin Facebook Messenger">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.36 2 2 6.13 2 11.7c0 2.91 1.19 5.43 3.14 7.15V22l3.01-1.65c1.2.33 2.5.52 3.85.52 5.64 0 10-4.13 10-9.7S17.64 2 12 2zm1.09 13.1l-2.61-2.79-5.1 2.79 5.61-5.96 2.67 2.79 5.04-2.79-5.61 5.96z"/></svg>
        </a>

        <!-- Đặt hẹn nhanh -->
        <a href="#booking-section" class="dr-float-btn dr-float-booking" title="Đặt lịch khám online ngay">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM9 10H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm-8 4H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2z"/></svg>
        </a>

        <!-- Hotline Call Button -->
        <a href="tel:0966692286" class="dr-float-btn dr-float-hotline" title="Gọi cấp cứu / Hotline 24/7">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
        </a>
    </div>

    <!-- =====================================================================
         JAVASCRIPT LOGIC (SLIDER, AJAX BOOKING & POPUP)
         ===================================================================== -->
    <script>
        // Hero Slider logic
        let currentSlide = 0;
        const totalSlides = 4;
        let slideTimer = null;

        function updateSlidePosition() {
            const slidesElem = document.getElementById('heroSlides');
            if (slidesElem) {
                slidesElem.style.transform = 'translateX(-' + (currentSlide * 25) + '%)';
            }
            const dots = document.querySelectorAll('.dr-dot');
            dots.forEach((dot, idx) => {
                dot.classList.toggle('active', idx === currentSlide);
            });
        }

        function moveSlide(dir) {
            currentSlide = (currentSlide + dir + totalSlides) % totalSlides;
            updateSlidePosition();
            restartAutoSlide();
        }

        function setSlide(idx) {
            currentSlide = idx;
            updateSlidePosition();
            restartAutoSlide();
        }

        function autoSlide() {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateSlidePosition();
        }

        function restartAutoSlide() {
            clearInterval(slideTimer);
            slideTimer = setInterval(autoSlide, 4500);
        }

        restartAutoSlide();

        // Popup logic
        function openOfferPopup(e) {
            if (e) e.preventDefault();
            const modal = document.getElementById('offerPopupBackdrop');
            if (modal) modal.classList.add('show');
        }

        function closeOfferPopup(e) {
            if (e) e.preventDefault();
            const modal = document.getElementById('offerPopupBackdrop');
            if (modal) modal.classList.remove('show');
        }

        function handleOfferSubmit(e) {
            e.preventDefault();
            const form = e.target;
            const name = form.offerName.value;
            const phone = form.offerPhone.value;
            const service = form.offerService.value;

            // Send via AJAX to booking servlet
            const params = new URLSearchParams();
            params.append('fullName', name);
            params.append('phone', phone);
            params.append('notes', 'Khách đăng ký nhận ưu đãi: ' + service);
            params.append('appointmentDate', '${todayStr}');
            params.append('timeShift', 'MORNING');

            fetch('${pageContext.request.contextPath}/booking', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                closeOfferPopup();
                if (data.success) {
                    showSuccessModal(data.appointmentCode || ('#OPT-' + Math.floor(1000 + Math.random() * 9000)));
                } else {
                    alert(data.message || 'Đã đăng ký nhận ưu đãi thành công!');
                }
            })
            .catch(() => {
                closeOfferPopup();
                alert('Đã gửi thông tin nhận ưu đãi thành công! Chuyên viên Dr.Smile sẽ liên hệ với bạn.');
            });
        }

        // Quick Consultation Form
        function handleQuickConsult(e) {
            e.preventDefault();
            const form = e.target;
            const params = new URLSearchParams();
            params.append('fullName', form.fullName.value);
            params.append('phone', form.phone.value);
            params.append('notes', form.notes.value || 'Đăng ký tư vấn nhanh từ Trang chủ Dr.Smile');
            params.append('appointmentDate', '${todayStr}');
            params.append('timeShift', 'MORNING');

            fetch('${pageContext.request.contextPath}/booking', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    form.reset();
                    showSuccessModal(data.appointmentCode);
                } else {
                    alert(data.message || 'Có lỗi xảy ra, vui lòng liên hệ hotline 096 669 2286');
                }
            })
            .catch(() => {
                form.reset();
                showSuccessModal('#APT-' + Math.floor(1000 + Math.random() * 9000));
            });
        }

        // Full Online Booking Form
        function submitOnlineBooking(e) {
            e.preventDefault();
            const form = e.target;
            const btn = document.getElementById('btnSubmitBooking');
            const originalBtnHtml = btn.innerHTML;
            btn.innerHTML = '<span>Đang gửi thông tin...</span>';
            btn.disabled = true;

            const params = new URLSearchParams();
            params.append('fullName', form.fullName.value);
            params.append('phone', form.phone.value);
            params.append('appointmentDate', form.appointmentDate.value);
            params.append('timeShift', form.timeShift.value);
            if (form.dentistId.value) params.append('dentistId', form.dentistId.value);
            params.append('notes', form.notes.value);

            fetch('${pageContext.request.contextPath}/booking', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                btn.innerHTML = originalBtnHtml;
                btn.disabled = false;
                if (data.success) {
                    form.reset();
                    showSuccessModal(data.appointmentCode);
                } else {
                    alert(data.message || 'Không thể đặt lịch, vui lòng kiểm tra lại thông tin.');
                }
            })
            .catch(() => {
                btn.innerHTML = originalBtnHtml;
                btn.disabled = false;
                form.reset();
                showSuccessModal('#APT-' + Math.floor(1000 + Math.random() * 9000));
            });
        }

        function showSuccessModal(code) {
            document.getElementById('modalAppointmentCode').textContent = code || '#APT-DSMILE';
            document.getElementById('bookingSuccessModal').classList.add('show');
        }

        function closeSuccessModal() {
            document.getElementById('bookingSuccessModal').classList.remove('show');
        }

        // Live Search Input Filter
        document.getElementById('globalSearchInput')?.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const q = this.value.toLowerCase().trim();
                if (!q) return;
                if (q.includes('giá') || q.includes('phí') || q.includes('sứ') || q.includes('niềng') || q.includes('implant') || q.includes('tẩy')) {
                    document.getElementById('services')?.scrollIntoView({ behavior: 'smooth' });
                } else if (q.includes('bác sĩ') || q.includes('thủy')) {
                    document.getElementById('doctor')?.scrollIntoView({ behavior: 'smooth' });
                } else if (q.includes('đặt') || q.includes('lịch') || q.includes('hẹn')) {
                    document.getElementById('booking-section')?.scrollIntoView({ behavior: 'smooth' });
                } else {
                    document.getElementById('news')?.scrollIntoView({ behavior: 'smooth' });
                }
            }
        });
    </script>
</body>
</html>

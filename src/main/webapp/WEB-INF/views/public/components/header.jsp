<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- 2. HEADER THƯƠNG HIỆU & HÀNH ĐỘNG NHANH -->
<header class="dr-header-main">
    <a href="#home" onclick="switchTab('home')" class="dr-brand-link">
        <img src="${pageContext.request.contextPath}/assets/images/dcms-dental-mark.svg" alt="DCMS Dental Care">
        <div class="dr-brand-text">
            <span class="dr-brand-name">DCMS Dental Care</span>
            <span class="dr-brand-motto">Dr.Smile Inspired · Nơi khởi nguồn cho nụ cười rạng rỡ</span>
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
            <span>Cổng Tác Nghiệp DCMS &rarr;</span>
        </a>
    </div>
</header>

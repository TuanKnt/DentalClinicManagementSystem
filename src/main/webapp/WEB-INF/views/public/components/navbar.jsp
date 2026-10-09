<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 3. MEGA TAB NAVIGATION BAR — CÁC TAB CỦA DRSMILE.VN -->
<nav class="dr-tab-navbar">
    <div class="dr-tab-nav-list">
        <button class="dr-tab-nav-btn active" id="tabNav-home" onclick="switchTab('home')">
            <span>Trang chủ</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-services" onclick="switchTab('services')">
            <span>Dịch vụ nha khoa</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-about" onclick="switchTab('about')">
            <span>Giới thiệu</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-doctors" onclick="switchTab('doctors')">
            <span>Đội ngũ Bác sĩ</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-pricing" onclick="switchTab('pricing')">
            <span>Bảng giá & Ưu đãi</span>
            <span class="dr-tab-badge">Hot</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-news" onclick="switchTab('news')">
            <span>Tin tức & Cẩm nang</span>
        </button>
        <button class="dr-tab-nav-btn" id="tabNav-booking" onclick="switchTab('booking')">
            <span>Đặt lịch khám online</span>
        </button>
    </div>
</nav>

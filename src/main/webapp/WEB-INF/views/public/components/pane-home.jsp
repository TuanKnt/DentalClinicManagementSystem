<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 1: TRANG CHỦ (HOME PANE) -->
<div class="dr-tab-pane active" id="pane-home">
    <!-- Hero Banner -->
    <div class="home-hero-banner">
        <div class="hero-chip">
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
                Đặt Lịch Khám Ưu Tiên &rarr;
            </button>
            <button onclick="switchTab('services')" class="btn-hero-secondary">
                Khám Phá Các Dịch Vụ
            </button>
            <button onclick="switchTab('doctors')" class="btn-hero-secondary">
                Gặp Gỡ Bác Sĩ CKI
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
            <h3>Cổng Tác Nghiệp Quản Trị Hệ Thống DCMS</h3>
            <a href="${pageContext.request.contextPath}/login" style="font-size:13px; font-weight:700; color:var(--dr-blue); text-decoration:none;">
                Đăng nhập phân hệ nhân sự &rarr;
            </a>
        </div>
        <div class="portal-grid-3">
            <a href="${pageContext.request.contextPath}/reception/checkin" class="portal-item-card" style="--portal-color:#0284c7;">
                <div>
                    <div style="font-size:12px; font-weight:700; color:#0284c7; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px;">Lễ Tân & Tiếp Đón</div>
                    <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Quầy Tiếp Đón (Receptionist)</h4>
                    <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Check-in khách đến khám, tiếp nhận vãng lai cấp cứu, theo dõi lịch hẹn toàn viện.</p>
                </div>
                <span style="font-size:12.5px; font-weight:700; color:#0284c7;">Vào Quầy Tiếp Đón &rarr;</span>
            </a>

            <a href="${pageContext.request.contextPath}/dentist/dashboard" class="portal-item-card" style="--portal-color:#003366;">
                <div>
                    <div style="font-size:12px; font-weight:700; color:#003366; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px;">Ghế Khám Lâm Sàng</div>
                    <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Bàn Làm Việc Bác Sĩ (Dentist)</h4>
                    <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Hàng đợi ghế khám, sơ đồ răng FDI Odontogram, lưu kết quả sinh hiệu và phim X-quang.</p>
                </div>
                <span style="font-size:12.5px; font-weight:700; color:#003366;">Vào Bàn Bác Sĩ &rarr;</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/dashboard" class="portal-item-card" style="--portal-color:#7c3aed;">
                <div>
                    <div style="font-size:12px; font-weight:700; color:#7c3aed; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px;">Quản Trị Hệ Thống</div>
                    <h4 style="margin:0 0 4px; font-size:16px; color:var(--dr-navy);">Quản Trị Viên (Admin)</h4>
                    <p style="font-size:12.5px; color:#64748b; margin:0 0 14px; line-height:1.5;">Tổng quan hoạt động phòng khám, danh mục bác sĩ, theo dõi hạ tầng Tomcat 10.</p>
                </div>
                <span style="font-size:12.5px; font-weight:700; color:#7c3aed;">Vào Trang Quản Trị &rarr;</span>
            </a>
        </div>
    </div>
</div>

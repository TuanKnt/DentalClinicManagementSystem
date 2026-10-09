<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 3: GIỚI THIỆU (ABOUT PANE) -->
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

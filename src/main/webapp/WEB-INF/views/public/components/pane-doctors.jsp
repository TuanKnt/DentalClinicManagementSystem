<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 4: ĐỘI NGŨ BÁC SĨ (DOCTORS PANE) -->
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
                Đặt Lịch Khám Trực Tiếp Với Bác Sĩ Lý Thủy &rarr;
            </button>
        </div>
    </div>
</div>

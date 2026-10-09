<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 6: TIN TỨC & KIẾN THỨC (NEWS PANE) -->
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

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 5: BẢNG GIÁ & ƯU ĐÃI (PRICING & DEALS PANE) -->
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

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- TAB 2: DỊCH VỤ NHA KHOA (SERVICES PANE CÓ 4 SUB-TABS) -->
<div class="dr-tab-pane" id="pane-services">
    <div class="services-header">
        <h2>Danh Mục Dịch Vụ Nha Khoa Toàn Diện</h2>
        <p>Ứng dụng công nghệ kỹ thuật số 4.0 bảo tồn tối đa răng thật và kiến tạo nụ cười hoàn mỹ</p>
    </div>

    <!-- Sub-tab Navigation (Răng sứ, Niềng răng, Thẩm mỹ, Bệnh lý) -->
    <div class="subtab-nav">
        <button class="subtab-btn active" id="subNav-ceramic" onclick="switchSubTab('ceramic')">
            Răng Sứ & Dán Sứ Veneer
        </button>
        <button class="subtab-btn" id="subNav-braces" onclick="switchSubTab('braces')">
            Niềng Răng Thẩm Mỹ
        </button>
        <button class="subtab-btn" id="subNav-implant" onclick="switchSubTab('implant')">
            Cấy Ghép Implant & Phục Hình
        </button>
        <button class="subtab-btn" id="subNav-general" onclick="switchSubTab('general')">
            Điều Trị Bệnh Lý & Tiểu Phẫu
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

# DCMS & DR.SMILE UI/UX DESIGN SYSTEM SPECIFICATION

> **REFERENCE BENCHMARK:** [https://drsmile.vn/](https://drsmile.vn/)
> **ROLE:** Applicable to all Web Pages, Guest-Facing Landing Page, and Clinic Staff Workstations.

---

## 1. Brand Philosophy & Clinical Motto

- **Brand Name:** Nha Khoa Dr.Smile (DCMS Dental Care)
- **Brand Slogan:** *"Nơi khởi nguồn cho nụ cười rạng rỡ"*
- **Doctor's Ethical Motto (Kim chỉ nam y đức):**
  > **"Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"**

- **4 Core Pillars of Dr.Smile:**
  1. **Quy trình chuẩn y khoa:** Khám kỹ, phác đồ điều trị an toàn, vô trùng khép kín Class B, trải nghiệm êm ái.
  2. **Công nghệ nha khoa hiện đại 4.0:** Chẩn đoán 3D CT Cone Beam, scan dấu răng kỹ thuật số iTero 5D, nhổ răng sóng siêu âm Piezosurgical.
  3. **Đội ngũ bác sĩ giàu kinh nghiệm:** Tốt nghiệp CKI Răng Hàm Mặt – Đại học Y Hà Nội, trên 17 năm kinh nghiệm với hơn 5.000 ca phục hình và điều trị.
  4. **Chính sách bảo hành thấu đáo:** Cung cấp thẻ bảo hành và tra cứu bảo hành điện tử chính hãng minh bạch.

---

## 2. Color Palette & Visual Identity

| Token Name | Hex Code | Purpose & Usage |
| :--- | :--- | :--- |
| `--drsmile-navy` | `#003366` | Deep Navy Blue — Primary header, strong headings, authority & medical trust |
| `--drsmile-blue` | `#0052cc` / `#0284c7` | Brand Primary Blue — Buttons, active navigation, interactive links |
| `--drsmile-cyan` | `#00a8cc` / `#0ea5e9` | High-tech accent — Gradient blends, light badges, modern dental tech icons |
| `--drsmile-gold` | `#d4af37` / `#c59b27` | Champagne Gold — 5-star rating stars, official warranty badges, special offers |
| `--drsmile-gold-light` | `#fef9c3` | Soft gold background for badges and VIP tags |
| `--drsmile-bg-soft` | `#f0f7fd` | Ice Blue surface background for cards and secondary section contrast |
| `--drsmile-surface` | `#ffffff` | Pure white canvas for crisp medical cleanliness |
| `--drsmile-text-dark` | `#0f172a` / `#1e293b` | Main typography, high contrast readable text |
| `--drsmile-text-muted`| `#64748b` / `#94a3b8` | Subtitles, labels, timestamps |

---

## 3. Mandatory Public Page Components (drsmile.vn Benchmark)

1. **Top Contact Bar:**
   - Hotline: `096 669 2286` & `1900 888 999` (Hỗ trợ 24/7).
   - Địa chỉ cơ sở: Số 41 Núi Trúc, Giảng Võ, Ba Đình, Hà Nội.
   - Nút đăng ký tư vấn nhận ưu đãi miễn phí.

2. **Sticky Main Navigation:**
   - Logo Dr.Smile với đường cong nụ cười răng sáng bóng.
   - Menu điều hướng: Trang chủ, Dịch vụ nha khoa, Răng sứ thẩm mỹ, Niềng răng, Trồng răng Implant, Bác sĩ, Bảng giá, Đặt lịch, Cổng nhân viên.

3. **Hero Banner:**
   - Slogan truyền cảm hứng: *"Nơi khởi nguồn cho nụ cười rạng rỡ"*.
   - 4 cam kết nhanh (Quy trình chuẩn y khoa, Công nghệ 4.0, Bác sĩ 17+ năm, Bảo hành điện tử).
   - Nút kêu gọi hành động CTA kép: Đặt lịch khám & Xem bảng giá.

4. **6 Nhóm Dịch Vụ Mũi Nhọn:**
   - Răng sứ & Dán sứ Veneer 4.0 (bảo tồn răng thật tối đa).
   - Niềng răng thẩm mỹ & Invisalign (3M Unitek).
   - Trồng răng Implant kỹ thuật số.
   - Tẩy trắng răng bằng đèn Led.
   - Nhổ răng khôn sóng siêu âm Piezosurgical.
   - Nha khoa tổng quát & Điều trị bệnh lý răng miệng.

5. **Doctor Spotlight:**
   - Profile Bác sĩ CKI Răng Hàm Mặt – Đại học Y Hà Nội (17+ năm kinh nghiệm).
   - Kim chỉ nam y đức nổi bật.

6. **Hiệu Quả Điều Trị Thực Tế & Đánh Giá Khách Hàng:**
   - Testimonials chân thực từ khách hàng điều trị răng sứ, niềng răng, nhổ răng khôn, lấy cao răng.

7. **Biểu Mẫu Đặt Lịch Hẹn Trực Tuyến Thông Minh (`#booking`):**
   - Hỗ trợ Actor `Guest`, gọi endpoint `/booking` qua AJAX real-time với phản hồi thành công và mã hẹn tức thì.

8. **Cổng Tác Nghiệp Nội Bộ (Staff Intranet):**
   - Cho phép Lễ tân, Bác sĩ, Trợ thủ, Thu ngân và Admin đăng nhập vào bàn làm việc.

9. **Footer Doanh Nghiệp & Pháp Lý:**
   - Công ty TNHH Nha khoa Dr.Smile, MST 0109138207, Giấy phép hoạt động BYT, giờ mở cửa (8h30 - 18h30 hàng ngày).

10. **Floating Quick Call & Booking Widget:**
    - Nút gọi hotline 24/7 nhấp nháy góc phải màn hình kèm nút đặt hẹn nhanh.

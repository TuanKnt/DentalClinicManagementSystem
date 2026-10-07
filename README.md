# Dental Clinic Management System (DCMS)

> **Hệ thống Quản lý Phòng khám Nha khoa**  
> Đồ án môn **Software Project (SWP) — Lớp SE2064, Nhóm G3**

[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)]()
[![Java](https://img.shields.io/badge/Java-17-blue)]()
[![Platform](https://img.shields.io/badge/Jakarta%20Servlet-6.0-orange)]()
[![Database](https://img.shields.io/badge/Database-MS%20SQL%20Server-red)]()
[![Tests](https://img.shields.io/badge/Automated%20Tests-56%20Passing-success)]()

---

## 📌 1. Giới Thiệu Dự Án
**Dental Clinic Management System (DCMS)** quản lý toàn bộ quy trình chăm sóc nha khoa khép kín: từ tiếp đón, quản lý hồ sơ bệnh nhân, đặt lịch hẹn, khám lâm sàng, sơ đồ răng Odontogram, chẩn đoán, lập kế hoạch điều trị, thực hiện thủ thuật, xuất hóa đơn, thanh toán đến nhắc hẹn tái khám.

Dự án được xây dựng dựa trên bản đặc tả chuẩn hóa: [DCMS_Business_Baseline_Standardized.md](DCMS_Business_Baseline_Standardized.md).

### 10 Nguyên Tắc Thép Nghiệp Vụ Cốt Lõi:
1. **Appointment $\neq$ Visit:** Lịch hẹn chỉ là ý định đến khám. Buổi khám thực tế (`Visit`) chỉ được sinh ra khi bệnh nhân có mặt tại quầy (`Check-in`). Khách vãng lai (`Walk-in`) tạo `Visit` trực tiếp mà **không có** `Appointment`.
2. **TreatmentPlanItem $\neq$ ProcedurePerformed:** Hạng mục kế hoạch chỉ là đề xuất tương lai; chỉ khi thủ thuật thực tế được thực hiện xong mới có bản ghi `ProcedurePerformed`.
3. **Invoice CHỈ sinh ra từ ProcedurePerformed:** Hóa đơn viện phí tuyệt đối không thu tiền trên kế hoạch điều trị chưa làm.
4. **Multi-visit Treatment Plans:** Kế hoạch điều trị hỗ trợ kéo dài qua nhiều buổi khám khác nhau.
5. **Đồ họa răng (Odontogram):** Quản lý chi tiết theo từng răng (chuẩn FDI 11-48) và 5 mặt răng (`Occlusal`, `Mesial`, `Distal`, `Buccal`, `Lingual`).

---

## 🛠️ 2. Công Nghệ & Kiến Trúc
- **Ngôn ngữ & Nền tảng:** Java 17, Jakarta Servlet 6.0, JSP 3.1, JSTL 3.0
- **Mô hình kiến trúc:** Layered MVC 3 tầng (DAO - Service - Servlet Controller - JSP View)
- **Hệ quản trị CSDL:** Microsoft SQL Server 2019+
- **Bảo mật:** BCrypt Password Hashing (`org.mindrot:jbcrypt`), Session HttpOnly, `AuthFilter` (RBAC)
- **Công cụ Build & Test:** Apache Maven 3.9.6, JUnit 5 (`org.junit.jupiter`), Mockito 5.11
- **IDE hỗ trợ:** Apache NetBeans 21 / NetBeans 8.2 (Nhận diện Maven Webapp ngay khi mở)

---

## 📂 3. Cấu Trúc Mã Nguồn

```
DentalClinicManagementSystem/
├── pom.xml                                      # Cấu hình Maven chuẩn (NetBeans Webapp)
├── database/
│   └── DCMS_Init_Database_v1.0.sql             # Script SQL Server Baseline v1.0
├── src/main/java/com/dcms/
│   ├── controller/                             # Servlets (Login, Logout, Patient, Appointment, CheckIn)
│   ├── service/                                # Business Logic & Rules (Auth, Patient, Appointment, Visit)
│   ├── dao/                                    # Data Access Objects (User, Patient, Dentist, Schedule, Appointment, Visit)
│   ├── model/                                  # POJO Entities & DTOs
│   ├── filter/                                 # AuthFilter (RBAC kiểm soát URL)
│   └── util/                                   # DBContext (Kết nối SQL Server an toàn)
├── src/main/resources/
│   └── db.properties                           # Cấu hình chuỗi kết nối Database
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── web.xml                             # Web application descriptor
│   │   └── views/                              # JSP views an toàn bên trong WEB-INF
│   │       ├── auth/                           # login.jsp
│   │       ├── receptionist/                   # patient-list, patient-form, appointment-list, appointment-form, checkin, walkin-form
│   │       ├── dentist/                        # queue.jsp
│   │       └── common/                         # access-denied.jsp
│   └── index.jsp                               # Trang chào mừng
└── src/test/java/com/dcms/service/             # BỘ TEST TỰ ĐỘNG (56 Automated Tests)
```

---

## 🚀 4. Hướng Dẫn Cài Đặt & Chạy Thử

### Bước 1: Khởi tạo Cơ sở Dữ liệu
1. Mở SQL Server Management Studio (SSMS).
2. Mở file [database/DCMS_Init_Database_v1.0.sql](database/DCMS_Init_Database_v1.0.sql) và nhấn **Execute** để tạo database `DCMS_DB` cùng dữ liệu mẫu.
3. Nếu dùng các màn hình lâm sàng, chạy tiếp [database/DCMS_Iteration2_Schema.sql](database/DCMS_Iteration2_Schema.sql) để tạo các bảng khám, odontogram và tệp đính kèm.
4. Cập nhật mật khẩu SQL Server của bạn tại file [src/main/resources/db.properties](src/main/resources/db.properties) nếu khác `sa/123456`.

### Bước 2: Chạy Kiểm Thử Tự Động (Automated Testing)
Mở terminal tại thư mục dự án và chạy:
```bash
mvn test
```
> Kết quả mong đợi: `Tests run: 56, Failures: 0, Errors: 0, Skipped: 0` - `BUILD SUCCESS`.

### Bước 3: Mở & Chạy Dự Án Trên NetBeans
1. Mở **Apache NetBeans**.
2. Chọn **File** $\rightarrow$ **Open Project...** và chọn thư mục `Src_Clinic`.
3. Nhấp chuột phải vào dự án $\rightarrow$ Chọn **Run** (Chạy trên Apache Tomcat).

---

## 🔑 5. Tài Khoản Mẫu Trải Nghiệm Hệ Thống (Mật khẩu mặc định: `123456`)

| Tên Đăng Nhập | Vai Trò | Quyền Hạn & Màn Hình Chính |
| :--- | :--- | :--- |
| `admin` | Quản trị viên (Admin) | Quản lý toàn hệ thống, tài khoản, cấu hình |
| `letan01` | Lễ tân (Receptionist) | Hồ sơ bệnh nhân, Đặt lịch hẹn, Tiếp đón & Check-in, Hàng đợi chờ |
| `bacsi_hung` | Bác sĩ (Dentist) | Xem danh sách bệnh nhân chờ tại ghế khám, bắt đầu khám |
| `thungan01` | Thu ngân (Cashier) | Lập hóa đơn và thanh toán viện phí (Iteration 4) |

---

## 👥 Nhóm Thực Hiện
- **Nhóm:** G3 — Lớp SE2064
- **Dự án:** Dental Clinic Management System (DCMS)
- **Môn học:** Software Project (SWP391)

For SRS generation, follow .ai-srs/prompts/generate-functional-requirements.md.
Use Playwright to capture real system screenshots into docs/srs/images/.
Do not invent requirements.

# Dental Clinic Management System (DCMS)

> **Hệ thống Quản lý Toàn diện Phòng khám Nha khoa (Dr.Smile Inspired)**  
> Đồ án môn **Software Development Project (SWP391) — Lớp SE2064, Nhóm G3**

[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)]()
[![Java](https://img.shields.io/badge/Java-17-blue)]()
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20Servlet-6.0-orange)]()
[![Server](https://img.shields.io/badge/Tomcat-10.1.x-yellow)]()
[![Database](https://img.shields.io/badge/Database-MS%20SQL%20Server-red)]()
[![Tests](https://img.shields.io/badge/Automated%20Tests-70%20Passing-success)]()

---

## 📌 1. Giới Thiệu Dự Án

**Dental Clinic Management System (DCMS)** là hệ thống quản lý phòng khám nha khoa chuẩn y khoa khép kín, được thiết kế lấy cảm hứng từ nhận diện và quy trình vận hành thực tế của chuỗi nha khoa **Dr.Smile** (*"Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"*).

Hệ thống số hóa toàn diện quy trình chăm sóc từ lúc bệnh nhân tiếp cận trực tuyến đến khi hoàn tất điều trị:
- **Cổng Website Nha Khoa Công Khai (Public Portal & Guest Booking):** Giới thiệu dịch vụ mũi nhọn (Răng sứ 4.0, Niềng răng Invisalign, Cấy ghép Implant, Tẩy trắng răng, Nhổ răng khôn sóng siêu âm Piezosurgical), bảng giá niêm yết, đội ngũ chuyên gia và form đặt lịch khám online theo **Khung giờ cố định (Slot 30 phút: 08:00 – 18:30)** với phản hồi mã lịch hẹn `#APT-...` thời gian thực.
- **Phân Hệ Tiếp Đón & Lịch Hẹn (Receptionist Desk):** Quản lý hồ sơ bệnh nhân 360°, đặt lịch hẹn quầy theo slot 30 phút, đổi lịch khám thông minh, tiếp đón check-in chuyển đổi lịch hẹn thành lượt khám tại ghế, tiếp nhận khách vãng lai/cấp cứu (`Walk-in`).
- **Quản Lý Lịch Trực Bác Sĩ (Dentist Work Schedule — UC37):** Thiết lập ca trực cố định hàng tuần cho từng bác sĩ (Ca sáng 08:00-12:00, Ca chiều 13:00-17:30, Tối 13:00-18:30, Cả ngày 08:00-18:30), tự động kiểm tra ca trực và chống trùng lịch trên toàn viện.
- **Bàn Làm Việc Lâm Sàng Của Bác Sĩ (Dentist Workspace):** Điều phối hàng đợi tại ghế khám, đánh giá sinh hiệu & nguy cơ tiền thủ thuật, khám răng chuyên sâu, sơ đồ răng Odontogram tương tác chuẩn FDI 11–48 (hỗ trợ chi tiết 5 mặt răng cho thủ thuật trám sâu), tải lên và xem trước phim X-quang multipart.

### 5 Nguyên Tắc Thép Nghiệp Vụ Nha Khoa:
1. **Appointment $\neq$ Visit:** Lịch hẹn chỉ là lịch hẹn trước. Lượt khám thực tế (`Visit`) chỉ phát sinh khi bệnh nhân có mặt tại quầy (`Check-in`). Khách vãng lai (`Walk-in`) tạo `Visit` trực tiếp mà **không cần** `Appointment`.
2. **TreatmentPlanItem $\neq$ ProcedurePerformed:** Hạng mục kế hoạch chỉ là dự kiến đề xuất; hóa đơn và bệnh án thực tế chỉ ghi nhận khi thủ thuật đã hoàn thành (`ProcedurePerformed`).
3. **Invoice CHỈ sinh ra từ ProcedurePerformed:** Tuyệt đối không tính tiền viện phí trên các hạng mục điều trị chưa thực hiện.
4. **Multi-visit Treatment Plans:** Kế hoạch điều trị hỗ trợ theo dõi xuyên suốt qua nhiều buổi khám và ngày khám khác nhau.
5. **Chi tiết Răng (Tooth) và Mặt răng (Surface):** Hồ sơ chẩn đoán răng hỗ trợ chuẩn FDI 11–48 và 5 mặt răng (`Occlusal`, `Mesial`, `Distal`, `Buccal`, `Lingual`).

---

## 🛠️ 2. Công Nghệ & Kiến Trúc

| Thành phần | Công nghệ lựa chọn |
| :--- | :--- |
| **Ngôn ngữ lập trình** | **Java 17 (LTS)** |
| **Kiến trúc Web** | **Jakarta EE 10** (Servlet 6.0, JSP 3.1, JSTL 3.0) — Mô hình MVC 3 tầng |
| **Môi trường Server** | **Apache Tomcat 10.1.x** |
| **Cơ sở Dữ liệu** | **Microsoft SQL Server 2019 / 2022** (JDBC Driver `mssql-jdbc`) |
| **Bảo mật & Phân quyền** | Mã hóa mật khẩu **BCrypt** (`org.mindrot:jbcrypt`), HttpOnly Session, **AuthFilter** (RBAC) |
| **Giao diện (UI/UX)** | Chuẩn nhận diện nha khoa Dr.Smile (Deep Navy `#003366`, Medical Cyan `#00a8cc`, Gold `#d4af37`), CSS Variables, SVG Odontogram |
| **Testing Framework** | **JUnit 5** (`org.junit.jupiter`) + **Mockito 5.11** |
| **Build Tool & IDE** | **Apache Maven 3.9+**, hỗ trợ mở trực tiếp trên **Apache NetBeans 21+** |

---

## 📂 3. Cấu Trúc Mã Nguồn Repository

```text
DentalClinicManagementSystem/
├── pom.xml                                  # Cấu hình Maven chuẩn (Jakarta EE 10, Servlet 6, JSTL 3)
├── .gitignore                               # Quy tắc bỏ qua file rác, file tạm và môi trường cá nhân
├── README.md                                # Tài liệu hướng dẫn dự án
├── database/                                # Kịch bản CSDL Microsoft SQL Server
│   ├── DCMS_Init_Database_v1.0.sql          # Khởi tạo CSDL Baseline v1.0 & Seed Data mẫu
│   ├── DCMS_Iteration2_Schema.sql           # Schema mở rộng khám lâm sàng, odontogram & x-quang
│   └── fix_seed_utf8.sql                    # Hỗ trợ chuẩn hóa dữ liệu tiếng Việt có dấu
├── src/main/java/com/dcms/                  # Mã nguồn Backend (MVC 3 tầng)
│   ├── model/                               # POJO Entities (User, Patient, Dentist, Schedule, Visit,...)
│   ├── dao/                                 # Data Access Objects (JDBC PreparedStatement, Resource Close)
│   ├── service/                             # Nghiệp vụ cốt lõi, kiểm tra lịch trực, chống trùng ca
│   ├── controller/                          # Jakarta HttpServlet xử lý Request/Response & Điều hướng
│   ├── filter/                              # AuthFilter (RBAC kiểm soát URL) & CharacterEncodingFilter
│   └── util/                                # DBContext kết nối an toàn với SQL Server
├── src/main/resources/                      # Tài nguyên cấu hình
│   └── db.properties                        # Cấu hình kết nối SQL Server (User, Password, Port)
├── src/main/webapp/                         # Giao diện Web (JSP Views & Static Assets)
│   ├── WEB-INF/
│   │   ├── web.xml                          # Schema Jakarta EE 6.0 Web Descriptor
│   │   └── views/                           # JSP an toàn (layout, receptionist, dentist, auth, common)
│   ├── assets/                              # CSS Theme Dr.Smile, Hình ảnh thương hiệu, SVG biểu trưng
│   └── index.jsp                            # Cổng thông tin công khai & Đặt lịch hẹn online đa tab
└── src/test/java/com/dcms/                  # BỘ KIỂM THỬ TỰ ĐỘNG (70 Automated Tests - PASS 100%)
    ├── controller/                          # Test Servlets (GuestBooking, Schedule, Appointment,...)
    ├── service/                             # Test Services (Appointment, Schedule, Patient, Visit, Clinical,...)
    └── util/                                # Test kết nối DBContext
```

---

## 🚀 4. Hướng Dẫn Cài Đặt & Triển Khai

### Bước 1: Khởi tạo Cơ sở Dữ liệu SQL Server
1. Mở **SQL Server Management Studio (SSMS)** hoặc **Azure Data Studio**.
2. Mở file [database/DCMS_Init_Database_v1.0.sql](database/DCMS_Init_Database_v1.0.sql) và nhấn **Execute** để tạo cơ sở dữ liệu `DCMS_DB` cùng bảng và dữ liệu mẫu có sẵn.
3. Nếu sử dụng các chức năng lâm sàng và sơ đồ răng Odontogram, chạy tiếp file [database/DCMS_Iteration2_Schema.sql](database/DCMS_Iteration2_Schema.sql).
4. Kiểm tra cấu hình kết nối tại [src/main/resources/db.properties](src/main/resources/db.properties) (mặc định: `localhost:1434` hoặc `1433`, tài khoản `sa`, mật khẩu `123456`).

### Bước 2: Chạy Bộ Kiểm Thử Tự Động (Automated Test Suite)
Mở cửa sổ dòng lệnh tại thư mục dự án và thực thi:
```bash
mvn test
```
> **Kết quả chuẩn:** `Tests run: 70, Failures: 0, Errors: 0, Skipped: 0` $\rightarrow$ `BUILD SUCCESS`.

### Bước 3: Đóng gói Ứng dụng Web
```bash
mvn clean package
```
> Lệnh sẽ tạo file `target/dcms.war` sẵn sàng để deploy lên máy chủ Apache Tomcat 10.1.x.

### Bước 4: Chạy Dự Án Trên NetBeans
1. Mở **Apache NetBeans**.
2. Chọn **File** $\rightarrow$ **Open Project...** và trỏ đến thư mục dự án `Src_Clinic`.
3. Nhấp chuột phải vào dự án $\rightarrow$ Chọn **Run** (Dự án sẽ tự động chạy trên máy chủ Apache Tomcat 10 tích hợp).
4. Truy cập hệ thống tại: `http://localhost:8080/dcms/` hoặc `http://localhost:8080/`.

---

## 🔑 5. Danh Sách Tài Khoản Thử Nghiệm (Mật khẩu mặc định: `123456`)

| Tên Đăng Nhập | Vai Trò (Role) | Chức Năng Chính |
| :--- | :--- | :--- |
| `admin` | **Administrator** | Bảng điều khiển quản trị, quản lý bác sĩ, nhân sự và giám sát hệ thống |
| `letan01` | **Receptionist** | Hồ sơ bệnh nhân, Đặt lịch hẹn cố định theo slot, Quản lý ca trực bác sĩ (UC37), Tiếp đón & Check-in |
| `bacsi_hung` | **Dentist** | Bàn làm việc bác sĩ, Hàng đợi ghế khám, Khám lâm sàng, Sơ đồ răng FDI 11–48, X-quang |
| `trothu01` | **DentalAssistant** | Tiếp nhận ca khám, ghi nhận sinh hiệu & đánh giá tiền thủ thuật |
| `thungan01` | **Cashier** | Quản lý hóa đơn và thanh toán viện phí |

---

## 👥 6. Thông Tin Nhóm Phát Triển

- **Mã môn:** SWP391 — Software Development Project
- **Nhóm:** G3 — Lớp SE2064 (Đại học FPT)
- **Tên đề tài:** Dental Clinic Management System (DCMS)
- **Cố vấn / Giảng viên hướng dẫn:** Bộ môn Kỹ thuật Phần mềm (Software Engineering)

# DCMS — Automation Scripts & Tools (`scripts/`)

Thư mục chứa các công cụ tự động hóa, cấu hình Git đa tài khoản và kiểm thử quay vòng vai trò cho nhóm 5 thành viên dự án DCMS.

---

## 1. Danh sách Script

| Tên File | Môi trường | Mục đích | Cách sử dụng |
|---|---|---|---|
| [`switch_acc.ps1`](switch_acc.ps1) | Windows PowerShell | Chuyển đổi thông tin Git commit (`user.name`, `user.email`) & Remote URL giữa 5 thành viên | `.\switch_acc.ps1 <tuan\|dung\|thai\|wolf\|kien>` hoặc `.\scripts\switch_acc.ps1 <tên>` |
| [`switch_acc.sh`](switch_acc.sh) | Bash / Linux / Git Bash | Bản script shell tương đương trên môi trường Unix | `./scripts/switch_acc.sh <tên>` |
| [`test_rotate_acc.ps1`](test_rotate_acc.ps1) | Windows PowerShell | Kiểm thử tự động tính chính xác khi chuyển đổi qua lại cả 5 tài khoản | `powershell .\scripts\test_rotate_acc.ps1` |
| [`generate_keys.sh`](generate_keys.sh) | Bash | Script tự động tạo hàng loạt 5 SSH Ed25519 keypair không cần nhập passphrase | `./scripts/generate_keys.sh` |

---

## 2. Ma trận 5 thành viên & Phân công chức năng

1. **Tuấn (`tuan`):** Architecture, DB Schema, Catalog dịch vụ & Biểu phí niêm yết (`UC40`), Auth & RBAC (`UC41`), Role Dashboards (`UC42`).
2. **Dũng (`dung`):** Quản lý bệnh nhân (`UC01`-`UC04`), Hàng đợi tiếp đón & Check-in (`UC10`, `UC11`, `UC39`), Kế hoạch điều trị đa buổi (`UC19`, `UC20`, `UC23`), Báo giá (`UC21`).
3. **Thái (`thai`):** Lịch hẹn toàn viện (`UC05`-`UC09`), Đổi lịch, Lịch trực bác sĩ (`UC37`), Đặt lịch trực tuyến Guest Booking, Xác nhận cam kết điều trị (`UC22`).
4. **Wolf (`wolf`):** Khám bệnh lâm sàng & Đánh giá sinh hiệu (`UC12`-`UC14`, `UC17`), Thủ thuật thực tế tại ghế (`UC24`, `UC25`, `UC18`), Vật tư tiêu hao (`UC26`).
5. **Kiên (`kien`):** Sơ đồ răng tương tác FDI 11-48 (`UC15`), Upload phim X-quang (`UC16`), Kê đơn thuốc điện tử (`UC27`), In đơn thuốc (`UC28`).

---

## 3. Chế độ Push

- **Mặc định (Khuyên dùng):** `HTTPS` qua Windows Credential Manager — Commit hiển thị chính xác tên và email của từng người mà không lo lỗi SSH key chưa add lên GitHub.
- **SSH Mode:** Thêm cờ `-UseSSH` nếu đã upload public key lên GitHub account tương ứng:
  ```powershell
  .\switch_acc.ps1 tuan -UseSSH
  ```

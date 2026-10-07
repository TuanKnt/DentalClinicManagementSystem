#!/bin/bash

# ==============================================================================
# DCMS G3_SE2064 -- MA TRAN PHAN CONG CHUC NANG (ITERATION 1 & ITERATION 2)
# ==============================================================================

ACCOUNT="${1:-status}"

show_status() {
    CURRENT_NAME=$(git config user.name)
    CURRENT_EMAIL=$(git config user.email)
    CURRENT_REMOTE=$(git config remote.origin.url)

    echo ""
    echo "================================================================================"
    echo "         DCMS G3_SE2064 -- TRANG THAI GIT ACCOUNT (ITERATION 1 & 2)             "
    echo "================================================================================"
    echo "  * Git user.name   : $CURRENT_NAME"
    echo "  * Git user.email  : $CURRENT_EMAIL"
    echo "  * Remote origin   : $CURRENT_REMOTE"
    echo "================================================================================"
    echo ""
    echo "PHAN CONG 5 THANH VIEN TRONG ITERATION 1 VA ITERATION 2:"
    echo "  1. TUAN (TuanKnt <tuanknhe161046@fpt.edu.vn>) -- Team Leader & Core Architect"
    echo "     -> Iter 1: Auth & RBAC (UC41), Dashboards (UC42), DB Schema v1.0, Dr.Smile Shell"
    echo "     -> Iter 2: Database Schema v2.0, Danh muc dich vu nha khoa (Dental Services UC40)"
    echo ""
    echo "  2. DUNG (dungnguyen231056) -- Reception & Patient Care Specialist"
    echo "     -> Iter 1: Quan ly Benh nhan (UC01-UC04), Tiep don & Check-in (UC10, UC11, UC39), Walk-in"
    echo "     -> Iter 2: Lap ke hoach dieu tri (Treatment Plan UC19, UC20, UC23), Uoc tinh chi phi (UC21)"
    echo ""
    echo "  3. THAI (nguyenthai15090) -- Appointment & Scheduling Engineer"
    echo "     -> Iter 1: Lich hen toan vien (UC05-UC09), Doi lich, Lich truc Bac si (UC37), Guest Booking"
    echo "     -> Iter 2: Xac nhan & Cam ket dieu tri cua benh nhan (Treatment Consent UC22)"
    echo ""
    echo "  4. WOLF (wolfsama2006 <wolfsama2006@gmail.com>) -- Clinical Treatment & Medical Records"
    echo "     -> Iter 1: Tien thu thuat & Sinh hieu (UC13), Kham lam sang & Benh an (UC12, UC14, UC17, UC18)"
    echo "     -> Iter 2: Thuc hien thu thuat tai ghe (Procedure Performed UC24, UC25), Vat tu tieu hao (UC26)"
    echo ""
    echo "  5. KIEN (Kienphan216) -- Dental Chart, Imaging & Pharmacy Module"
    echo "     -> Iter 1: So do rang Odontogram FDI 11-48 (UC15), Upload & Quan ly phim X-quang (UC16)"
    echo "     -> Iter 2: Ke don thuoc dien tu (Prescription UC27), In phieu don thuoc (UC28), Danh muc thuoc"
    echo ""
    echo "LENH CHUYEN DOI: ./switch_acc.sh [tuan|dung|thai|wolf|kien|status]"
    echo ""
}

case "$ACCOUNT" in
    tuan)
        git config user.name "TuanKnt"
        git config user.email "tuanknhe161046@fpt.edu.vn"
        git config remote.origin.url "git@github-tuan:SWP391G3/DentalClinicManagementSystem.git"
        git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_tuan -F ~/.ssh/config"
        echo "[OK] Đã chuyển sang: TUAN (TuanKnt) - Phụ trách Kiến trúc & DB Catalog (Iter 1 & 2)"
        ;;
    dung)
        git config user.name "dungnguyen231056"
        git config user.email "dungnguyen231056@users.noreply.github.com"
        git config remote.origin.url "git@github-dung:SWP391G3/DentalClinicManagementSystem.git"
        git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_dung -F ~/.ssh/config"
        echo "[OK] Đã chuyển sang: DUNG (dungnguyen231056) - Phụ trách Tiếp đón & Kế hoạch điều trị (Iter 1 & 2)"
        ;;
    thai)
        git config user.name "nguyenthai15090"
        git config user.email "nguyenthai15090@users.noreply.github.com"
        git config remote.origin.url "git@github-thai:SWP391G3/DentalClinicManagementSystem.git"
        git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_thai -F ~/.ssh/config"
        echo "[OK] Đã chuyển sang: THAI (nguyenthai15090) - Phụ trách Lịch hẹn & Cam kết điều trị (Iter 1 & 2)"
        ;;
    wolf)
        git config user.name "wolfsama2006"
        git config user.email "wolfsama2006@gmail.com"
        git config remote.origin.url "git@github-wolf:SWP391G3/DentalClinicManagementSystem.git"
        git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_wolf -F ~/.ssh/config"
        echo "[OK] Đã chuyển sang: WOLF (wolfsama2006) - Phụ trách Khám bệnh & Thực hiện thủ thuật (Iter 1 & 2)"
        ;;
    kien)
        git config user.name "Kienphan216"
        git config user.email "Kienphan216@users.noreply.github.com"
        git config remote.origin.url "git@github-kien:SWP391G3/DentalClinicManagementSystem.git"
        git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_kien -F ~/.ssh/config"
        echo "[OK] Đã chuyển sang: KIEN (Kienphan216) - Phụ trách Sơ đồ răng, Phim ảnh & Kê đơn thuốc (Iter 1 & 2)"
        ;;
    status|list|"")
        show_status
        ;;
    *)
        echo "[ERROR] Tài khoản không hợp lệ: $ACCOUNT"
        echo "Chọn một trong các tài khoản: tuan, dung, thai, wolf, kien"
        exit 1
        ;;
esac

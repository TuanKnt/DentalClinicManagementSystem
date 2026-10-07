param (
    [string]$Account = "status"
)

# ==============================================================================
# DCMS G3_SE2064 -- MA TRAN PHAN CONG CHUC NANG (ITERATION 1 & ITERATION 2)
# ==============================================================================

$Members = @{
    "tuan" = @{
        Name = "TuanKnt"
        Email = "tuanknhe161046@fpt.edu.vn"
        Role = "Team Leader & Core Architect"
        Host = "github-tuan"
        KeyFile = "id_ed25519_tuan"
        Iter1 = "Auth & RBAC (UC41), Role Dashboards (UC42), DB Schema v1.0, Dr.Smile Design Shell & Jakarta Migration"
        Iter2 = "Database Schema v2.0, Danh muc dich vu nha khoa & Bieu phi niem yet (Dental Services Catalog UC40)"
    }
    "dung" = @{
        Name = "dungnguyen231056"
        Email = "dungnguyen231056@users.noreply.github.com"
        Role = "Reception & Patient Care Specialist"
        Host = "github-dung"
        KeyFile = "id_ed25519_dung"
        Iter1 = "Quan ly Benh nhan (UC01-UC04), Hang doi tiep don & Check-in nguyen tu (UC10, UC11, UC39), Khach vang lai (Walk-in)"
        Iter2 = "Lap ke hoach dieu tri da buoi (Treatment Plan UC19, UC20, UC23), Uoc tinh chi phi dieu tri (Treatment Estimate UC21)"
    }
    "thai" = @{
        Name = "nguyenthai15090"
        Email = "nguyenthai15090@users.noreply.github.com"
        Role = "Appointment & Scheduling Engineer"
        Host = "github-thai"
        KeyFile = "id_ed25519_thai"
        Iter1 = "Lich hen toan vien (UC05-UC09), Doi lich Reschedule, Lich truc Bac si (UC37), Dat lich truc tuyen (Guest Booking)"
        Iter2 = "Xac nhan & Cam ket dieu tri cua benh nhan (Record Treatment Acceptance / Consent UC22)"
    }
    "wolf" = @{
        Name = "wolfsama2006"
        Email = "wolfsama2006@gmail.com"
        Role = "Clinical Treatment & Medical Records"
        Host = "github-wolf"
        KeyFile = "id_ed25519_wolf"
        Iter1 = "Danh gia tien thu thuat & Sinh hieu (UC13), Kham lam sang & Benh an (UC12, UC14, UC17, UC18), Hang doi Bac si tai ghe"
        Iter2 = "Thuc hien thu thuat tai ghe (Procedure Performed UC24, UC25, UC18), Ghi nhan vat tu tieu hao (Material Usage UC26)"
    }
    "kien" = @{
        Name = "Kienphan216"
        Email = "Kienphan216@users.noreply.github.com"
        Role = "Dental Chart, Imaging & Pharmacy Module"
        Host = "github-kien"
        KeyFile = "id_ed25519_kien"
        Iter1 = "So do rang Odontogram tuong tac FDI 11-48 (UC15), Upload & Quan ly phim X-quang multipart (UC16)"
        Iter2 = "Ke don thuoc dien tu (Prescription UC27), In phieu don thuoc (Print Prescription UC28), Danh muc thuoc (Medicines)"
    }
}

function Show-Status {
    $currentName = git config user.name
    $currentEmail = git config user.email
    $currentRemote = git config remote.origin.url
    $currentSshCmd = git config core.sshCommand

    Write-Host "`n================================================================================" -ForegroundColor Cyan
    Write-Host "         DCMS G3_SE2064 -- TRANG THAI GIT ACCOUNT (ITERATION 1 & 2)             " -ForegroundColor Cyan
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  * Git user.name   : " -NoNewline; Write-Host "$currentName" -ForegroundColor Yellow
    Write-Host "  * Git user.email  : " -NoNewline; Write-Host "$currentEmail" -ForegroundColor Yellow
    Write-Host "  * Remote origin   : " -NoNewline; Write-Host "$currentRemote" -ForegroundColor Green
    Write-Host "  * SSH Command     : " -NoNewline; Write-Host "$currentSshCmd" -ForegroundColor DarkGray
    Write-Host "================================================================================" -ForegroundColor Cyan
    
    Write-Host "`nPHAN CONG 5 THANH VIEN TRONG ITERATION 1 VA ITERATION 2:`n" -ForegroundColor White
    foreach ($k in @("tuan", "dung", "thai", "wolf", "kien")) {
        $m = $Members[$k]
        $isActive = ($currentName -eq $m.Name)
        $prefix = if ($isActive) { "[* DANG CHON] " } else { "              " }
        $color = if ($isActive) { "Green" } else { "Yellow" }

        Write-Host "$prefix$($k.ToUpper()) ($($m.Name) <$($m.Email)>)" -ForegroundColor $color
        Write-Host "    -> Vai tro : $($m.Role)" -ForegroundColor Cyan
        Write-Host "    -> Iter 1  : $($m.Iter1)" -ForegroundColor White
        Write-Host "    -> Iter 2  : $($m.Iter2)" -ForegroundColor Gray
        Write-Host ""
    }
    Write-Host "LENH CHUYEN DOI: .\switch_acc.ps1 <tuan | dung | thai | wolf | kien>`n" -ForegroundColor Cyan
}

$accLower = $Account.ToLower().Trim()

if ($accLower -eq "status" -or $accLower -eq "list" -or [string]::IsNullOrEmpty($accLower)) {
    Show-Status
    exit 0
}

if (-not $Members.ContainsKey($accLower)) {
    Write-Host "[ERROR] Khong tim thay thanh vien '$Account'!" -ForegroundColor Red
    Write-Host "Danh sach hop le: tuan, dung, thai, wolf, kien" -ForegroundColor Yellow
    exit 1
}

$target = $Members[$accLower]
$sshDir = "$HOME\.ssh"
$keyPath = "$sshDir\$($target.KeyFile)"

# Cap nhat Git config local repo
git config user.name "$($target.Name)"
git config user.email "$($target.Email)"
git config remote.origin.url "git@$($target.Host):SWP391G3/DentalClinicManagementSystem.git"
git config core.sshCommand "ssh -i $HOME/.ssh/$($target.KeyFile) -F $HOME/.ssh/config"

Write-Host "`n================================================================================" -ForegroundColor Green
Write-Host "  [OK] DA CHUYEN THANH CONG SANG TAI KHOAN: $($accLower.ToUpper()) ($($target.Name))" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  * Ho ten/Username : $($target.Name)" -ForegroundColor White
Write-Host "  * Email commit    : $($target.Email)" -ForegroundColor White
Write-Host "  * Vai tro         : $($target.Role)" -ForegroundColor Cyan
Write-Host "  * SSH Key su dung : $keyPath" -ForegroundColor DarkGray
Write-Host "  * Git Remote URL  : git@$($target.Host):SWP391G3/DentalClinicManagementSystem.git" -ForegroundColor DarkGray
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray
Write-Host "PHIEU GIAO VIEC (SCOPE CHUC NANG):" -ForegroundColor Yellow
Write-Host "  [Iter 1] $($target.Iter1)" -ForegroundColor White
Write-Host "  [Iter 2] $($target.Iter2)" -ForegroundColor Green
Write-Host "================================================================================`n" -ForegroundColor Green

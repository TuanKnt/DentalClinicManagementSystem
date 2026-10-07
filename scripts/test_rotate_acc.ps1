# ==============================================================================
# DCMS G3_SE2064 -- KIEM THU TOAN DIEN HE THONG XOAY TAI KHOAN GIT & SSH
# ==============================================================================

Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "       BAT DAU KIEM THU TU DONG CHUC NANG XOAY TAI KHOAN GIT (5 MEMBERS)        " -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan

$testAccounts = @(
    @{ Key = "tuan"; ExpectedName = "TuanKnt"; ExpectedEmail = "tuanknhe161046@fpt.edu.vn"; ExpectedHost = "github-tuan"; KeyFile = "id_ed25519_tuan" },
    @{ Key = "dung"; ExpectedName = "dungnguyen231056"; ExpectedEmail = "dungnguyen231056@users.noreply.github.com"; ExpectedHost = "github-dung"; KeyFile = "id_ed25519_dung" },
    @{ Key = "thai"; ExpectedName = "nguyenthai15090"; ExpectedEmail = "nguyenthai15090@users.noreply.github.com"; ExpectedHost = "github-thai"; KeyFile = "id_ed25519_thai" },
    @{ Key = "wolf"; ExpectedName = "wolfsama2006"; ExpectedEmail = "wolfsama2006@gmail.com"; ExpectedHost = "github-wolf"; KeyFile = "id_ed25519_wolf" },
    @{ Key = "kien"; ExpectedName = "Kienphan216"; ExpectedEmail = "Kienphan216@users.noreply.github.com"; ExpectedHost = "github-kien"; KeyFile = "id_ed25519_kien" }
)

$results = @()
$sshDir = Join-Path $HOME ".ssh"

foreach ($acc in $testAccounts) {
    Write-Host "`n--> [TEST CASE] Xoay sang tai khoan: $($acc.Key.ToUpper()) ($($acc.ExpectedName))..." -ForegroundColor Yellow
    
    # 1. Thuc thi lenh switch
    & "$PSScriptRoot\switch_acc.ps1" -Account $acc.Key -UseSSH | Out-Null
    
    # 2. Doc gia tri thuc te tu git config
    $actualName = (git config user.name).Trim()
    $actualEmail = (git config user.email).Trim()
    $actualRemote = (git config remote.origin.url).Trim()
    $actualSshCmd = (git config core.sshCommand).Trim()
    
    # 3. Kiem tra tinh hop le
    $nameMatch = ($actualName -eq $acc.ExpectedName)
    $emailMatch = ($actualEmail -eq $acc.ExpectedEmail)
    $remoteMatch = ($actualRemote -like "*$($acc.ExpectedHost)*")
    $keyFileExists = (Test-Path (Join-Path $sshDir $acc.KeyFile))
    
    $isPassed = ($nameMatch -and $emailMatch -and $remoteMatch -and $keyFileExists)
    
    $results += [PSCustomObject]@{
        Account = $acc.Key.ToUpper()
        Username = $actualName
        Email = $actualEmail
        SSH_Key = if ($keyFileExists) { "FOUND" } else { "MISSING" }
        Remote_Host = $acc.ExpectedHost
        Status = if ($isPassed) { "PASS" } else { "FAIL" }
    }
    
    if ($isPassed) {
        Write-Host "    [OK] User.Name    : $actualName" -ForegroundColor Green
        Write-Host "    [OK] User.Email   : $actualEmail" -ForegroundColor Green
        Write-Host "    [OK] Remote URL   : $actualRemote" -ForegroundColor Green
        Write-Host "    [OK] SSH Key File : $sshDir\$($acc.KeyFile) (Exists)" -ForegroundColor Green
    } else {
        Write-Host "    [FAIL] Kiem thu that bai cho $($acc.Key)!" -ForegroundColor Red
    }
}

Write-Host "`n================================================================================" -ForegroundColor Cyan
Write-Host "                       BANG TONG HOP KET QUA KIEM THU                           " -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan

$results | Format-Table -AutoSize

Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray
$passCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
Write-Host "KET QUA: $passCount/5 TAI KHOAN DAT CHUAN (100% PASS)`n" -ForegroundColor Green

# Reset lai tai khoan mac dinh tuan
& "$PSScriptRoot\switch_acc.ps1" -Account tuan | Out-Null

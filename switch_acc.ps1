param (
    [string]$Account = "status",
    [switch]$UseSSH
)

# Wrapper delegating to the organized script in scripts/
$scriptPath = Join-Path $PSScriptRoot "scripts\switch_acc.ps1"
if ($UseSSH) {
    & $scriptPath -Account $Account -UseSSH
} else {
    & $scriptPath -Account $Account
}

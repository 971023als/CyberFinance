function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-105] 불필요한 시작프로그램 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 불필요한 시작 프로그램이 존재하지 않는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 불필요한 시작 프로그램이 존재하는 경우"

BAR

# 시스템 시작 프로그램 및 서비스 확인
$startupPrograms = Get-CimInstance Win32_StartupCommand
$enabledServices = Get-WmiObject Win32_Service | Where-Object { $_.StartMode -eq "Auto" -and $_.State -eq "Running" }

# 불필요하거나 의심스러운 시작 프로그램 확인
foreach ($program in $startupPrograms) {
    Add-Content -Path $global:TMP1 -Value "의심스러운 시작 프로그램: $($program.Caption)"
}

# 불필요하거나 의심스러운 서비스 확인
foreach ($service in $enabledServices) {
    Add-Content -Path $global:TMP1 -Value "의심스러운 서비스: $($service.DisplayName)"
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

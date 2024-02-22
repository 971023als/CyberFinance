# function.ps1 내용 포함
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-064_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-064] 취약한 버전의 DNS 서비스 사용"

Add-Content -Path $TMP1 -Value "[양호]: DNS 서비스가 최신 버전으로 업데이트되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: DNS 서비스가 최신 버전으로 업데이트되어 있지 않은 경우"

BAR

# Windows DNS 서비스의 실행 상태 확인 (Windows DNS 서비스 이름: "DNS")
$dnsServiceStatus = Get-Service -Name "DNS" -ErrorAction SilentlyContinue

if ($dnsServiceStatus -ne $null -and $dnsServiceStatus.Status -eq "Running") {
    # 시스템 업데이트 상태 확인 (예시)
    $updateHistory = Get-WindowsUpdateLog -ErrorAction SilentlyContinue
    if ($updateHistory -match "Security Update for Microsoft Windows DNS Server") {
        OK "DNS 서비스가 최신 보안 업데이트를 받았습니다."
    } else {
        WARN "DNS 서비스의 최신 보안 업데이트 상태를 확인할 수 없습니다."
    }
} else {
    OK "DNS 서비스가 실행되지 않고 있습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

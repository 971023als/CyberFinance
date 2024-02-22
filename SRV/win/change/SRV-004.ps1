# 필요한 함수 로드
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

# SMTP 서비스 이름 설정
$SMTP_SERVICE = "SMTPSVC"  # Windows에서의 SMTP 서비스 이름

# SMTP 서비스 상태 확인 및 비활성화
$serviceStatus = Get-Service -Name $SMTP_SERVICE -ErrorAction SilentlyContinue

if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
    # SMTP 서비스를 비활성화
    Stop-Service -Name $SMTP_SERVICE -Force
    Set-Service -Name $SMTP_SERVICE -StartupType Disabled

    OK "$SMTP_SERVICE 서비스가 비활성화되고 정지되었습니다." | Out-File -FilePath $TMP1 -Append
} else {
    OK "$SMTP_SERVICE 서비스는 이미 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# SMTP 포트(25) 닫기 조치는 복잡하며, 일반적으로 방화벽 설정을 통해 수행됩니다.
# Windows 방화벽을 통한 SMTP 포트(25) 차단
$ruleName = "Block SMTP Port 25"
if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort 25 -Action Block
    New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Protocol TCP -LocalPort 25 -Action Block

    OK "SMTP 포트(25)에 대한 인바운드 및 아웃바운드 트래픽을 차단하는 방화벽 규칙이 생성되었습니다." | Out-File -FilePath $TMP1 -Append
} else {
    OK "SMTP 포트(25) 차단을 위한 방화벽 규칙이 이미 존재합니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

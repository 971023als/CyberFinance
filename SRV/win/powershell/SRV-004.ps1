# 필요한 함수 로드 (PowerShell 스크립트로 가정)
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

CODE "SRV-004 불필요한 SMTP 서비스 실행"

# 로그 파일에 내용 추가
@"
[양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우
[취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-004] 불필요한 SMTP 서비스 실행" | Out-File -FilePath $TMP1 -Append

# SMTP 서비스 (예: postfix) 실행 여부 확인
$SMTP_SERVICE = "SMTPSVC"  # Windows에서 SMTP 서비스의 예상 서비스 이름

$serviceStatus = Get-Service -Name $SMTP_SERVICE -ErrorAction SilentlyContinue

if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
    WARN "$SMTP_SERVICE 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
} else {
    OK "$SMTP_SERVICE 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# SMTP 포트(25) 상태 확인
$SMTP_PORT = 25
$SMTP_PORT_STATUS = Test-NetConnection -ComputerName localhost -Port $SMTP_PORT

if ($SMTP_PORT_STATUS.TcpTestSucceeded) {
    WARN "SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    OK "SMTP 포트(25)는 닫혀 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

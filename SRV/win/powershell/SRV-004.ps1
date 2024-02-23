# 로그 파일 설정
$TMP1 = "$PSScriptRoot\{0}.log" -f $MyInvocation.MyCommand.Name
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-004] 불필요한 SMTP 서비스 실행
------------------------------------------------
[양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우
[취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# Windows에서 SMTP 서비스 실행 여부 확인
$smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    "SMTP 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# SMTP 포트 25 상태 확인
$smtpPort = Get-NetTCPConnection -LocalPort 25 -ErrorAction SilentlyContinue
if ($smtpPort) {
    "SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 포트(25)는 닫혀 있습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

# 로그 파일 설정
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비
------------------------------------------------
[양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우
[취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# Windows 환경에서 SMTP 서비스 확인
$smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue
if ($smtpService.Status -eq 'Running') {
    "SMTP 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
    # 여기에 Exchange 서버의 expn/vrfy 명령어 사용 제한 설정 확인 로직 구현
    # Exchange 관리 셸을 통한 설정 확인이 필요한 경우, 해당 PowerShell 명령어를 삽입
    "SMTP 설정을 확인할 수 없습니다. Exchange 관리 셸에서 수동으로 확인하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

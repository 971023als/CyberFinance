# 결과 파일 정의
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 결과 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-006] SMTP 서비스 로그 수준 설정 미흡
------------------------------------------------
[양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우
[취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# SMTP 로그 설정 확인
# 이 부분은 환경에 따라 적절한 PowerShell cmdlet으로 대체해야 함
$logLevel = Get-TransportServer | Select-Object -ExpandProperty LogLevel

if ($logLevel -eq 'Medium' -or $logLevel -eq 'High') {
    "SMTP 서비스의 로그 수준이 적절하게 설정됨." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 서비스의 로그 수준이 낮게 설정됨 또는 설정이 확인되지 않음." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

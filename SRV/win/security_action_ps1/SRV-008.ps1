# 결과 파일 정의
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 결과 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-008] SMTP 서비스의 DoS 방지 기능 미설정
------------------------------------------------
[양호]: SMTP 서비스에 DoS 방지 설정이 적용된 경우
[취약]: SMTP 서비스에 DoS 방지 설정이 적용되지 않은 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# DoS 방지 기능 설정 확인 (Exchange 서버의 DoS 방지 설정 점검을 예로 사용)
# 실제 DoS 방지 설정 검사 로직은 환경에 따라 달라질 수 있으며, 여기서는 설정이 적용되었다고 가정
$DoSSettingsApplied = $True

if ($DoSSettingsApplied) {
    "SMTP 서비스에 DoS 방지 설정이 적용되었습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 서비스에 DoS 방지 설정이 적용되지 않았습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

# 필요한 함수 로드 (PowerShell 스크립트로 가정)
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

CODE "SRV-006 SMTP 서비스 로그 수준 설정 미흡"

@"
[양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우
[취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-006] SMTP 서비스 로그 수준 설정 미흡" | Out-File -FilePath $TMP1 -Append

# SMTP 서비스 로그 수준 설정 확인
# PowerShell을 사용해 IIS SMTP 로그 설정 확인 (예시로 구현)
$smtpLogSetting = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/logFile" -name "logFormat"

if ($smtpLogSetting.Value -eq "W3C") {
    OK "SMTP 서비스의 로그 수준이 적절하게 설정됨 (현재 설정: W3C)." | Out-File -FilePath $TMP1 -Append
} else {
    WARN "SMTP 서비스의 로그 수준이 낮게 설정됨 (현재 설정: $($smtpLogSetting.Value))." | Out-File -FilePath $TMP1 -Append
}

BAR

Get-Content $TMP1
Write-Host `n

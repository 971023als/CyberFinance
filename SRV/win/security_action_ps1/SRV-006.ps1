# 필요한 함수 로드
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

# SMTP 서비스 로그 수준 설정 조정
# IIS SMTP 서비스에 대한 로그 형식을 W3C로 설정
$smtpLogPath = 'MACHINE/WEBROOT/APPHOST'
$logFormatProperty = "system.applicationHost/sites/siteDefaults/logFile/logFormat"
$logFormatValue = "W3C"

# 현재 로그 설정 확인
$currentLogSetting = Get-WebConfigurationProperty -pspath $smtpLogPath -filter $logFormatProperty -name "Value"

# 로그 형식이 W3C가 아닌 경우, W3C로 변경
if ($currentLogSetting.Value -ne $logFormatValue) {
    Set-WebConfigurationProperty -pspath $smtpLogPath -filter $logFormatProperty -name "Value" -value $logFormatValue
    OK "SMTP 서비스의 로그 수준이 적절하게 설정됨 (W3C로 설정됨)." | Out-File -FilePath $TMP1 -Append
} else {
    OK "SMTP 서비스의 로그 수준이 이미 적절하게 설정됨 (현재 설정: W3C)." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력 및 로그 파일 내용 확인
Get-Content $TMP1
Write-Host `n

# PowerShell 스크립트 예시: IIS에서 서버 명령 실행 기능의 제한 설정 확인 및 조정

# IIS 웹 사이트의 이름 설정 (예: 'Default Web Site')
$siteName = "Default Web Site"

# CGI 및 FastCGI 설정 확인
$CGISettings = Get-WebConfigurationProperty -pspath "IIS:\Sites\$siteName" -filter "system.webServer/handlers" -name "."

# 서버 명령 실행을 허용하는 CGI 또는 FastCGI 핸들러 검색
$CGIScripts = $CGISettings.Collection | Where-Object { $_.scriptProcessor -like "*cgi.exe" -or $_.scriptProcessor -like "*fastcgi*" }

# 결과 출력
if ($CGIScripts.Count -gt 0) {
    Write-Host "WARN: IIS에서 서버 명령 실행이 허용될 수 있습니다."
    $CGIScripts | Format-Table -Property path, scriptProcessor
} else {
    Write-Host "OK: IIS에서 서버 명령 실행 기능이 적절하게 제한됩니다."
}

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-059.log"
"웹 서비스에서 서버 명령 실행 기능 제한 설정 점검 완료" | Out-File -FilePath $TMP1

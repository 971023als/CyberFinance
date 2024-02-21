# PowerShell 스크립트 예시: IIS 디렉터리 브라우징 비활성화

# IIS 웹 사이트의 이름을 지정합니다.
$siteName = "Default Web Site"

# 디렉터리 브라우징 기능을 비활성화합니다.
Set-WebConfigurationProperty -pspath "IIS:\Sites\$siteName" -filter "system.webServer/directoryBrowse" -name "enabled" -value $False

# 변경 사항을 확인합니다.
$directoryBrowseSetting = Get-WebConfigurationProperty -pspath "IIS:\Sites\$siteName" -filter "system.webServer/directoryBrowse" -name "enabled"
Write-Output "디렉터리 브라우징 설정: $($directoryBrowseSetting.Value)"

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-046.log"
"웹 서비스의 경로 설정이 안전하게 구성된 경우" | Out-File -FilePath $TMP1 -Append

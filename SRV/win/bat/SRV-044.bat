# 로그 파일 생성
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
$TMP1 = Join-Path $env:TEMP $TMP1
"" > $TMP1

# 로그 파일에 헤더 추가
Add-Content $TMP1 "코드 [SRV-044] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정"
Add-Content $TMP1 "[양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨"
Add-Content $TMP1 "[취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음"
Add-Content $TMP1 "---------------------------------------------------------"

# IIS에서 파일 업로드 크기 제한 확인
Import-Module WebAdministration

# 모든 사이트 순회
Get-Website | ForEach-Object {
    $siteName = $_.Name
    $configPath = "IIS:\Sites\$siteName"
    $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength"
    
    $maxSize = $requestFiltering.Value / 1024 / 1024 # 바이트에서 MB로 변환
    if ($maxSize -lt 30) { # 예시 임계값 30MB
        Add-Content $TMP1 "OK: `$siteName` 사이트는 파일 업로드를 $maxSize MB로 제한합니다."
    } else {
        Add-Content $TMP1 "WARN: `$siteName` 사이트는 파일 업로드 제한이 높음 ($maxSize MB) 또는 설정되지 않음."
    }
}

# 결과 표시
Get-Content $TMP1 | Out-Host

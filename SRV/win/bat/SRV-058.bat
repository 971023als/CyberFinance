# PowerShell 스크립트 예시: IIS에서 불필요한 스크립트 매핑 확인

# IIS 웹 사이트의 이름 설정 (예: 'Default Web Site')
$siteName = "Default Web Site"

# 스크립트 맵핑 확인
Import-Module WebAdministration
$scriptMaps = Get-WebHandler -PSPath "IIS:\Sites\$siteName"

# 불필요한 스크립트 매핑 조건을 정의 (예: .php 확장자를 가진 스크립트)
$unnecessaryScriptMappings = $scriptMaps | Where-Object { $_.Path -like "*.php" }

# 결과 출력
if ($unnecessaryScriptMappings.Count -gt 0) {
    Write-Host "WARN: IIS에서 불필요한 스크립트 매핑이 발견됨"
    $unnecessaryScriptMappings | Format-Table -Property Path, ScriptProcessor
} else {
    Write-Host "OK: IIS에서 불필요한 스크립트 매핑이 발견되지 않음"
}

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-058.log"
"웹 서비스의 불필요한 스크립트 매핑 점검 완료" | Out-File -FilePath $TMP1

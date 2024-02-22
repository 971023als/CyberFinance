# function.ps1 파일 포함
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-059_log.txt"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-059] IIS 웹 서비스 서버 명령 실행 기능 제한 설정 미흡"

$result = $TMP1
Add-Content -Path $result -Value "[양호]: IIS 웹 서비스에서 서버 명령 실행 기능이 적절하게 제한된 경우"
Add-Content -Path $result -Value "[취약]: IIS 웹 서비스에서 서버 명령 실행 기능의 제한이 미흡한 경우"

BAR

# IIS 웹 서비스의 서버 명령 실행 제한 설정 확인
Import-Module WebAdministration

# 설정된 모든 사이트의 핸들러 매핑을 확인
$siteNames = Get-ChildItem IIS:\Sites

foreach ($site in $siteNames) {
    $handlers = Get-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
    # 여기서는 예시로 CGI 및 PHP 스크립트 실행을 제한하는 설정을 확인합니다.
    # 실제 조건에 맞게 핸들러의 조건을 조정해야 합니다.
    $restrictedHandlers = $handlers.Collection | Where-Object { $_.scriptProcessor -match "cgi|php" }

    if ($restrictedHandlers) {
        WARN "IIS에서 $($site.Name)에 대해 서버 명령 실행이 허용될 수 있습니다."
    } else {
        OK "IIS에서 $($site.Name)에 대해 서버 명령 실행 기능이 적절하게 제한됩니다."
    }
}

Get-Content -Path $result | Out-Host

Write-Host "`n"

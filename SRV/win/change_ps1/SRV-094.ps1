function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-094] crontab 참조파일 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우"

BAR

# 이벤트 로그 종류를 배열로 정의합니다.
$logTypes = @("Application", "Security", "System")

foreach ($logType in $logTypes) {
    # 각 로그 종류의 설정을 확인합니다.
    $logConfig = Get-EventLog -LogName $logType -ErrorAction SilentlyContinue
    if ($null -ne $logConfig) {
        Add-Content -Path $global:TMP1 -Value "OK: $logType 로그가 존재하며, 정책이 설정되어 있습니다. 최대 크기: $($logConfig.MaximumKilobytes)KB, 보존 정책: $($logConfig.OverflowAction)"
    } else {
        Add-Content -Path $global:TMP1 -Value "WARN: $logType 로그는 시스템에 존재하지 않거나, 접근할 수 없습니다."
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

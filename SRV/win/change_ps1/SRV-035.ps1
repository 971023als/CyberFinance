# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-035_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "$message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 취약한 서비스가 비활성화된 경우
[취약]: 취약한 서비스가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 취약한 서비스 목록 예시 (Windows 환경에 맞게 수정 필요)
$services = @("Telnet", "RemoteRegistry", "lmhosts")

foreach ($service in $services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($null -ne $svc -and $svc.Status -eq 'Running') {
        Write-WARN "$service 서비스가 활성화되어 있습니다. 비활성화를 고려하세요."
    } else {
        Write-OK "$service 서비스는 비활성화되어 있거나 설치되지 않았습니다."
    }
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

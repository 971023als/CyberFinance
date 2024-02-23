# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-034_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

Write-OK "[양호]: 불필요한 서비스가 비활성화된 경우"

Write-BAR

# 불필요한 서비스 목록 예시
$unnecessaryServices = @("Telnet", "RemoteRegistry", "Fax")

foreach ($service in $unnecessaryServices) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($null -ne $svc -and $svc.Status -eq 'Running') {
        Write-WARN "불필요한 서비스 '$service'가 활성화되어 있습니다. 비활성화를 고려하세요."
    } else {
        Write-OK "서비스 '$service'는 비활성화되어 있거나 설치되지 않았습니다."
    }
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

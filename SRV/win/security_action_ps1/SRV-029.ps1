# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-029_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
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

Write-CODE "[양호]: SMB 서비스의 세션 중단 시간이 적절하게 설정된 경우"

Write-BAR

# SMB 세션 중단 시간 설정을 확인합니다.
$autoDisconnect = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "autodisconnect" -ErrorAction SilentlyContinue

if ($null -ne $autoDisconnect) {
    $value = $autoDisconnect.autodisconnect
    if ($value -ge 0) {
        Write-OK "SMB 세션 중단 시간(autodisconnect)이 적절하게 설정되어 있습니다: $value 분"
    }
    else {
        Write-WARN "SMB 세션 중단 시간(autodisconnect) 설정이 미비합니다."
    }
}
else {
    Write-WARN "SMB 세션 중단 시간(autodisconnect) 설정이 레지스트리에 존재하지 않습니다."
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

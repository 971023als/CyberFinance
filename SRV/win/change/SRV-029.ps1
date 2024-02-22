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

@"
[양호]: SMB 서비스의 세션 중단 시간이 적절하게 설정된 경우
[취약]: SMB 서비스의 세션 중단 시간 설정이 미비한 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# SMB 설정 파일을 확인합니다.
$SMB_CONF_FILE = "/etc/samba/smb.conf"

# SMB 세션 중단 시간 설정을 확인합니다.
# 여기서는 'deadtime' 설정을 예로 듭니다.
if (Get-Content $SMB_CONF_FILE | Select-String "^deadtime") {
    $deadtime = (Get-Content $SMB_CONF_FILE | Select-String "^deadtime").ToString().Split("=")[1].Trim()
    if ($deadtime -gt 0) {
        Write-OK "SMB 세션 중단 시간(deadtime)이 적절하게 설정되어 있습니다: $deadtime 분"
    }
    else {
        Write-WARN "SMB 세션 중단 시간(deadtime) 설정이 미비합니다."
    }
}
else {
    Write-WARN "SMB 세션 중단 시간(deadtime) 설정이 '$SMB_CONF_FILE' 파일에 존재하지 않습니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

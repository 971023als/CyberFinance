# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-031_log.txt"
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

@"
[양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우
[취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# SMB 설정 파일을 확인합니다.
$SMB_CONF_FILE = "/etc/samba/smb.conf"

# 공유 목록 및 계정 정보 노출을 방지하는 설정을 확인합니다.
# 예: 'enum shares', 'enum users' 설정을 확인
$SMBConfig = Get-Content $SMB_CONF_FILE
$ExposedSettings = $SMBConfig | Where-Object { $_ -match "(enum shares|enum users)" }

if ($ExposedSettings) {
    Write-WARN "SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다."
} else {
    Write-OK "SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

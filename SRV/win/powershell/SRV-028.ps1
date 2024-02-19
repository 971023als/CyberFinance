# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-028_log.txt"
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
[양호]: SSH 원격 터미널 접속 타임아웃이 적절하게 설정된 경우
[취약]: SSH 원격 터미널 접속 타임아웃이 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# SSH 설정 파일을 확인합니다.
$SSH_CONFIG_FILE = "/etc/ssh/sshd_config"

# ClientAliveInterval과 ClientAliveCountMax를 확인합니다.
# 이 값들은 무활동 상태의 SSH 세션을 얼마나 오랫동안 유지할지 결정합니다.
$ClientAliveInterval = Get-Content $SSH_CONFIG_FILE | Where-Object { $_ -match "^ClientAliveInterval" }
$ClientAliveCountMax = Get-Content $SSH_CONFIG_FILE | Where-Object { $_ -match "^ClientAliveCountMax" }

if ($ClientAliveInterval -and $ClientAliveCountMax) {
    Write-OK "SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다."
} else {
    Write-WARN "SSH 원격 터미널 타임아웃 설정이 미비합니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

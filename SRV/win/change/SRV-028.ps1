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

Write-CODE "[양호]: SSH 원격 터미널 접속 타임아웃이 적절하게 설정된 경우"

Write-BAR

# SSH 설정 파일 경로 지정
$SSHConfigFile = "C:\ProgramData\ssh\sshd_config"

if (Test-Path $SSHConfigFile) {
    $configContent = Get-Content $SSHConfigFile
    $ClientAliveInterval = $configContent | Where-Object { $_ -match "^ClientAliveInterval\s+\d+" }
    $ClientAliveCountMax = $configContent | Where-Object { $_ -match "^ClientAliveCountMax\s+\d+" }

    if ($ClientAliveInterval -and $ClientAliveCountMax) {
        Write-OK "SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다: `n$ClientAliveInterval`n$ClientAliveCountMax"
    } else {
        Write-WARN "SSH 원격 터미널 타임아웃 설정이 미비합니다."
    }
} else {
    Write-WARN "SSH 서버 구성 파일($SSHConfigFile)이 존재하지 않습니다."
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-026_log.txt"
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

Write-CODE "[양호]: 관리자 계정을 통한 SSH 원격 접속이 적절하게 제한된 경우"

Write-BAR

# Windows에서 OpenSSH 서버 구성 파일 확인
$SSHConfigFile = "C:\ProgramData\ssh\sshd_config"
if (Test-Path $SSHConfigFile) {
    # 관리자 계정의 원격 접속 제한 설정 확인
    $configContent = Get-Content $SSHConfigFile
    $adminAccessSetting = $configContent | Where-Object { $_ -match "Match User administrator" }
    if ($null -ne $adminAccessSetting) {
        Write-OK "관리자 계정을 통한 SSH 원격 접속이 적절하게 제한됩니다."
    } else {
        Write-WARN "SSH를 통한 관리자 계정의 원격 접속 제한 설정이 미흡합니다. 설정을 검토하세요."
    }
} else {
    Write-WARN "OpenSSH 서버 구성 파일($SSHConfigFile)이 존재하지 않습니다."
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

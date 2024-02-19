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

@"
[양호]: SSH를 통한 root 계정의 원격 접속이 제한된 경우
[취약]: SSH를 통한 root 계정의 원격 접속이 제한되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# SSH 설정 파일에서 root 로그인을 허용하는 설정을 확인합니다.
$SSHConfigFile = "/etc/ssh/sshd_config"
if (Test-Path $SSHConfigFile) {
    $PermitRootLogin = (Get-Content $SSHConfigFile | Where-Object {$_ -match "^\s*PermitRootLogin\s+yes"} )
    if ($null -ne $PermitRootLogin) {
        Write-WARN "SSH를 통한 root 계정의 원격 접속이 제한되지 않습니다."
    } else {
        Write-OK "SSH를 통한 root 계정의 원격 접속이 제한됩니다."
    }
} else {
    Write-WARN "SSH 설정 파일($SSHConfigFile)이 존재하지 않습니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

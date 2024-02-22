# 결과 파일 초기화
$TMP1 = "$(Get-Location)\$(($MyInvocation.MyCommand.Name).Replace('.ps1', '.log'))"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

@"
[양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우
[취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# Telnet 서비스 상태를 확인합니다.
$telnetService = Get-Service Telnet -ErrorAction SilentlyContinue

if ($null -ne $telnetService -and $telnetService.Status -eq 'Running') {
    # Telnet 서비스가 활성화된 경우, 추가적인 설정 확인이 필요할 수 있음
    WARN "Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다."
} else {
    OK "Telnet 서비스가 비활성화되어 있습니다."
}

Get-Content $TMP1 | Write-Output
Write-Host

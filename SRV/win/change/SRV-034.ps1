# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-034_log.txt"
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
[양호]: 불필요한 서비스가 비활성화된 경우
[취약]: 불필요한 서비스가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 불필요한 서비스 목록
$r_commands = @("rsh", "rlogin", "rexec", "shell", "login", "exec")

# /etc/xinetd.d 폴더 내의 서비스 파일들을 확인합니다.
if (Test-Path -Path "/etc/xinetd.d") {
    foreach ($command in $r_commands) {
        $filePath = "/etc/xinetd.d/$command"
        if (Test-Path -Path $filePath) {
            $content = Get-Content -Path $filePath
            $disabled = $content | Where-Object { $_ -match "disable\s*=\s*yes" }
            if (-not $disabled) {
                Write-WARN "불필요한 $command 서비스가 실행 중입니다."
                exit
            }
        }
    }
}

# /etc/inetd.conf 파일에서 서비스들을 확인합니다.
if (Test-Path -Path "/etc/inetd.conf") {
    $inetdConfContent = Get-Content -Path "/etc/inetd.conf"
    foreach ($command in $r_commands) {
        $enabled = $inetdConfContent | Where-Object { $_ -match $command -and -not $_.StartsWith('#') }
        if ($enabled) {
            Write-WARN "불필요한 $command 서비스가 실행 중입니다."
            exit
        }
    }
}

Write-OK "※ U-21 결과 : 양호(Good)"

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

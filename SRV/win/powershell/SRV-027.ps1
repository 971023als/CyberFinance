# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-027_log.txt"
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
[양호]: 서비스에 대한 IP 및 포트 접근 제한이 적절하게 설정된 경우
[취약]: 서비스에 대한 IP 및 포트 접근 제한이 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$HostsDenyPath = "/etc/hosts.deny"
$HostsAllowPath = "/etc/hosts.allow"

if (Test-Path $HostsDenyPath) {
    $DenyAllAll = Select-String -Path $HostsDenyPath -Pattern "ALL\s*:\s*ALL" -CaseSensitive
    if ($DenyAllAll) {
        if (Test-Path $HostsAllowPath) {
            $AllowAllAll = Select-String -Path $HostsAllowPath -Pattern "ALL\s*:\s*ALL" -CaseSensitive
            if ($AllowAllAll) {
                Write-WARN "/etc/hosts.allow 파일에 'ALL : ALL' 설정이 있습니다."
            } else {
                Write-OK "※ U-18 결과 : 양호(Good)"
            }
        } else {
            Write-OK "※ U-18 결과 : 양호(Good)"
        }
    } else {
        Write-WARN "/etc/hosts.deny 파일에 'ALL : ALL' 설정이 없습니다."
    }
} else {
    Write-WARN "/etc/hosts.deny 파일이 없습니다."
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function INFO {
    Param ([string]$message)
    "INFO: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-014] NFS 접근통제 미비"

@"
[양호]: 불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한한 경우
[취약]: 불필요한 NFS 서비스를 사용하거나, 불가피하게 사용 시 everyone 공유를 제한하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# NFS 서비스 실행 여부 확인
$NfsProcesses = Get-Process | Where-Object { $_.ProcessName -match "nfs|rpc.statd|statd|rpc.lockd|lockd" } | Measure-Object

if ($NfsProcesses.Count -gt 0) {
    if (Test-Path "/etc/exports") {
        $ExportsContent = Get-Content "/etc/exports"
        $AllCount = ($ExportsContent | Where-Object { $_ -match "/" -and $_ -match "\*" }).Count
        $InsecureCount = ($ExportsContent | Where-Object { $_ -match "/" -and $_ -match "insecure" }).Count
        $DirectoryCount = ($ExportsContent | Where-Object { $_ -match "/" }).Count
        $SquashCount = ($ExportsContent | Where-Object { $_ -match "/" -and $_ -match "root_squash|all_squash" }).Count

        if ($AllCount -gt 0) {
            WARN "/etc/exports 파일에 '*' 설정이 있습니다."
            INFO "설정 = 모든 클라이언트에 대해 전체 네트워크 공유 허용"
        } elseif ($InsecureCount -gt 0) {
            WARN "/etc/exports 파일에 'insecure' 옵션이 설정되어 있습니다."
        } else {
            if ($DirectoryCount -ne $SquashCount) {
                WARN "/etc/exports 파일에 'root_squash' 또는 'all_squash' 옵션이 설정되어 있지 않습니다."
            }
        }
    }
} else {
    OK "불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한"
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host

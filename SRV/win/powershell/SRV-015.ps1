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

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-015] 불필요한 NFS 서비스 실행"

@"
[양호]: 불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있는 경우
[취약]: 불필요한 NFS 서비스 관련 데몬이 활성화 되어 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# NFS 서비스 관련 데몬의 실행 여부 확인
$NfsDaemonCount = Get-Process | Where-Object { $_.ProcessName -match "nfs|rpc.statd|statd|rpc.lockd|lockd" } | Measure-Object

if ($NfsDaemonCount.Count -gt 0) {
    WARN "불필요한 NFS 서비스 관련 데몬이 실행 중입니다."
} else {
    OK "불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있습니다."
}

Get-Content $TMP1 | Write-Output
Write-Host

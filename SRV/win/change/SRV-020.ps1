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

Function INFO {
    Param ([string]$message)
    "INFO: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-020] 공유에 대한 접근 통제 미비"

@"
[양호]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 적절하게 설정된 경우
[취약]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 미비한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# PowerShell에서는 NFS 및 SMB 공유 접근 통제 검사 방법이 다릅니다.
# NFS 공유 목록을 확인합니다 (Windows에서 NFS 서버 구성 확인이 필요한 경우).
# SMB/CIFS 공유 목록을 PowerShell을 사용하여 확인합니다.

Function Check-AccessControl {
    Param (
        [string]$serviceName,
        [string]$shareType
    )

    If ($shareType -eq "SMB") {
        $shares = Get-SmbShare
        $looseShares = $shares | Where-Object { $_.Name -like "*everyone*" -or $_.Name -like "*public*" }

        If ($looseShares) {
            $looseShares | ForEach-Object {
                WARN "$serviceName 서비스에서 느슨한 공유 접근 통제가 발견됨: $($_.Name)"
            }
        } Else {
            OK "$serviceName 서비스에서 공유 접근 통제가 적절함"
        }
    } ElseIf ($shareType -eq "NFS") {
        # Windows에서 NFS 공유 검사는 다른 접근 방법이 필요할 수 있습니다.
        INFO "Windows에서 NFS 공유 접근 통제 검사는 지원되지 않을 수 있습니다."
    }
}

Check-AccessControl -serviceName "NFS" -shareType "NFS"
Check-AccessControl -serviceName "SMB/CIFS" -shareType "SMB"

Get-Content $TMP1 | Write-Output
Write-Host

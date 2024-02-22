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

CODE "[SRV-022] 원격 접근 제어 설정 미비 및 공유 폴더 접근 권한 미설정"

BAR

# 원격 데스크톱 접근 설정 점검
$RDPStatus = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\').fDenyTSConnections
if ($RDPStatus -eq 1) {
    OK "원격 데스크톱 접근이 비활성화되어 있습니다."
} else {
    WARN "원격 데스크톱 접근이 활성화되어 있습니다. 접근 제어 설정을 검토하세요."
}

# 공유 폴더 권한 설정 점검
$Shares = Get-SmbShare | Where-Object { $_.Name -notmatch '^(ADMIN\$|C\$|IPC\$)' }
foreach ($Share in $Shares) {
    $Permissions = Get-SmbShareAccess -Name $Share.Name
    $EveryonePermission = $Permissions | Where-Object { $_.AccountName -eq 'Everyone' }
    if ($null -ne $EveryonePermission) {
        WARN "공유 폴더 '$($Share.Name)'에 Everyone 권한이 부여되어 있습니다."
    } else {
        OK "공유 폴더 '$($Share.Name)'의 권한 설정이 적절합니다."
    }
}

BAR

# 최종 결과 출력
Get-Content $TMP1 | Write-Host

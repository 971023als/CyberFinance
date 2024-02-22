# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-031_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
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
[양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우
[취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 네트워크 보안: LAN Manager 인증 수준 점검
$lmAuthLevel = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -ErrorAction SilentlyContinue
if ($null -ne $lmAuthLevel -and $lmAuthLevel -ge 3) {
    Write-OK "네트워크 보안: LAN Manager 인증 수준이 적절하게 설정되어 있습니다. (값: $lmAuthLevel)"
} else {
    Write-WARN "네트워크 보안: LAN Manager 인증 수준 설정이 미비합니다. (권장 값: 3 이상)"
}

# SMB 서명 요구사항 점검
$smbSigningRequired = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "requiresecuritysignature" -ErrorAction SilentlyContinue
if ($null -ne $smbSigningRequired -and $smbSigningRequired -eq 1) {
    Write-OK "SMB 서명 요구사항이 적절하게 설정되어 있습니다."
} else {
    Write-WARN "SMB 서명 요구사항이 설정되지 않았습니다. (권장: 활성화)"
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

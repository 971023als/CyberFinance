# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_NetworkServiceAccessRestrictions.log"

# Windows Firewall에서 인바운드 규칙 확인
$inboundRules = Get-NetFirewallRule -Direction Inbound | Where-Object { $_.Enabled -eq "True" -and $_.Action -eq "Block" }

if ($inboundRules.Count -gt 0) {
    "OK: 네트워크 서비스의 접근 제한이 적절히 설정되었습니다." | Out-File -FilePath $TMP1
    foreach ($rule in $inboundRules) {
        "제한된 인바운드 규칙: $($rule.DisplayName)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "WARN: 네트워크 서비스의 접근 제한이 설정되지 않았습니다." | Out-File -FilePath $TMP1
}

# 결과 파일 출력
Get-Content -Path $TMP1

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

Write-CODE "[양호]: 서비스에 대한 IP 및 포트 접근 제한이 적절하게 설정된 경우"

Write-BAR

# Windows 방화벽 규칙 점검
$FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.Action -eq "Block" }

if ($FirewallRules.Count -gt 0) {
    foreach ($rule in $FirewallRules) {
        $ruleName = $rule.Name
        $ruleDisplayName = $rule.DisplayName
        Write-OK "방화벽 규칙 '$ruleDisplayName'($ruleName)에 의해 특정 인바운드 트래픽이 차단됩니다."
    }
} else {
    Write-WARN "인바운드 트래픽을 차단하는 활성화된 방화벽 규칙이 없습니다."
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Host

# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_TCPSecuritySettings.log"
New-Item -Path $TMP1 -ItemType File

# 고급 보안 구성된 Windows 방화벽 규칙 확인
$firewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.Action -eq 'Block' -or $_.Action -eq 'Allow' }

# 파일에 결과 저장
foreach ($rule in $firewallRules) {
    $ruleDisplay = "규칙 이름: $($rule.Name), 방향: $($rule.Direction), 액션: $($rule.Action), 프로토콜: $($rule.Protocol), 로컬 포트: $($rule.LocalPort)"
    if ($rule.Action -eq 'Block') {
        "WARN: 차단된 규칙 - $ruleDisplay" | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: 허용된 규칙 - $ruleDisplay" | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일이 비어 있으면, 적절한 TCP 보안 설정이 구성되지 않았다고 가정
if (!(Get-Content -Path $TMP1)) {
    "INFO: 고급 보안에 구성된 TCP 관련 Windows 방화벽 규칙이 없습니다." | Out-File -FilePath $TMP1
}

# 결과 파일 출력
Get-Content -Path $TMP1

# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-003] SNMP 접근 통제 미설정" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP 접근 제어가 적절하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP 접근 제어가 설정되지 않거나 미흡한 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    # SNMP 접근 통제 설정 확인
    $snmpRegPathACL = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers'
    $snmpACLs = Get-ItemProperty -Path $snmpRegPathACL -ErrorAction SilentlyContinue
    if ($snmpACLs -eq $null) {
        "SNMP 접근 통제 설정이 발견되지 않았습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        $aclCount = 0
        foreach ($acl in $snmpACLs.PSObject.Properties.Name) {
            if ($acl -notmatch '^(PSPath|PSParentPath|PSChildName|PSDrive|PSProvider)$') {
                $aclCount++
                "허용된 관리자: $($snmpACLs.$acl)" | Out-File -FilePath $TMP1 -Append
            }
        }
        if ($aclCount -gt 0) {
            "양호: SNMP 접근 제어가 적절하게 설정되었습니다." | Out-File -FilePath $TMP1 -Append
        } else {
            "취약: SNMP 접근 제어가 설정되지 않았습니다." | Out-File -FilePath $TMP1 -Append
        }
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-001] SNMP 서비스 Get Community 스트링 설정 오류" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    # SNMP 설정 확인
    $snmpRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'
    $snmpCommunities = Get-ItemProperty -Path $snmpRegPath -ErrorAction SilentlyContinue
    if ($snmpCommunities -eq $null) {
        "SNMP Community 스트링 설정을 찾을 수 없습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        $vulnerable = $false
        foreach ($community in $snmpCommunities.PSObject.Properties.Name) {
            if ($community -eq 'public' -or $community -eq 'private') {
                "취약: 기본 SNMP Community 스트링($community)이 사용되고 있습니다." | Out-File -FilePath $TMP1 -Append
                $vulnerable = $true
                break
            }
        }
        if (-not $vulnerable) {
            "양호: 기본 SNMP Community 스트링이 사용되지 않습니다." | Out-File -FilePath $TMP1 -Append
        }
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

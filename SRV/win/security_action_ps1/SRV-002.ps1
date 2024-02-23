# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-002] SNMP 서비스 Set Community 스트링 설정 오류" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP Set Community 스트링이 복잡하고 예측 불가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP Set Community 스트링이 기본값이거나 예측 가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    # SNMP 설정 확인
    $snmpRegPathSet = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'
    $snmpCommunitiesSet = Get-ItemProperty -Path $snmpRegPathSet -ErrorAction SilentlyContinue
    if ($snmpCommunitiesSet -eq $null) {
        "SNMP Set Community 스트링 설정을 찾을 수 없습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        $isVulnerableSet = $false
        foreach ($community in $snmpCommunitiesSet.PSObject.Properties) {
            if ($community.Value -eq 4) { # 여기서 4는 쓰기 권한을 가리키는 값입니다. 실제 환경에 따라 조정이 필요할 수 있습니다.
                "취약: SNMP Set Community 스트링($($community.Name))이 기본값 또는 예측 가능한 값으로 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
                $isVulnerableSet = $true
                break
            }
        }
        if (-not $isVulnerableSet) {
            "양호: SNMP Set Community 스트링이 기본값 또는 예측 가능한 값으로 설정되지 않았습니다." | Out-File -FilePath $TMP1 -Append
        }
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output

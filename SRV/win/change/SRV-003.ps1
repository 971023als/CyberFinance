# 필요한 함수 로드
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

# SNMP 접근 통제 설정
$SNMPD_CONF = "C:\Path\To\snmpd.conf" # 실제 경로로 수정
$ACCESS_CONTROL_STRING = "com2sec notConfigUser  default       public"

# 설정 파일 존재 여부 확인
if (Test-Path $SNMPD_CONF) {
    # com2sec 설정이 이미 적절하게 설정되어 있는지 확인
    if (-not (Select-String -Path $SNMPD_CONF -Pattern "^com2sec" -Quiet)) {
        # com2sec 설정 추가
        "$ACCESS_CONTROL_STRING`n" | Out-File -FilePath $SNMPD_CONF -Append

        # 로그 파일에 양호한 결과 기록
        BAR | Out-File -FilePath $TMP1 -Append
        OK "SNMP 접근 제어가 적절하게 설정됨" | Out-File -FilePath $TMP1 -Append
        BAR | Out-File -FilePath $TMP1 -Append
    } else {
        # 이미 적절하게 설정된 경우, 로그 파일에 기록
        OK "SNMP 접근 제어가 이미 적절하게 설정됨" | Out-File -FilePath $TMP1 -Append
    }
} else {
    # 설정 파일이 존재하지 않는 경우, 로그 파일에 경고 기록
    WARN "SNMP 설정 파일($SNMPD_CONF)을 찾을 수 없음" | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

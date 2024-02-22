# 필요한 함수 로드 (PowerShell 스크립트로 가정)
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

CODE "SRV-003 SNMP 접근 통제 미설정"

# 로그 파일에 내용 추가
@"
[양호]: SNMP 접근 제어가 적절하게 설정된 경우
[취약]: SNMP 접근 제어가 설정되지 않거나 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-003] SNMP 접근 통제 미설정" | Out-File -FilePath $TMP1 -Append

$SNMPD_CONF = "C:\Path\To\snmpd.conf"  # Windows 환경에 맞는 경로 설정 필요
$ACCESS_CONTROL_STRING = "com2sec"

# SNMPD 설정 파일에서 com2sec가 적절하게 설정되었는지 확인
if (Select-String -Path $SNMPD_CONF -Pattern "^$ACCESS_CONTROL_STRING" -Quiet) {
    # 추가적인 확인 로직을 넣을 수 있습니다, 예를 들어:
    # if (Select-String -Path $SNMPD_CONF -Pattern "^$ACCESS_CONTROL_STRING\s+[^default]" -Quiet) {
    OK "SNMP 접근 제어가 적절하게 설정됨" | Out-File -FilePath $TMP1 -Append
} else {
    WARN "SNMP 접근 제어가 설정되지 않음" | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

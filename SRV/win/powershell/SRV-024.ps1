# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-024] 취약한 Telnet 인증 방식 사용" | Out-File -FilePath $TMP1 -Append
@"
[양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우
[취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# Telnet 서비스 상태 확인
$TelnetService = Get-Service -Name 'TlntSvr' -ErrorAction SilentlyContinue
if ($TelnetService -and $TelnetService.Status -eq 'Running') {
    "WARN: Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다." | Out-File -FilePath $TMP1 -Append
    # Telnet 보안 인증 방식 확인 로직 (가정)
    # 여기에 Telnet 서비스의 보안 인증 방식을 확인하는 PowerShell 스크립트 추가
    # 실제 환경에서는 해당 설정을 직접 확인하는 명령어로 대체
    $TelnetSecurity = '가정된 보안 설정 확인 결과'
    if ($TelnetSecurity -eq '보안 인증 방식 사용') {
        "OK: Telnet 서비스가 보안 인증 방식을 사용하고 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: Telnet 서비스가 보안 인증 방식을 사용하지 않고 있습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: Telnet 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Output

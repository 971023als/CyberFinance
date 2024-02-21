@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-024] 취약한 Telnet 인증 방식 사용 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우 >> !TMP1!
echo [취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: Telnet 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $TelnetService = Get-Service -Name 'TlntSvr' -ErrorAction SilentlyContinue;
    if ($TelnetService -and $TelnetService.Status -eq 'Running') {
        Add-Content !TMP1! 'WARN: Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다.';
    } else {
        Add-Content !TMP1! 'OK: Telnet 서비스가 비활성화되어 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.

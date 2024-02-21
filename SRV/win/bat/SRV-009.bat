@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-009] SMTP 서비스의 스팸 메일 릴레이 제한 미설정 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우 >> !TMP1!
echo [취약]: SMTP 서비스를 사용하거나 릴레이 제한이 설정이 없는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMTP 릴레이 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # 예시: Exchange 서버 릴레이 설정 확인
    $RelayRestrictions = Get-ReceiveConnector | Select-Object -ExpandProperty RelayRestrictions;
    If ($RelayRestrictions -contains 'None') {
        Add-Content !TMP1! 'WARN: SMTP 서비스의 릴레이 제한이 설정되어 있지 않습니다.';
    } Else {
        Add-Content !TMP1! 'OK: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.

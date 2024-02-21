@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-006] SMTP 서비스 로그 수준 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우 >> !TMP1!
echo [취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMTP 로그 설정 확인 (PowerShell 사용 예시)
powershell -Command "& { # PowerShell 코드를 여기에 추가; 로그 수준 확인 등
    $SMTPLogSetting = '여기에 SMTP 로그 설정 확인 코드 입력';
    If ($SMTPLogSetting -eq '적절한 설정') {
        Add-Content !TMP1! 'SMTP 서비스의 로그 수준이 적절하게 설정됨.'
    } Else {
        Add-Content !TMP1! 'SMTP 서비스의 로그 수준이 낮게 설정됨.'
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.

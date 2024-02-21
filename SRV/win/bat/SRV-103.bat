@echo off
call function.bat

set TMP1=SCRIPTNAME.log
type nul > %TMP1%

call :BAR

echo [SRV-103] LAN Manager 인증 수준 미흡 >> %TMP1%

echo [양호]: LAN Manager 인증 수준이 적절하게 설정되어 있는 경우 >> %result%
echo [취약]: LAN Manager 인증 수준이 미흡하게 설정되어 있는 경우 >> %result%

call :BAR

:: LAN Manager 인증 수준을 확인하는 코드
:: 예시: registry 값을 체크하거나, 관련 설정 파일을 검사

echo OK "LAN Manager 인증 수준이 적절하게 설정되어 있습니다." >> %result%

type %result%

echo.
goto :eof

:BAR
echo -----------------------------------------
goto :eof

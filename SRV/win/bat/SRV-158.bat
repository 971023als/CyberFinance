@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-158] 불필요한 Telnet 서비스 실행 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: Telnet 서비스가 비활성화되어 있는 경우 >> %TMP1%
echo [취약]: Telnet 서비스가 활성화되어 있는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: Telnet 서비스의 상태 확인
sc query TlntSvr | findstr /C:"STATE" >> %TMP1%
if %ERRORLEVEL% == 0 (
    echo WARN: Telnet 서비스가 실행 중입니다. >> %TMP1%
) else (
    echo OK: Telnet 서비스가 비활성화되어 있습니다. >> %TMP1%
)

:: 여기에 FTP 서비스 관련 파일 확인 로직을 추가할 수 있음
:: Windows에서는 FTP 설정 파일의 직접적인 위치와 이름이 시스템에 따라 다를 수 있으므로,
:: 특정 경로의 파일 존재 여부를 확인하는 대신 서비스 상태를 확인하는 것이 일반적임

type %TMP1%

echo.
echo.

endlocal

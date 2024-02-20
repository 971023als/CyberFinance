@echo off
SetLocal EnableDelayedExpansion

set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

echo BAR >> "%TMP1%"
echo CODE [SRV-171] FTP 서비스 정보 노출 >> "%TMP1%"
echo [양호]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우 >> "%TMP1%"
echo [취약]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되는 경우 >> "%TMP1%"
echo BAR >> "%TMP1%"

:: FTP 서비스 실행 상태 확인
for /f "tokens=*" %%i in ('sc query ftpsvc ^| findstr /C:"RUNNING"') do (
    set "serviceStatus=%%i"
    if not "!serviceStatus!"==

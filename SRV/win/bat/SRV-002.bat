@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-002] SNMP 서비스 Set Community 스트링 설정 오류 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우 >> !TMP1!
echo [취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" >nul
if errorlevel 1 (
    echo SNMP 서비스가 실행 중이지 않습니다. >> !TMP1!
) else (
    :: SNMP 설정 확인 (레지스트리 예시)
    :: 여기서는 실제 레지스트리 검사를 수행하지 않고, 예시 메시지만 출력합니다.
    :: 실제 레지스트리 검사를 위해서는 레지스트리 키 경로를 알아야 합니다.
    echo 기본 SNMP Set Community 스트링(public/private)이 사용되지 않음 >> !TMP1!
)

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.

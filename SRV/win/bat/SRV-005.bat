@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우 >> !TMP1!
echo [취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: Windows 환경에서 SMTP 서비스 확인 및 expn, vrfy 명령어 제한 여부 검사
:: PowerShell을 사용하여 검사할 수 있는 예시 명령어
powershell -Command "& {If (Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue) {echo 'SMTP 서비스가 실행 중입니다.' >> !TMP1!} else {echo 'SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다.' >> !TMP1!}}" 

:: SMTP 설정 확인을 위한 추가 PowerShell 스크립트 필요
:: 예: Exchange 서버의 경우, 설정을 직접 조회하여 expn/vrfy 설정 확인

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.

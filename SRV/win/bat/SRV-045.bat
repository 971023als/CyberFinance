@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%" echo 결과 로그 파일

:: 서비스 실행 계정 변경 (예: IIS 서비스 'W3SVC')
set "ServiceName=W3SVC"
set "AccountName=NetworkService"

echo %ServiceName% 서비스의 실행 계정을 %AccountName%로 변경 중... >> "%TMP1%"

:: sc 명령어를 사용하여 서비스 실행 계정 변경
sc config %ServiceName% obj= "%AccountName%" password= ""

:: 변경 결과 확인
if %ERRORLEVEL% equ 0 (
    echo 변경 성공: %ServiceName% 서비스의 실행 계정이 %AccountName%로 변경되었습니다. >> "%TMP1%"
) else (
    echo 변경 실패: %ServiceName% 서비스의 실행 계정 변경에 실패했습니다. >> "%TMP1%"
)

type "%TMP1%"

echo.

@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-048] 불필요한 웹 서비스 실행 >> "%TMP1%"
echo [양호]: 불필요한 웹 서비스가 실행되지 않음 >> "%TMP1%"
echo [취약]: 불필요한 웹 서비스가 실행됨 >> "%TMP1%"

:: 아파치 서비스 디렉토리 및 불필요한 'manual' 디렉토리 예시 검사
set "APACHE_CONFIG_PATH=C:\Apache24\conf"
set "APACHE_ROOT=C:\Apache24"

:: 아파치 루트 디렉토리에 'manual' 디렉토리가 있는지 확인
if exist "%APACHE_ROOT%\htdocs\manual\" (
    echo 경고: 아파치 홈 디렉토리 내에 불필요한 'manual' 디렉토리가 발견됨. >> "%TMP1%"
) else (
    echo OK: 아파치 홈 디렉토리 내에 불필요한 'manual' 디렉토리가 발견되지 않음. >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.

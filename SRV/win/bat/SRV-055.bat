@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-055] 웹 서비스 설정 파일 노출 >> "%TMP1%"
echo [양호]: 웹 서비스 설정 파일이 외부에서 접근 불가능함 >> "%TMP1%"
echo [취약]: 웹 서비스 설정 파일이 외부에서 접근 가능함 >> "%TMP1%"

:: Apache 및 Nginx 설정 파일의 예시 경로 (필요에 따라 조정)
set "APACHE_CONFIG=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG=C:\path\to\nginx\conf\nginx.conf"

:: Apache 설정 파일 권한 확인
if exist "%APACHE_CONFIG%" (
    icacls "%APACHE_CONFIG%" | findstr /C:"Everyone:(N)" >nul
    if not errorlevel 1 (
        echo 경고: Apache 설정 파일 (%APACHE_CONFIG%) 권한이 취약함. >> "%TMP1%"
    ) else (
        echo OK: Apache 설정 파일 (%APACHE_CONFIG%)이 외부 접근으로부터 보호됨. >> "%TMP1%"
    )
) else (
    echo 정보: Apache 설정 파일 (%APACHE_CONFIG%)이 존재하지 않음. >> "%TMP1%"
)

:: Nginx 설정 파일 권한 확인
if exist "%NGINX_CONFIG%" (
    icacls "%NGINX_CONFIG%" | findstr /C:"Everyone:(N)" >nul
    if not errorlevel 1 (
        echo 경고: Nginx 설정 파일 (%NGINX_CONFIG%) 권한이 취약함. >> "%TMP1%"
    ) else (
        echo OK: Nginx 설정 파일 (%NGINX_CONFIG%)이 외부 접근으로부터 보호됨. >> "%TMP1%"
    )
) else (
    echo 정보: Nginx 설정 파일 (%NGINX_CONFIG%)이 존재하지 않음. >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.

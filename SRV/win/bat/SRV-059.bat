@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo 코드 [SRV-059] 웹 서비스 서버 명령 실행 기능 제한 미흡 >> "%TMP1%"
echo [양호]: 웹 서비스에서 서버 명령 실행 기능이 적절하게 제한됨 >> "%TMP1%"
echo [취약]: 웹 서비스에서 서버 명령 실행 기능이 불충분하게 제한됨 >> "%TMP1%"

:: Windows에서 Apache와 Nginx 설정 파일 경로 설정
set "APACHE_CONFIG_FILE=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG_FILE=C:\path\to\nginx\conf\nginx.conf"

:: Apache에서 서버 명령 실행 제한 확인
findstr /R "^[ \t]*ScriptAlias" "%APACHE_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo 경고: Apache에서 서버 명령 실행이 허용될 수 있음: %APACHE_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Apache에서 서버 명령 실행 기능이 적절하게 제한됨: %APACHE_CONFIG_FILE% >> "%TMP1%"
)

:: Nginx에서 FastCGI 스크립트 실행 제한 확인
findstr /R "fastcgi_pass" "%NGINX_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo 경고: Nginx에서 FastCGI를 통한 서버 명령 실행이 허용될 수 있음: %NGINX_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Nginx에서 서버 명령 실행 기능이 적절하게 제한됨: %NGINX_CONFIG_FILE% >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.

@echo off
setlocal enabledelayedexpansion

REM 설정 파일 경로 지정
set "CONFIG_FILE=C:\path\to\web_service\config.ini"

REM 기본 계정 정보 확인
set "DEFAULT_USER=admin"
set "DEFAULT_PASS=password"

REM 파일 존재 여부 확인
if not exist "%CONFIG_FILE%" (
    echo 설정 파일이 존재하지 않습니다: %CONFIG_FILE%
    goto end
)

REM 기본 계정(아이디 또는 비밀번호) 변경 여부 확인
findstr /C:"username=%DEFAULT_USER%" /C:"password=%DEFAULT_PASS%" "%CONFIG_FILE%" >nul

if errorlevel 1 (
    echo OK: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되었습니다: %CONFIG_FILE%
) else (
    echo WARN: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않았습니다: %CONFIG_FILE%
)

:end
endlocal

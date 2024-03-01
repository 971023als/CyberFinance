@echo off
setlocal

echo ==================================================
echo CODE [DBM-009] 사용되지 않는 세션 종료 미흡
echo ==================================================

set /p DB_TYPE="지원하는 데이터베이스: MySQL, PostgreSQL. 사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    set /p MYSQL_USER="Enter MySQL username: "
    set /p MYSQL_PASS="Enter MySQL password: "
    for /f "tokens=*" %%i in ('mysql -u%MYSQL_USER% -p%MYSQL_PASS% -Bse "SHOW VARIABLES LIKE 'wait_timeout';"') do set SESSION_TIMEOUT=%%i
) else if "%DB_TYPE%"=="PostgreSQL" (
    set /p PGSQL_USER="Enter PostgreSQL username: "
    set /p PGSQL_PASS="Enter PostgreSQL password: "
    for /f "tokens=*" %%i in ('psql -U %PGSQL_USER% -c "SHOW idle_in_transaction_session_timeout;"') do set SESSION_TIMEOUT=%%i
) else (
    echo Unsupported database type.
    goto end
)

echo Session timeout settings:
if "%SESSION_TIMEOUT%"=="" (
    echo WARNING: 세션 종료 시간이 설정되어 있지 않습니다.
) else (
    for /f "tokens=1,2 delims== " %%a in ("%SESSION_TIMEOUT%") do (
        set TIMEOUT_NAME=%%a
        set TIMEOUT_VALUE=%%b
    )
    if %TIMEOUT_VALUE% LEQ 300 (
        echo OK: 세션 종료 시간이 적절히 설정되어 있습니다: %TIMEOUT_VALUE% seconds.
    ) else (
        echo WARNING: 세션 종료 시간이 너무 길게 설정되어 있습니다: %TIMEOUT_VALUE% seconds.
    )
)

:end
echo ==================================================
pause

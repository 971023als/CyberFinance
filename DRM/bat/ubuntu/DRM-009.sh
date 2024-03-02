@echo off
setlocal

echo ==================================================
echo CODE [DBM-009] 사용되지 않는 세션 종료 미흡
echo ==================================================

set /p DB_TYPE="지원하는 데이터베이스: MySQL, PostgreSQL. 사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    set /p MYSQL_USER="Enter MySQL username: "
    set /p MYSQL_PASS="Enter MySQL password: "
    echo Checking session timeout settings for MySQL...
    for /f "tokens=1,2" %%a in ('mysql -u%MYSQL_USER% -p%MYSQL_PASS% -Bse "SHOW VARIABLES LIKE 'wait_timeout';"') do (
        set TIMEOUT_NAME=%%a
        set TIMEOUT_VALUE=%%b
    )
) else if "%DB_TYPE%"=="PostgreSQL" (
    set /p PGSQL_USER="Enter PostgreSQL username: "
    set /p PGSQL_PASS="Enter PostgreSQL password: "
    echo Checking session timeout settings for PostgreSQL...
    for /f "tokens=2,3 delims=|" %%a in ('psql -U %PGSQL_USER% -w%PGSQL_PASS% -t -c "SHOW idle_in_transaction_session_timeout;"') do (
        set TIMEOUT_NAME=idle_in_transaction_session_timeout
        set TIMEOUT_VALUE=%%a
    )
) else (
    echo Unsupported database type.
    goto end
)

echo Session timeout settings:
if not defined TIMEOUT_VALUE (
    echo WARNING: 세션 종료 시간이 설정되어 있지 않습니다.
) else (
    if %TIMEOUT_VALUE% LEQ 300 (
        echo OK: 세션 종료 시간이 적절히 설정되어 있습니다: %TIMEOUT_VALUE% seconds.
    ) else (
        echo WARNING: 세션 종료 시간이 너무 길게 설정되어 있습니다: %TIMEOUT_VALUE% seconds.
    )
)

:end
echo ==================================================
pause

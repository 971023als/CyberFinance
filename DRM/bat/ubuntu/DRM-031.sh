@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. SQL Server
echo 2. MySQL
echo 3. PostgreSQL
set /p DB_TYPE="데이터베이스 유형 번호를 입력하세요 (1-3): "

set /p DB_ADMIN="데이터베이스 관리자 사용자 이름을 입력하세요: "
:: 참고: 배치 스크립트는 비밀번호를 숨긴 입력을 지원하지 않습니다.
:: 환경 변수 또는 다른 방법을 사용하여 비밀번호를 안전하게 관리하세요.

if "%DB_TYPE%"=="1" (
    set /p DB_PASS="SQL Server 데이터베이스 관리자 비밀번호를 입력하세요: "
    sqlcmd -U %DB_ADMIN% -P %DB_PASS% -Q "SELECT name FROM sys.sql_logins WHERE name = 'sa';"
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else if "%DB_TYPE%"=="2" (
    set /p DB_PASS="MySQL 데이터베이스 관리자 비밀번호를 입력하세요: "
    mysql -u %DB_ADMIN% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User = 'root';"
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else if "%DB_TYPE%"=="3" (
    set /p DB_PASS="PostgreSQL 데이터베이스 관리자 비밀번호를 입력하세요: "
    psql -U %DB_ADMIN% -c "SELECT rolname FROM pg_roles WHERE rolname = 'postgres';"
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal

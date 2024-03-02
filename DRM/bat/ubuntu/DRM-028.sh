@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
echo 데이터베이스 유형 번호를 입력하세요.
set /p DBType=": "

if "%DBType%"=="1" (
    set /p DBUser="MySQL 사용자 이름을 입력하세요: "
    set /p DBPass="MySQL 비밀번호를 입력하세요: "
    set Query=SHOW TABLES;
    mysql -u %DBUser% -p%DBPass% -e "%Query%"
    if errorlevel 1 (
        echo MySQL 데이터베이스 연결 오류가 발생했습니다.
    )
) else if "%DBType%"=="2" (
    set /p DBUser="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DBPass="PostgreSQL 비밀번호를 입력하세요: "
    set Query=SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';
    psql -U %DBUser% -w %DBPass% -c "%Query%"
    if errorlevel 1 (
        echo PostgreSQL 데이터베이스 연결 오류가 발생했습니다.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal

@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DBType="데이터베이스 유형 번호를 입력하세요: "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "
set DBHost=localhost

if "%DBType%"=="1" (
    echo MySQL 자원 한계를 확인 중...
    mysql -u %DBUser% -p%DBPass% -h %DBHost% -e "SHOW VARIABLES LIKE 'max_connections';"
    if %ERRORLEVEL% neq 0 (
        echo 오류: MySQL 자원 한계를 검색하지 못했습니다.
    )
) else if "%DBType%"=="2" (
    echo PostgreSQL 자원 한계를 확인 중...
    psql -U %DBUser% -h %DBHost% -W %DBPass% -c "SHOW max_connections;"
    if %ERRORLEVEL% neq 0 (
        echo 오류: PostgreSQL 자원 한계를 검색하지 못했습니다.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal

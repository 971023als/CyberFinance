@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
echo 3. Oracle
echo.

set /p DBType="데이터베이스 유형 번호를 입력하세요: "
set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL 버전 확인 중...
    mysql -u %DBUser% -p%DBPass% -e "SELECT VERSION();" > temp.txt
    findstr /V "VERSION" temp.txt
    del temp.txt
) else if "%DBType%"=="2" (
    echo PostgreSQL 버전 확인 중...
    psql -U %DBUser% -c "SELECT version();" > temp.txt
    findstr "PostgreSQL" temp.txt
    del temp.txt
) else if "%DBType%"=="3" (
    echo Oracle 데이터베이스 버전 확인은 특정 환경에 따라 구현해야 합니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal
pause

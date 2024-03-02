@echo off
setlocal

echo ============================================
echo CODE [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용 확인
echo ============================================
echo [양호]: 현재 사용 중인 데이터베이스 버전이 지원되는 경우
echo [취약]: 현재 사용 중인 데이터베이스 버전이 서비스 지원 종료(EoS) 상태인 경우
echo ============================================

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
    for /f "tokens=*" %%i in (temp.txt) do set MYSQL_VERSION=%%i
    del temp.txt
    if "!MYSQL_VERSION!"=="5.6.40" (
        echo 경고: MySQL 버전 !MYSQL_VERSION!는 서비스 지원이 종료된 버전입니다.
    ) else (
        echo 양호: 현재 MySQL 버전은 지원되는 버전입니다.
    )
) else if "%DBType%"=="2" (
    echo PostgreSQL 버전 확인 중...
    psql -U %DBUser% -c "SELECT version();" > temp.txt
    for /f "tokens=3" %%i in ('findstr "PostgreSQL" temp.txt') do set PGSQL_VERSION=%%i
    del temp.txt
    echo PostgreSQL 버전 확인: !PGSQL_VERSION!
    REM PostgreSQL EoS 버전에 대한 실제 확인 로직 추가 필요
) else if "%DBType%"=="3" (
    echo Oracle 데이터베이스 버전 확인은 특정 환경에 따라 구현해야 합니다.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

:end
pause

@echo off
setlocal

echo ============================================
echo CODE [DBM-028] 업무상 불필요한 데이터베이스 오브젝트 존재 여부 확인
echo ============================================
echo [양호]: 불필요한 데이터베이스 오브젝트가 존재하지 않는 경우
echo [취약]: 불필요한 데이터베이스 오브젝트가 존재하는 경우
echo ============================================

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
echo 데이터베이스 유형 번호를 입력하세요.
set /p DBType=": "

if "%DBType%"=="1" (
    set /p DBUser="MySQL 사용자 이름을 입력하세요: "
    set /p DBPass="MySQL 비밀번호를 입력하세요: "
    echo MySQL 데이터베이스 오브젝트를 확인 중입니다...
    mysql -u %DBUser% -p%DBPass% -e "SHOW TABLES;"
    if errorlevel 1 (
        echo MySQL 데이터베이스 연결 오류.
    ) else (
        echo MySQL 데이터베이스 오브젝트 확인 완료.
    )
) else if "%DBType%"=="2" (
    set /p DBUser="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DBPass="PostgreSQL 비밀번호를 입력하세요: "
    echo PostgreSQL 데이터베이스 오브젝트를 확인 중입니다...
    psql -U %DBUser% -w -c "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';"
    if errorlevel 1 (
        echo PostgreSQL 데이터베이스 연결 오류.
    ) else (
        echo PostgreSQL 데이터베이스 오브젝트 확인 완료.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

:end
echo ============================================
pause

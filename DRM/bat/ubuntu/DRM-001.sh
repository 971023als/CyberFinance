@echo off
setlocal

echo ============================================
echo CODE [DBM-001] 취약하게 설정된 비밀번호 존재
echo ============================================
echo [양호]: 모든 데이터베이스 계정의 비밀번호가 강력한 경우
echo [취약]: 하나 이상의 데이터베이스 계정에 취약한 비밀번호가 설정된 경우
echo ============================================

echo 지원하는 데이터베이스: MySQL, PostgreSQL, Oracle
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    set /p DB_USER="MySQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MySQL 비밀번호를 입력하세요: "
    mysql -u %DB_USER% -p%DB_PASS% -e "SELECT user, authentication_string FROM mysql.user;"
    echo 비밀번호 강도 검사가 필요합니다.
) else if "%DB_TYPE%"=="PostgreSQL" (
    set /p DB_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="PostgreSQL 비밀번호를 입력하세요: "
    psql -U %DB_USER% -W %DB_PASS% -c "SELECT usename AS user, passwd AS pass FROM pg_shadow;"
    echo 비밀번호 강도 검사가 필요합니다.
) else if "%DB_TYPE%"=="Oracle" (
    echo Oracle 데이터베이스에 대한 수동 비밀번호 강도 검사가 필요합니다.
    goto end
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

:: 여기에 비밀번호 강도 검사 로직을 추가할 수 있습니다.
:: 예: if "%DB_PASS%"=="simple" echo 취약한 비밀번호입니다.

:end
pause

@echo off
setlocal

echo 지원하는 데이터베이스: MySQL, PostgreSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    set /p DB_USER="MySQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MySQL 비밀번호를 입력하세요: "
    echo 불필요한 MySQL 계정을 확인 중...
    mysql -u%DB_USER% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User NOT IN ('root', 'mysql.sys', 'mysql.session');"
) else if "%DB_TYPE%"=="PostgreSQL" (
    set /p DB_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="PostgreSQL 비밀번호를 입력하세요: "
    echo 불필요한 PostgreSQL 계정을 확인 중...
    psql -U %DB_USER% -W %DB_PASS% -c "SELECT usename FROM pg_shadow WHERE usename NOT IN ('postgres');"
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto :eof
)

echo 확인 완료. 불필요한 계정 목록을 검토하세요.

:end
pause

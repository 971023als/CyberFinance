@echo off
setlocal EnableDelayedExpansion

echo 지원하는 데이터베이스: 1. MySQL
set /p DB_CHOICE="사용 중인 데이터베이스 유형 번호를 입력하세요: "

if "!DB_CHOICE!"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    set /p MYSQL_PASS="MySQL 비밀번호를 입력하세요: "

    echo MySQL 사용자 계정을 확인 중입니다...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -e "SELECT user, host FROM mysql.user;" > users.txt

    echo 사용자 계정 목록:
    type users.txt
    del users.txt

    REM 비밀번호 복잡성 정책 검사는 데이터베이스에서 직접 확인하거나 MySQL Workbench를 사용하여 확인하세요.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal
pause

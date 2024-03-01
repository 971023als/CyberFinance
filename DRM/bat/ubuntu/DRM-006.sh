@echo off
setlocal

echo 지원하는 데이터베이스: 1. MySQL
set /p DB_CHOICE="사용 중인 데이터베이스 유형 번호를 입력하세요: "

if "%DB_CHOICE%"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    set /p MYSQL_PASS="MySQL 비밀번호를 입력하세요: "

    echo MySQL에서 로그인 실패 횟수 제한을 확인합니다...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -e "SHOW VARIABLES LIKE 'login_failure_limit';" > tmp_result.txt

    findstr "login_failure_limit" tmp_result.txt > nul
    if errorlevel 1 (
        echo 경고: 로그인 실패 횟수 제한이 설정되어 있지 않습니다.
    ) else (
        echo 양호: 로그인 실패 횟수 제한이 설정되어 있습니다.
    )

    del tmp_result.txt
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal
pause

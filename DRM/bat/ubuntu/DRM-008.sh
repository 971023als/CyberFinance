@echo off
setlocal

echo ====================
echo CODE [DBM-008] 주기적인 비밀번호 변경 미흡
echo ====================
echo [양호]: 모든 사용자가 정기적으로 비밀번호를 변경하는 경우
echo [취약]: 하나 이상의 사용자가 정기적으로 비밀번호를 변경하지 않는 경우
echo ====================

:: Prompt for database type, username, and password
set /p DB_TYPE="지원하는 데이터베이스: MySQL. 사용 중인 데이터베이스 유형을 입력하세요: "
if "%DB_TYPE%"=="MySQL" (
    set /p DB_USER="MySQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MySQL 비밀번호를 입력하세요: "

    :: Check for periodic password changes in MySQL
    echo 비밀번호 변경 정책 확인 중...
    mysql -u%DB_USER% -p%DB_PASS% -Bse "SELECT user, password_last_changed FROM mysql.user;" > password_change_policy.txt
    echo 비밀번호 변경 정책 확인 결과:
    type password_change_policy.txt
    del password_change_policy.txt
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

echo ====================

endlocal
pause

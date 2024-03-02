@echo off
setlocal

echo ============================================
echo CODE [DBM-019] 비밀번호 재사용 방지 설정 미흡
echo ============================================
echo [양호]: 비밀번호 재사용 방지가 올바르게 설정된 경우
echo [취약]: 비밀번호 재사용 방지가 제대로 설정되지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL
set /p DBType="데이터베이스 유형을 입력하세요 (1/2): "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL에서 비밀번호 재사용 방지 설정을 확인합니다...
    mysql -u %DBUser% -p%DBPass% -e "SHOW VARIABLES LIKE 'validate_password_history';"
    echo 비밀번호 재사용 방지 설정을 검토하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL에서 비밀번호 재사용 방지 설정을 확인합니다...
    echo 주의: PostgreSQL에서는 직접적인 비밀번호 재사용 방지 설정이 없을 수 있으며, pg_shadow 테이블을 쿼리하거나, custom functions를 사용하여 관리될 수 있습니다.
    echo 이 예시는 password_encryption 설정을 보여줍니다:
    psql -U %DBUser% -c "SHOW password_encryption;"
    echo PostgreSQL의 비밀번호 정책 관리에 대해 더 자세히 알아보세요.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

echo 설정 확인 후, 비밀번호 재사용 방지가 적절히 구성되었는지 확인하세요.

:end
pause

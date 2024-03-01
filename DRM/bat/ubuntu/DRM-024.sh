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
    set Query="SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
    echo MySQL에서 불필요한 'WITH GRANT OPTION' 권한을 확인 중...
    mysql -u %DBUser% -p%DBPass% -e %Query%
    if errorlevel 1 (
        echo 오류가 발생했습니다.
    ) else (
        echo 확인 완료.
    )
) else if "%DBType%"=="2" (
    set Query="SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
    echo PostgreSQL에서 불필요한 'WITH GRANT OPTION' 권한을 확인 중...
    psql -U %DBUser% -c %Query%
    if errorlevel 1 (
        echo 오류가 발생했습니다.
    ) else (
        echo 확인 완료.
    )
) else if "%DBType%"=="3" (
    echo 이 스크립트에서는 Oracle 지원이 구현되지 않았습니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

:end
pause

@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-024] 불필요하게 'WITH GRANT OPTION' 옵션이 설정된 권한 확인
echo ============================================
echo [양호]: 'WITH GRANT OPTION'이 불필요하게 설정되지 않은 경우
echo [취약]: 'WITH GRANT OPTION'이 불필요하게 설정된 권한이 있는 경우
echo ============================================

echo 지원하는 데이터베이스: 
echo 1. MySQL 
echo 2. PostgreSQL 
echo 3. Oracle
echo.

set /p DBType="데이터베이스 유형 번호를 입력하세요: "
set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "!DBType!"=="1" (
    set Query="SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
    echo MySQL에서 'WITH GRANT OPTION'으로 부여된 불필요한 권한을 확인 중...
    mysql -u !DBUser! -p!DBPass! -e "!Query!" > grant_option_results.txt
    findstr /C:"GRANTEE" grant_option_results.txt > nul
    if errorlevel 1 (
        echo 불필요한 'WITH GRANT OPTION' 권한이 없습니다.
    ) else (
        echo 불필요한 'WITH GRANT OPTION'으로 부여된 권한 목록:
        type grant_option_results.txt
    )
    del grant_option_results.txt
) else if "!DBType!"=="2" (
    set Query="SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
    echo PostgreSQL에서 'WITH GRANT OPTION'으로 부여된 불필요한 권한을 확인 중...
    psql -U !DBUser! -c "!Query!" > grant_option_results.txt
    findstr /C:"grantee" grant_option_results.txt > nul
    if errorlevel 1 (
        echo 불필요한 'WITH GRANT OPTION' 권한이 없습니다.
    ) else (
        echo 불필요한 'WITH GRANT OPTION'으로 부여된 권한 목록:
        type grant_option_results.txt
    )
    del grant_option_results.txt
) else if "!DBType!"=="3" (
    echo Oracle에서는 이 스크립트를 통한 직접적인 확인이 구현되지 않았습니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

:end
pause

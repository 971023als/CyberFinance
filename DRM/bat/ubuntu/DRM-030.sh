@echo off
setlocal EnableDelayedExpansion

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DB_TYPE="데이터베이스 유형 번호를 입력하세요: "

set /p DB_USER="데이터베이스 사용자 이름을 입력하세요: "
set /p DB_PASS="데이터베이스 비밀번호를 입력하세요: "

if "%DB_TYPE%"=="1" (
    set QUERY=SELECT * FROM audit_table_permissions;
    echo MySQL에서 Audit Table 접근 제어를 확인 중입니다...
    mysql -u %DB_USER% -p%DB_PASS% -e "%QUERY%" > audit_results.txt
    if %ERRORLEVEL% neq 0 (
        echo WARNING: Audit Table 접근 제어 검사에 실패했습니다.
    ) else (
        echo OK: Audit Table 접근 제어 검사에 성공했습니다.
    )
) else if "%DB_TYPE%"=="2" (
    set QUERY=SELECT * FROM audit_table_permissions;
    echo PostgreSQL에서 Audit Table 접근 제어를 확인 중입니다...
    psql -U %DB_USER% -c "%QUERY%" > audit_results.txt
    if %ERRORLEVEL% neq 0 (
        echo WARNING: Audit Table 접근 제어 검사에 실패했습니다.
    ) else (
        echo OK: Audit Table 접근 제어 검사에 성공했습니다.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal

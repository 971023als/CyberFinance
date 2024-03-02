@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-030] Audit Table에 대한 접근 제어 미흡
echo ============================================
echo [양호]: Audit Table에 대한 접근 제어가 적절하게 설정된 경우
echo [취약]: Audit Table에 대한 접근 제어가 미흡한 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle
set /p DB_TYPE="데이터베이스 유형을 선택하세요 (1-3): "

set /p DB_USER="데이터베이스 사용자 이름을 입력하세요: "
set /p DB_PASS="데이터베이스 비밀번호를 입력하세요: "

if "%DB_TYPE%"=="1" (
    echo MySQL에서 Audit Table 접근 제어를 확인 중입니다...
    mysql -u %DB_USER% -p%DB_PASS% -e "SELECT * FROM audit_table_permissions;" > audit_results.txt
    findstr /C:"[취약]" audit_results.txt > nul
    if errorlevel 1 (
        echo OK: Audit Table 접근 제어가 적절합니다.
    ) else (
        echo WARNING: Audit Table 접근 제어가 미흡합니다.
    )
    del audit_results.txt
) else if "%DB_TYPE%"=="2" (
    echo PostgreSQL에서 Audit Table 접근 제어를 확인 중입니다...
    psql -U %DB_USER% -c "SELECT * FROM audit_table_permissions;" > audit_results.txt
    findstr /C:"[취약]" audit_results.txt > nul
    if errorlevel 1 (
        echo OK: Audit Table 접근 제어가 적절합니다.
    ) else (
        echo WARNING: Audit Table 접근 제어가 미흡합니다.
    )
    del audit_results.txt
) else if "%DB_TYPE%"=="3" (
    echo Oracle에서 Audit Table 접근 제어를 수동으로 확인해야 합니다.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

echo ============================================
endlocal
pause

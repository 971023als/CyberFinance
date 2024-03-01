@echo off
setlocal EnableDelayedExpansion

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DBType="데이터베이스 유형에 해당하는 번호를 입력하세요: "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL이 선택되었습니다.
    echo 다음 쿼리를 MySQL 환경에서 수동으로 실행하세요:
    echo SELECT GRANTEE, TABLE_SCHEMA, PRIVILEGE_TYPE FROM information_schema.SCHEMA_PRIVILEGES WHERE TABLE_SCHEMA IN ('mysql', 'information_schema', 'performance_schema');
    echo 불필요한 시스템 테이블 접근 권한이 있는지 확인하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL이 선택되었습니다.
    echo 다음 쿼리를 PostgreSQL 환경에서 수동으로 실행하세요:
    echo SELECT grantee, table_schema, privilege_type FROM information_schema.role_table_grants WHERE table_schema = 'pg_catalog';
    echo 불필요한 시스템 테이블 접근 권한이 있는지 확인하세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

echo 출력된 결과를 검토하여 불필요한 권한이 있을 경우 적절한 조치를 취하세요.

:end
endlocal

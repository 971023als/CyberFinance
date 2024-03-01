@echo off
setlocal

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DBType="데이터베이스 유형에 해당하는 번호를 입력하세요: "

set /p DBUser="데이터베이스 관리자 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 관리자 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL 선택됨. 쿼리 실행 시도 중...
    mysql -u %DBUser% -p%DBPass% -e "SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv FROM mysql.db;"
) else if "%DBType%"=="2" (
    echo PostgreSQL 선택됨. 쿼리 실행 시도 중...
    psql -U %DBUser% -c "SELECT rolname, rolselectpriv, rolinsertpriv, rolupdatepriv FROM pg_roles JOIN pg_database ON (rolname = datname);"
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

:end
endlocal

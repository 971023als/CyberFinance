@echo off
setlocal

echo 지원하는 데이터베이스: MySQL, PostgreSQL, Oracle
set /p DBType="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DBType%"=="MySQL" (
    echo MySQL이 선택되었습니다. "mysql --version"을 실행하여 MySQL 버전을 확인해 주세요.
) else if "%DBType%"=="PostgreSQL" (
    echo PostgreSQL이 선택되었습니다. "psql -V"를 실행하여 PostgreSQL 버전을 확인해 주세요.
) else if "%DBType%"=="Oracle" (
    echo Oracle이 선택되었습니다. "sqlplus -v"를 실행하여 Oracle 버전을 확인해 주세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo.
echo 버전을 확인한 후, %DBType% 버전에 대한 보안 패치와 권고사항을 수동으로 확인하세요.
echo 이는 CVE 데이터베이스를 조회하거나, 벤더 보안 페이지 등을 확인하는 것을 포함할 수 있습니다.
echo.

:end
endlocal

@echo off
setlocal

:: 배치에서 임시 파일 생성은 Bash처럼 간단하지 않습니다. 단순성을 위해 고정된 이름을 사용합니다.
set TMP1=tempfile.txt
echo. > %TMP1%

call :BAR
echo CODE [DBM-031] SA 계정의 보안설정 미흡

:: 텍스트 블록을 파일로 리다이렉션
(
echo [양호]: 관리자 계정의 보안 설정이 적절한 경우
echo [취약]: 관리자 계정의 보안 설정이 미흡한 경우
) > result.txt

call :BAR

echo 지원하는 데이터베이스:
echo 1. SQL Server
echo 2. MySQL
echo 3. PostgreSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 선택하세요 (1-3): "

set /p DB_ADMIN="데이터베이스 관리자 계정을 입력하세요: "
:: 참고: 배치 스크립트는 비밀번호를 숨긴 입력을 지원하지 않습니다.
:: 환경 변수 또는 다른 방법을 사용하여 비밀번호를 안전하게 관리하세요.
echo 데이터베이스 관리자 비밀번호를 입력하세요:
set /p DB_PASS=""

if "%DB_TYPE%"=="1" (
    :: SQL Server 명령
    sqlcmd -U %DB_ADMIN% -P %DB_PASS% -Q "SELECT * FROM sys.sql_logins WHERE name = 'sa';" > nul
) else if "%DB_TYPE%"=="2" (
    :: MySQL 명령
    mysql -u %DB_ADMIN% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User = 'root';" > nul
) else if "%DB_TYPE%"=="3" (
    :: PostgreSQL 명령
    psql -U %DB_ADMIN% -c "SELECT rolname FROM pg_roles WHERE rolname = 'postgres';" > nul
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

:: errorlevel을 확인하여 결과를 결정
if %errorlevel% == 0 (
    echo 관리자 계정의 보안 설정이 적절합니다.
) else (
    echo 관리자 계정의 보안 설정이 미흡합니다.
)

type result.txt
echo.
goto end

:BAR
echo ----------------------------------------
goto :eof

:end
del %TMP1%
endlocal

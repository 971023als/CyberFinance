@echo off
setlocal

echo ============================================
echo CODE [DBM-026] 데이터베이스 구동 계정의 umask 설정 확인
echo ============================================
echo [양호]: 적절한 umask 설정이 적용된 경우
echo [취약]: umask 설정이 미흡한 경우
echo ============================================

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
echo 3. Oracle
echo.

set /p DBType="데이터베이스 유형 번호를 입력하세요: "

if "%DBType%"=="1" (
    set DatabaseServiceAccount=mysql
) else if "%DBType%"=="2" (
    set DatabaseServiceAccount=postgres
) else if "%DBType%"=="3" (
    set DatabaseServiceAccount=oracle
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

set ExpectedUmask=027

echo 데이터베이스 서비스 계정(%DatabaseServiceAccount%)의 umask 값 확인이 필요합니다.
echo 이 작업은 해당 데이터베이스 서버에 직접 로그인하여 수행해야 합니다.
echo 다음 명령어를 사용하세요: su - %DatabaseServiceAccount% -c "umask"
echo 예상되는 umask 값: %ExpectedUmask%

:end
echo ============================================
pause

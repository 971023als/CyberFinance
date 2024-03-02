@echo off
setlocal

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
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

set ExpectedUmask=027

set /p Server="서버 주소를 입력하세요: "
set /p Username="SSH 사용자 이름을 입력하세요: "
set /p Password="SSH 비밀번호를 입력하세요: "

rem plink.exe를 사용한 SSH 가정. 필요에 따라 명령어를 조정하세요.
plink -ssh %Username%@%Server% -pw %Password% "su - %DatabaseServiceAccount% -c umask" > umask.txt

set /p UmaskValue=<umask.txt
del umask.txt

if "%UmaskValue%"=="%ExpectedUmask%" (
    echo 데이터베이스 서비스 계정(%DatabaseServiceAccount%)의 umask 값(%ExpectedUmask%)이 올바릅니다.
) else (
    echo 데이터베이스 서비스 계정(%DatabaseServiceAccount%)의 umask 값(%UmaskValue%)이 기대치(%ExpectedUmask%)와 다릅니다.
)

:end
pause

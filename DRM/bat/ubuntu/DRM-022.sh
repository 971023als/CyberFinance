@echo off
setlocal

echo 지원하는 데이터베이스: 
echo 1. MySQL 
echo 2. Oracle 
echo 3. PostgreSQL
echo.
set /p DB_CHOICE="데이터베이스 번호를 입력하세요: "

if "%DB_CHOICE%"=="1" (
    set FILE_TO_CHECK=C:\ProgramData\MySQL\MySQL Server X.X\my.ini
) else if "%DB_CHOICE%"=="2" (
    set FILE_TO_CHECK=C:\app\oracle\product\11.2.0\dbhome_1\network\admin\listener.ora
) else if "%DB_CHOICE%"=="3" (
    set FILE_TO_CHECK=C:\Program Files\PostgreSQL\X.X\data\postgresql.conf
) else (
    echo 선택이 잘못되었습니다.
    goto end
)

if exist "%FILE_TO_CHECK%" (
    echo 파일 %FILE_TO_CHECK%이(가) 존재합니다.
    echo 권한을 표시합니다:
    icacls "%FILE_TO_CHECK%"
) else (
    echo 파일 %FILE_TO_CHECK%이(가) 존재하지 않습니다.
)

:end
pause

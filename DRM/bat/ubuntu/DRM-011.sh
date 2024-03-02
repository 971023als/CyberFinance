@echo off
setlocal

echo ============================================
echo CODE [DBM-011] 감사 로그 수집 및 백업 미흡
echo ============================================

set /p DB_TYPE="지원하는 데이터베이스: MySQL, PostgreSQL, Oracle. 사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    set AUDIT_LOG_DIR=C:\ProgramData\MySQL\MySQL Server*\Data\*.log
    echo Checking MySQL audit logs...
) else if "%DB_TYPE%"=="PostgreSQL" (
    set AUDIT_LOG_DIR=C:\Program Files\PostgreSQL*\data\log\*.log
    echo Checking PostgreSQL audit logs...
) else if "%DB_TYPE%"=="Oracle" (
    set AUDIT_LOG_DIR=C:\app\*\oradata\*\*.log
    echo Checking Oracle audit logs...
) else (
    echo Unsupported database type.
    goto end
)

echo Checking if audit logs are being collected...
if exist "%AUDIT_LOG_DIR%" (
    echo OK: 감사 로그가 정기적으로 수집되고 있습니다.
) else (
    echo WARNING: 감사 로그가 수집되지 않고 있습니다.
)

set BACKUP_DIR=C:\Backups\Audit
echo Checking for recent backup files...
forfiles /P "%BACKUP_DIR%" /M *.bak /D -30 >nul 2>&1
if errorlevel 1 (
    echo WARNING: 감사 로그 백업이 30일 이상 되지 않았습니다.
) else (
    echo OK: 감사 로그가 최근 30일 이내에 백업되었습니다.
)

:end
echo ============================================
pause

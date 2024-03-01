@echo off
setlocal EnableDelayedExpansion

echo Supported Databases:
echo 1. MySQL
echo 2. PostgreSQL
set /p DB_TYPE="Enter the number for your database type: "

set /p DB_USER="Enter database username: "
set /p DB_PASS="Enter database password: "

if "%DB_TYPE%"=="1" (
    set QUERY=SELECT * FROM audit_table_permissions;
    mysql -u %DB_USER% -p%DB_PASS% -e "%QUERY%" > audit_results.txt
    if %ERRORLEVEL% neq 0 (
        echo WARNING: Audit Table access control check failed.
    ) else (
        echo OK: Audit Table access control check succeeded.
    )
) else if "%DB_TYPE%"=="2" (
    set QUERY=SELECT * FROM audit_table_permissions;
    psql -U %DB_USER% -c "%QUERY%" > audit_results.txt
    if %ERRORLEVEL% neq 0 (
        echo WARNING: Audit Table access control check failed.
    ) else (
        echo OK: Audit Table access control check succeeded.
    )
) else (
    echo Unsupported database type.
)

endlocal

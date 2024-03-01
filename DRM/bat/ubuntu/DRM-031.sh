@echo off
setlocal

echo Supported Databases: 
echo 1. SQL Server
echo 2. MySQL
echo 3. PostgreSQL
set /p DB_TYPE="Enter the number for your database type (1-3): "

set /p DB_ADMIN="Enter database administrator username: "
:: Note: Batch script does not support hidden input for passwords.
:: Consider using environment variables or another method to secure the password.

if "%DB_TYPE%"=="1" (
    set /p DB_PASS="Enter SQL Server database administrator password: "
    sqlcmd -U %DB_ADMIN% -P %DB_PASS% -Q "SELECT name FROM sys.sql_logins WHERE name = 'sa';"
    if errorlevel 1 (
        echo Administrator account security settings check failed.
    ) else (
        echo Administrator account security settings are appropriate.
    )
) else if "%DB_TYPE%"=="2" (
    set /p DB_PASS="Enter MySQL database administrator password: "
    mysql -u %DB_ADMIN% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User = 'root';"
    if errorlevel 1 (
        echo Administrator account security settings check failed.
    ) else (
        echo Administrator account security settings are appropriate.
    )
) else if "%DB_TYPE%"=="3" (
    set /p DB_PASS="Enter PostgreSQL database administrator password: "
    psql -U %DB_ADMIN% -c "SELECT rolname FROM pg_roles WHERE rolname = 'postgres';"
    if errorlevel 1 (
        echo Administrator account security settings check failed.
    ) else (
        echo Administrator account security settings are appropriate.
    )
) else (
    echo Unsupported database type.
)

endlocal

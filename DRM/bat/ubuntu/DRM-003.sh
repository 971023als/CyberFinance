@echo off
setlocal

echo Supported databases: MySQL, PostgreSQL
set /p DB_TYPE="Enter the type of your database: "

if "%DB_TYPE%"=="MySQL" (
    set /p DB_USER="Enter MySQL username: "
    set /p DB_PASS="Enter MySQL password: "
    echo Checking unnecessary MySQL accounts...
    mysql -u%DB_USER% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User NOT IN ('root', 'mysql.sys', 'mysql.session');"
) else if "%DB_TYPE%"=="PostgreSQL" (
    set /p DB_USER="Enter PostgreSQL username: "
    set /p DB_PASS="Enter PostgreSQL password: "
    echo Checking unnecessary PostgreSQL accounts...
    psql -U %DB_USER% -W %DB_PASS% -c "SELECT usename FROM pg_shadow WHERE usename NOT IN ('postgres');"
) else (
    echo Unsupported database type.
    goto :eof
)

echo Check complete. Review the list for unnecessary accounts.

:end
pause

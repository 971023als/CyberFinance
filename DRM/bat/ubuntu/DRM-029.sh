@echo off
setlocal

echo Supported Databases: 
echo 1. MySQL 
echo 2. PostgreSQL
set /p DBType="Enter the number for your database type: "

set /p DBUser="Enter database username: "
set /p DBPass="Enter database password: "
set DBHost=localhost

if "%DBType%"=="1" (
    echo Checking MySQL resource limits...
    mysql -u %DBUser% -p%DBPass% -h %DBHost% -e "SHOW VARIABLES LIKE 'max_connections';"
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to retrieve MySQL resource limits.
    )
) else if "%DBType%"=="2" (
    echo Checking PostgreSQL resource limits...
    psql -U %DBUser% -h %DBHost% -W %DBPass% -c "SHOW max_connections;"
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to retrieve PostgreSQL resource limits.
    )
) else (
    echo Unsupported database type.
)

endlocal

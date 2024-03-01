@echo off
setlocal

echo Supported Databases: 
echo 1. MySQL 
echo 2. PostgreSQL 
echo 3. Oracle
echo.

set /p DBType="Enter the number for your database type: "
set /p DBUser="Enter database username: "
set /p DBPass="Enter database password: "

if "%DBType%"=="1" (
    echo Checking MySQL version...
    mysql -u %DBUser% -p%DBPass% -e "SELECT VERSION();" > temp.txt
    findstr /V "VERSION" temp.txt
    del temp.txt
) else if "%DBType%"=="2" (
    echo Checking PostgreSQL version...
    psql -U %DBUser% -c "SELECT version();" > temp.txt
    findstr "PostgreSQL" temp.txt
    del temp.txt
) else if "%DBType%"=="3" (
    echo Oracle database version check needs to be implemented based on specific environment.
) else (
    echo Unsupported database type.
)

endlocal
pause

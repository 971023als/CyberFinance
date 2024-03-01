@echo off
setlocal

echo Supported Databases: 
echo 1. MySQL 
echo 2. PostgreSQL
echo Enter the number for your database type
set /p DBType=": "

if "%DBType%"=="1" (
    set /p DBUser="Enter MySQL username: "
    set /p DBPass="Enter MySQL password: "
    set Query=SHOW TABLES;
    mysql -u %DBUser% -p%DBPass% -e "%Query%"
    if errorlevel 1 (
        echo Error connecting to MySQL database.
    )
) else if "%DBType%"=="2" (
    set /p DBUser="Enter PostgreSQL username: "
    set /p DBPass="Enter PostgreSQL password: "
    set Query=SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';
    psql -U %DBUser% -w %DBPass% -c "%Query%"
    if errorlevel 1 (
        echo Error connecting to PostgreSQL database.
    )
) else (
    echo Unsupported database type.
)

endlocal

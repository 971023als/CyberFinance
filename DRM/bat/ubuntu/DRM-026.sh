@echo off
setlocal

echo Supported Databases: 
echo 1. MySQL 
echo 2. PostgreSQL 
echo 3. Oracle
echo.

set /p DBType="Enter the number for your database type: "

if "%DBType%"=="1" (
    set DatabaseServiceAccount=mysql
) else if "%DBType%"=="2" (
    set DatabaseServiceAccount=postgres
) else if "%DBType%"=="3" (
    set DatabaseServiceAccount=oracle
) else (
    echo Unsupported database type.
    goto end
)

set ExpectedUmask=027

set /p Server="Enter the server address: "
set /p Username="Enter your SSH username: "
set /p Password="Enter your SSH password: "

rem Assuming plink.exe for SSH. Adjust the command as necessary.
plink -ssh %Username%@%Server% -pw %Password% "su - %DatabaseServiceAccount% -c umask" > umask.txt

set /p UmaskValue=<umask.txt
del umask.txt

if "%UmaskValue%"=="%ExpectedUmask%" (
    echo Database service account (%DatabaseServiceAccount%) has the correct umask value (%ExpectedUmask%).
) else (
    echo Database service account (%DatabaseServiceAccount%)'s umask value (%UmaskValue%) does not meet the expected (%ExpectedUmask%).
)

:end
pause

@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo CODE [SRV-060] Unchanged Default Account (ID or Password) in Web Service >> "%TMP1%"
echo [Good]: The web service's default account (ID or password) has been changed >> "%TMP1%"
echo [Vulnerable]: The web service's default account (ID or password) remains unchanged >> "%TMP1%"

:: Example path to a web service configuration file (Adjust path as necessary)
set "CONFIG_FILE=C:\path\to\web_service\config.txt"

:: Checking for default accounts (example: 'admin' or 'password')
findstr /R "username=admin password=password" "%CONFIG_FILE%" >nul

if errorlevel 1 (
    echo OK: The web service's default account (ID or password) has been changed >> "%TMP1%"
) else (
    echo WARN: The web service's default account (ID or password) remains unchanged >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-045] Insufficient Restriction on Web Service Process Permissions >> "%TMP1%"
echo [Good]: Web service processes are not running with excessive permissions >> "%TMP1%"
echo [Vulnerable]: Web service processes are running with excessive permissions >> "%TMP1%"

:: Specify the service name of your web server here (e.g., Apache2.4 or W3SVC for IIS)
set "SERVICE_NAME=Apache2.4"

:: Check which account the service is running under
sc qc "%SERVICE_NAME%" | findstr /C:"SERVICE_START_NAME" >> "%TMP1%"

:: Note: Manual review is needed to determine if the account has excessive permissions
echo Note: Please manually review the service account to ensure it does not have excessive permissions. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

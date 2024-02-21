@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-043] Unnecessary Files in Web Service Path >> "%TMP1%"
echo [Good]: No unnecessary files exist within the web service path >> "%TMP1%"
echo [Vulnerable]: Unnecessary files exist within the web service path >> "%TMP1%"

:: Set the default IIS web service path
set "WEB_SERVICE_PATH=C:\inetpub\wwwroot"

:: List common unnecessary files within the web service path
echo Checking for common unnecessary files within %WEB_SERVICE_PATH%: >> "%TMP1%"
dir "%WEB_SERVICE_PATH%\*.bak" /s /b >> "%TMP1%"
dir "%WEB_SERVICE_PATH%\*.tmp" /s /b >> "%TMP1%"
dir "%WEB_SERVICE_PATH%\*test*" /s /b >> "%TMP1%"
dir "%WEB_SERVICE_PATH%\*example*" /s /b >> "%TMP1%"

:: Note: This script lists files based on common patterns. Please review them manually.
echo Note: Please manually review the listed files to ensure they are necessary. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

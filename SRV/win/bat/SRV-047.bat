@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-047] Unnecessary Link Files in Web Service Path >> "%TMP1%"
echo [Good]: No unnecessary symbolic link files exist within the web service path >> "%TMP1%"
echo [Vulnerable]: Unnecessary symbolic link files exist within the web service path >> "%TMP1%"

:: Set the web service path (adjust according to your actual path)
set "WEB_SERVICE_PATH=C:\Path\To\Web\Service"

:: List shortcut (.lnk) files within the web service path
echo Checking for shortcut (.lnk) files within %WEB_SERVICE_PATH%: >> "%TMP1%"
dir "%WEB_SERVICE_PATH%\*.lnk" /s /b >> "%TMP1%"

:: Note to the administrator
echo Note: This script lists .lnk shortcut files. Please review them manually to ensure they are necessary. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

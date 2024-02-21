@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo CODE [SRV-057] Insufficient Access Control Within Web Service Path >> "%TMP1%"
echo [Good]: Access permissions for files within the web service path are appropriately set >> "%TMP1%"
echo [Vulnerable]: Access permissions for files within the web service path are not appropriately set >> "%TMP1%"

:: Set the web service path (adjust according to your actual path)
set "WEB_SERVICE_PATH=C:\Path\To\Web\Service"

:: List permissions for files within the web service path
echo Listing permissions for files within %WEB_SERVICE_PATH%: >> "%TMP1%"
for /R "%WEB_SERVICE_PATH%" %%G in (*.*) do (
    icacls "%%G" >> "%TMP1%"
)

:: Note to the administrator
echo Note: Please manually review the listed permissions to ensure they are appropriately set. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

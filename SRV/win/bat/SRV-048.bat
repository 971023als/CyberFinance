@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-048] Unnecessary Web Service Running >> "%TMP1%"
echo [Good]: No unnecessary web services are running >> "%TMP1%"
echo [Vulnerable]: Unnecessary web services are running >> "%TMP1%"

:: Example check for Apache service directory and unnecessary 'manual' directory
set "APACHE_CONFIG_PATH=C:\Apache24\conf"
set "APACHE_ROOT=C:\Apache24"

:: Check for the 'manual' directory in the Apache root directory
if exist "%APACHE_ROOT%\htdocs\manual\" (
    echo WARN: Unnecessary 'manual' directory found within the Apache home directory. >> "%TMP1%"
) else (
    echo OK: No unnecessary 'manual' directory found within the Apache home directory. >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

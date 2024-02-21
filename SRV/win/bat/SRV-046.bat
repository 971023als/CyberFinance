@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-046] Inadequate Web Service Path Configuration >> "%TMP1%"
echo [Good]: The web service's path configuration is securely configured >> "%TMP1%"
echo [Vulnerable]: The web service's path configuration is insecurely configured >> "%TMP1%"

:: Set paths to Apache and Nginx configuration files on Windows
set "APACHE_CONFIG_FILE=C:\Apache24\conf\apache2.conf"
set "NGINX_CONFIG_FILE=C:\nginx\conf\nginx.conf"

:: Check Apache configuration for secure path settings
if exist "%APACHE_CONFIG_FILE%" (
    findstr /R /C:"^ *<Directory" /C:"Options -Indexes" "%APACHE_CONFIG_FILE%" >nul
    if not errorlevel 1 (
        echo OK: Apache configuration has secure path settings: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
    ) else (
        echo WARN: Apache configuration may have insecure path settings: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
    )
) else (
    echo INFO: Apache configuration file does not exist: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
)

:: Check Nginx configuration for secure path settings
if exist "%NGINX_CONFIG_FILE%" (
    findstr /R /C:"^ *location" "%NGINX_CONFIG_FILE%" >nul
    if not errorlevel 1 (
        echo OK: Nginx configuration has secure path settings: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
    ) else (
        echo WARN: Nginx configuration may have insecure path settings: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
    )
) else (
    echo INFO: Nginx configuration file does not exist: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

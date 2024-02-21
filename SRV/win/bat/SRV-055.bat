@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-055] Web Service Configuration File Exposure >> "%TMP1%"
echo [Good]: Web service configuration files are inaccessible from outside >> "%TMP1%"
echo [Vulnerable]: Web service configuration files are accessible from outside >> "%TMP1%"

:: Example paths to Apache and Nginx configuration files on Windows (adjust as necessary)
set "APACHE_CONFIG=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG=C:\path\to\nginx\conf\nginx.conf"

:: Check Apache configuration file permissions
if exist "%APACHE_CONFIG%" (
    icacls "%APACHE_CONFIG%" | findstr /C:"Everyone:(N)" >nul
    if not errorlevel 1 (
        echo WARN: Apache configuration file (%APACHE_CONFIG%) permissions are vulnerable. >> "%TMP1%"
    ) else (
        echo OK: Apache configuration file (%APACHE_CONFIG%) is protected from external access. >> "%TMP1%"
    )
) else (
    echo INFO: Apache configuration file (%APACHE_CONFIG%) does not exist. >> "%TMP1%"
)

:: Check Nginx configuration file permissions
if exist "%NGINX_CONFIG%" (
    icacls "%NGINX_CONFIG%" | findstr /C:"Everyone:(N)" >nul
    if not errorlevel 1 (
        echo WARN: Nginx configuration file (%NGINX_CONFIG%) permissions are vulnerable. >> "%TMP1%"
    ) else (
        echo OK: Nginx configuration file (%NGINX_CONFIG%) is protected from external access. >> "%TMP1%"
    )
) else (
    echo INFO: Nginx configuration file (%NGINX_CONFIG%) does not exist. >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

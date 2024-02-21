@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-058] Unnecessary Script Mapping in Web Service >> "%TMP1%"
echo [Good]: No unnecessary script mappings exist in the web service >> "%TMP1%"
echo [Vulnerable]: Unnecessary script mappings exist in the web service >> "%TMP1%"

:: Set the path to Apache and Nginx configuration files on Windows
set "APACHE_CONFIG_FILE=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG_FILE=C:\path\to\nginx\conf\nginx.conf"

:: Check for script mappings in Apache
findstr /R "AddHandler AddType" "%APACHE_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo WARN: Unnecessary script mappings found in Apache: %APACHE_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: No unnecessary script mappings found in Apache: %APACHE_CONFIG_FILE% >> "%TMP1%"
)

:: Check for script mappings in Nginx
findstr /R "location ~ \.php$" "%NGINX_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo WARN: Unnecessary PHP script mappings found in Nginx: %NGINX_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: No unnecessary PHP script mappings found in Nginx: %NGINX_CONFIG_FILE% >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

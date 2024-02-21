@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo CODE [SRV-059] Insufficient Restriction on Web Service Server Command Execution >> "%TMP1%"
echo [Good]: Server command execution functionality is appropriately restricted in the web service >> "%TMP1%"
echo [Vulnerable]: Server command execution functionality is inadequately restricted in the web service >> "%TMP1%"

:: Set the path to Apache and Nginx configuration files on Windows
set "APACHE_CONFIG_FILE=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG_FILE=C:\path\to\nginx\conf\nginx.conf"

:: Check for server command execution restrictions in Apache
findstr /R "^[ \t]*ScriptAlias" "%APACHE_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo WARN: Apache may allow server command execution: %APACHE_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Server command execution functionality is appropriately restricted in Apache: %APACHE_CONFIG_FILE% >> "%TMP1%"
)

:: Check for FastCGI script execution restrictions in Nginx
findstr /R "fastcgi_pass" "%NGINX_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo WARN: Nginx may allow server command execution through FastCGI: %NGINX_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Server command execution functionality is appropriately restricted in Nginx: %NGINX_CONFIG_FILE% >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

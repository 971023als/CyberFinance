@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-148] 웹 서비스 정보 노출 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우 >> %TMP1%
echo [취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 IIS 웹 서버의 헤더 정보 설정 확인
powershell -Command "& {Import-Module WebAdministration; $customHeaders = Get-WebConfigurationProperty '/system.webServer/httpProtocol/customHeaders' -PSPath 'MACHINE/WEBROOT/APPHOST' -name '.'; if($customHeaders.Collection | Where-Object { $_.name -eq 'X-Powered-By' }) { echo WARN: X-Powered-By 헤더가 노출됩니다. >> %TMP1% } else { echo OK: X-Powered-By 헤더 노출이 제한됩니다. >> %TMP1% }; }"

type %TMP1%

echo.
echo.

endlocal

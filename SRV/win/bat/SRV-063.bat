@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-063] Inadequate DNS Recursive Query Settings >> "%TMP1%"
echo [Good]: DNS server has recursive queries securely restricted >> "%TMP1%"
echo [Vulnerable]: DNS server does not have recursive queries adequately restricted >> "%TMP1%"

:: Use PowerShell to check DNS Recursive Query settings
echo Checking DNS Recursive Query settings via PowerShell: >> "%TMP1%"
powershell -Command "Get-DnsServer | Select-Object Name, ZoneType, IsRecursionEnabled | Format-Table -AutoSize" >> "%TMP1%"

:: Note to administrators
echo Note: Review the IsRecursionEnabled property for each DNS server. 'True' indicates recursion is enabled; ensure it's securely configured. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

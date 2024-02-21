@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-073] Presence of Unnecessary Users in the Administrators Group >> "%TMP1%"
echo [Good]: There are no unnecessary users in the Administrators group >> "%TMP1%"
echo [Vulnerable]: There are unnecessary users in the Administrators group >> "%TMP1%"

:: List members of the Administrators group
echo Listing members of the Administrators group: >> "%TMP1%"
net localgroup Administrators >> "%TMP1%"

:: Note for manual review
echo Please manually review the listed members for any that are unnecessary or should not be part of the Administrators group. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

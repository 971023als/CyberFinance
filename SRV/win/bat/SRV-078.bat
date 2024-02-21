@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-078] Unnecessary Guest Account Activation >> "%TMP1%"
echo [Good]: The unnecessary Guest account is disabled >> "%TMP1%"
echo [Vulnerable]: The unnecessary Guest account is enabled >> "%TMP1%"

:: Check the status of the Guest account
net user Guest | findstr /C:"Account active" >> "%TMP1%"

:: Suggest manual checks for unnecessary accounts in the Administrators group
echo To check for unnecessary accounts in the Administrators group, manually review the output of 'net localgroup Administrators' >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-074] Presence of Unnecessary or Unmanaged Accounts >> "%TMP1%"
echo [Good]: There are no unnecessary or unmanaged accounts present >> "%TMP1%"
echo [Vulnerable]: Unnecessary or unmanaged accounts are present >> "%TMP1%"

:: List all user accounts
echo Listing all user accounts: >> "%TMP1%"
net user >> "%TMP1%"

:: Provide guidance for manual review
echo Please manually review the listed accounts for any that are unnecessary or should not be enabled. >> "%TMP1%"
echo Consider using PowerShell or the Local Users and Groups MMC snap-in (lusrmgr.msc) for more detailed management. >> "%TMP1%"

:: Suggest checking for specific known accounts that should be disabled or carefully managed
echo Specifically, ensure that the Guest account is disabled and that any default accounts created by software installations are necessary and secure. >> "%TMP1%"

:: Example command to check the status of the Guest account
net user Guest | findstr /C:"Account active" >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

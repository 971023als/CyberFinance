@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo CODE [SRV-075] Predictable Account Password Presence >> "%TMP1%"
echo [Good]: Strong password policy is enforced >> "%TMP1%"
echo [Vulnerable]: Weak password policy is enforced >> "%TMP1%"

:: Note to the administrator for manual checks or using PowerShell for automation
echo For detailed password policy checks, consider using Local Security Policy (secpol.msc) or Group Policy Management (for domain-joined machines). >> "%TMP1%"
echo Alternatively, PowerShell commands can be used to query and set password policies. >> "%TMP1%"
echo Example PowerShell cmdlet to check password policy: Get-LocalUser | Get-LocalUser | Select-Object Name,PasswordRequired,PasswordLastSet,PasswordExpires,UserMayChangePassword,AccountExpires >> "%TMP1%"

:: Example of a basic check for the existence of a specific account, like Guest, which should generally be disabled
net user Guest | findstr /C:"Account active" >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

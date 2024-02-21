@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-080] Restriction of Printer Driver Installation by Standard Users >> "%TMP1%"
echo [Good]: Installation of printer drivers is restricted for standard users >> "%TMP1%"
echo [Vulnerable]: There are no restrictions for standard users on installing printer drivers >> "%TMP1%"

:: Note to the administrator for manual checks
echo For domain-joined machines, check Group Policy settings related to printer installation restrictions. >> "%TMP1%"
echo Specifically, review the policies under "Computer Configuration\Administrative Templates\Printers". >> "%TMP1%"
echo For standalone machines, printer installation restrictions can be configured via the Local Group Policy Editor (gpedit.msc). >> "%TMP1%"
echo Additionally, check "User Configuration\Administrative Templates\Control Panel\Printers" for user-specific policies. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

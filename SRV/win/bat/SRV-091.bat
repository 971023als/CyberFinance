@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [U-91] Presence of files unnecessarily set with SUID, SGID bits >> "%TMP1%"
echo [Good]: No files are set with SUID and SGID bits unnecessarily >> "%TMP1%"
echo [Vulnerable]: Files are set with SUID and SGID bits unnecessarily >> "%TMP1%"

:: Placeholder directory for checking - adjust as necessary
set "checkDir=C:\Path\To\Check"

:: Using icacls to list permissions of files
echo Checking files in %checkDir% for potentially elevated permissions >> "%TMP1%"
for /R "%checkDir%" %%F in (*.*) do (
    icacls "%%F" >> "%TMP1%"
)

:: Note: This script simply lists permissions of files, it does not interpret them to find equivalents of SUID/SGID.
:: Interpretation of 'potentially elevated permissions' would need to be done manually or with more complex scripting.

echo Check complete. See %TMP1% for details.

echo.
echo Script complete.

@echo off
setlocal

:: Define the result file
set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-093] Presence of unnecessary world writable files >> "%TMP1%"
echo [Good]: There are no unnecessary world writable files in the system >> "%TMP1%"
echo [Vulnerable]: There are unnecessary world writable files in the system >> "%TMP1%"

:: Placeholder directory to check - you would need to adjust this as necessary
set "checkDir=C:\Path\To\Check"

:: Using icacls to check permissions. This is a very basic and not exhaustive check.
:: It lists permissions and checks for the presence of "Everyone:(F)" which indicates full control.
icacls "%checkDir%"*.* /T | findstr "Everyone:(F)" > nul

if errorlevel 1 (
    echo OK "※ U-15 result: Good - No excessively permissive files found." >> "%TMP1%"
) else (
    echo WARN "Excessively permissive files found." >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

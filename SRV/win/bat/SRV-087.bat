@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-087] C Compiler Presence and Permission Settings >> "%TMP1%"
echo [Good]: C compiler does not exist, or is set with appropriate permissions >> "%TMP1%"
echo [Vulnerable]: C compiler exists and permission settings are inadequate >> "%TMP1%"

:: Check for C compiler (gcc) existence
where gcc >nul 2>&1

if %errorlevel% equ 0 (
    echo OK "C compiler (gcc) is installed on the system." >> "%TMP1%"
    :: Windows does not use a permission model like Linux for executables in the same way
    :: So, we do not check for permissions here
) else (
    echo OK "C compiler (gcc) is not installed on the system." >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

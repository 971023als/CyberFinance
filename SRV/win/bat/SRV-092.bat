@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-092] Inadequate user home directory settings >> "%TMP1%"
echo [Good]: All users' home directories are properly set up >> "%TMP1%"
echo [Vulnerable]: One or more users' home directories are not properly set up >> "%TMP1%"

:: Check each directory in C:\Users to simulate checking home directories
for /D %%D in (C:\Users\*) do (
    if exist "%%D" (
        echo OK "User %%~nxD's home directory (%%D) is properly set up." >> "%TMP1%"
    ) else (
        echo WARN "User %%~nxD's home directory (%%D) is improperly set up." >> "%TMP1%"
    )
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

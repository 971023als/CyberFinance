@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-082] System Major Directory Permission Settings >> "%TMP1%"
echo [Good]: System major directories are set with appropriate permissions >> "%TMP1%"
echo [Vulnerable]: System major directories are not set with appropriate permissions >> "%TMP1%"

:: Check for insecure entries in the PATH environment variable
echo Checking PATH for insecure entries >> "%TMP1%"
set "insecure=0"
for %%A in (%PATH:;= %) do (
    if "%%A"=="." (
        set /a insecure+=1
        echo WARNING: PATH contains "." which might be insecure >> "%TMP1%"
    )
)

if %insecure% equ 0 (
    echo OK: PATH does not contain any insecure entries >> "%TMP1%"
) else (
    echo WARN: PATH contains insecure entries >> "%TMP1%"
)

:: Placeholder for checking system startup scripts or directories
:: Example: List files in Windows startup folder (Adjust path as necessary)
echo Listing files in common startup locations: >> "%TMP1%"
for %%D in ("%AppData%\Microsoft\Windows\Start Menu\Programs\Startup", "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp") do (
    if exist "%%~D" (
        echo Files in %%~D: >> "%TMP1%"
        dir "%%~D" /b >> "%TMP1%"
    ) else (
        echo INFO: %%~D does not exist >> "%TMP1%"
    )
)

:: Note: Actual permission checks would require more complex scripting or PowerShell

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

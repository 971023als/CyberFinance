@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-083] System Startup Script Permission Settings >> "%TMP1%"
echo [Good]: System startup scripts are set with appropriate permissions >> "%TMP1%"
echo [Vulnerable]: System startup scripts are not set with appropriate permissions >> "%TMP1%"

:: Common Windows startup script location (adjust as necessary)
set "STARTUP_DIR=%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"

:: List executable files in the startup directory
echo Listing scripts in the startup directory: >> "%TMP1%"
if exist "%STARTUP_DIR%" (
    for %%f in ("%STARTUP_DIR%\*.*") do (
        echo %%f >> "%TMP1%"
        :: Placeholder for permission check (actual check would require more complex scripting or PowerShell)
        echo INFO: Check permissions of %%f manually or use PowerShell for detailed analysis >> "%TMP1%"
    )
) else (
    echo INFO: The startup directory does not exist >> "%TMP1%"
)

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

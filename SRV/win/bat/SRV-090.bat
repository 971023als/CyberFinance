@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-090] Unnecessary Remote Registry Service Activation >> "%TMP1%"
echo [Good]: The Remote Registry service is disabled >> "%TMP1%"
echo [Vulnerable]: The Remote Registry service is enabled >> "%TMP1%"

:: Check the status of the Remote Registry service
sc query RemoteRegistry | findstr /C:"STATE" > temp_status.txt
findstr /C:"RUNNING" temp_status.txt > nul

if %errorlevel% equ 0 (
    echo WARN "The Remote Registry service is enabled." >> "%TMP1%"
) else (
    echo OK "The Remote Registry service is disabled." >> "%TMP1%"
)

del temp_status.txt

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

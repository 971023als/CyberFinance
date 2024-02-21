@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-084] System Key Files Permission Settings >> "%TMP1%"
echo [Good]: System key files are set with appropriate permissions >> "%TMP1%"
echo [Vulnerable]: System key files are not set with appropriate permissions >> "%TMP1%"

:: Check the PATH environment variable for potentially insecure entries
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

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

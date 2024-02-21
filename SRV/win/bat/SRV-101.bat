@echo off
call function.bat

set TMP1=SCRIPTNAME.log
type nul > %TMP1%

call :BAR

echo [SRV-101] 불필요한 예약된 작업 존재 >> %TMP1%

echo [양호]: 불필요한 cron 작업이 존재하지 않는 경우 >> %result%
echo [취약]: 불필요한 cron 작업이 존재하는 경우 >> %result%

call :BAR

:: 시스템의 모든 예약된 작업을 검사합니다
for /f "tokens=*" %%i in ('schtasks /query /fo LIST ^| findstr "TaskName"') do (
    echo %%i
    :: 여기서 불필요한 작업을 식별하는 로직을 추가할 수 있습니다.
    :: 예: echo WARN "불필요한 예약된 작업이 존재할 수 있습니다: %%i"
)

echo OK "불필요한 cron 작업이 존재하지 않습니다." >> %result%

type %result%

echo.
exit /b

:BAR
echo -----------------------------------------
exit /b

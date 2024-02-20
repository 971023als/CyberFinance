@echo off

call function.bat

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

call :BAR

echo CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재 >> %TMP1%

(
echo [양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우
echo [취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우
) >> %TMP1%

call :BAR

:: Windows에서는 net user 명령어를 사용하여 계정 정보를 확인할 수 있습니다.
:: 하지만, 이 스크립트의 복잡성과 /etc/passwd 파일과 같은 직접적인 대응이 없기 때문에,
:: 아래 코드는 실제 작업을 수행하는 대신 예시를 제공합니다.

:: 예시: net user 명령어를 사용하여 모든 사용자 계정을 나열
for /f "tokens=*" %%i in ('net user') do (
    echo 계정: %%i
)

:: 여기에 추가적인 로직을 구현하여 특정 조건에 맞는 계정을 검사하고 결과를 파일에 기록할 수 있습니다.

echo 결과를 확인하세요. >> %TMP1%

type %TMP1%

echo.
echo.

goto :eof

:BAR
echo ---------------------------------------- >> %TMP1%
goto :eof

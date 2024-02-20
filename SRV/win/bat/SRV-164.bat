@echo off
setlocal EnableDelayedExpansion

call function.bat

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-164] 구성원이 존재하지 않는 GID 존재 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

(
echo [양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우
echo [취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우
) >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: Windows에서 그룹 및 그룹 구성원을 나열하는 정확한 방법은 PowerShell을 사용하는 것입니다.
:: 아래의 코드는 예시이며 실제로 실행되지는 않습니다.
:: PowerShell 예제: Get-LocalGroup | ForEach-Object { $group = $_; Get-LocalGroupMember -Group $group.Name | ForEach-Object { echo $_.Name } }

echo 결과를 확인하세요. >> %TMP1%

type %TMP1%

echo.
echo.

endlocal

@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-140] 이동식 미디어 포맷 및 꺼내기 허용 정책 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 적절하게 설정되어 있는 경우 >> %TMP1%
echo [취약]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 설정되어 있지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 이동식 미디어의 자동 재생 설정 확인
powershell -Command "& { $autoPlay = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun'; if ($autoPlay.NoDriveTypeAutoRun -ne $null) { if ($autoPlay.NoDriveTypeAutoRun -eq 255) { echo OK: 이동식 미디어의 자동 재생이 비활성화되어 있습니다. } else { echo WARN: 일부 이동식 미디어의 자동 재생이 활성화되어 있을 수 있습니다. } } else { echo INFO: 자동 재생 설정이 레지스트리에 명시적으로 설정되어 있지 않습니다. } }" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal

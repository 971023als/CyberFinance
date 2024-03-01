@echo off
setlocal

:: 필요한 ODBC 데이터 소스 정의
set necessarySources=필요한_소스_1 필요한_소스_2

:: 모든 ODBC 데이터 소스 나열
for /f "tokens=2 delims==" %%i in ('odbcconf /q ^| find "DSN="') do (
    call :checkSource %%i
)

:: 배치 스크립트는 PowerShell처럼 직접 OLE-DB 제공자를 나열할 수 없으므로 이 부분은 생략됩니다.
:: 필요한 OLE-DB 드라이버의 수동 목록을 유지하고 다른 수단으로 존재 여부를 확인하는 것을 고려하세요.

goto :eof

:checkSource
set source=%1
set found=0
for %%s in (%necessarySources%) do (
    if "%%s"=="%source%" set found=1
)

if %found%==0 (
    echo 불필요한 ODBC 데이터 소스 발견: %source%
)
goto :eof

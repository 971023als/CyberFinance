@echo off

:: 관리자 권한 확인 및 요청
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
:: 환경 설정
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------설정 시작---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt

:: 보안 정책 및 시스템 정보 내보내기
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt  0
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt
for /f "tokens=2 delims=:" %%y in ('type C:\Window_%COMPUTERNAME%_raw\install_path.txt') do set install_path=c:%%y
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

:: IIS 설정 검사
echo ------------------------------------------IIS 설정-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
set "line=!line!%%a" 
)
echo !line! >> C:\Window_%COMPUTERNAME%_raw\line.txt
for /F "tokens=1-5 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path1.txt
    echo %%b >> C:\Window_%COMPUTERNAME%_raw\path2.txt
    echo %%c >> C:\Window_%COMPUTERNAME%_raw\path3.txt
    echo %%d >> C:\Window_%COMPUTERNAME%_raw\path4.txt
    echo %%e >> C:\Window_%COMPUTERNAME%_raw\path5.txt
)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------설정 완료-------------------------------------------

:: SNMP 및 SMTP 서비스 상태 점검
echo ------------------------------------------SNMP 서비스 점검------------------------------------------
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers
if %errorlevel% == 0 (
    echo SNMP 서비스가 활성화되었습니다. 특정 호스트에서 SNMP 패킷을 수신할 수 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
) else (
    echo SNMP 서비스가 비활성화되었습니다. 모든 호스트에서 SNMP 패킷을 수신할 수 없습니다. 설정이 필요합니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
)
echo --------------------------------------------------------------------------------

echo --------------------------------------SMTP 서비스 실행 상태 점검--------------------------------------
sc query smtp | findstr /i "RUNNING"
if %errorlevel% == 0 (
    echo SMTP 서비스가 실행 중입니다. 필요하지 않은 경우, 서비스를 비활성화하는 것을 고려해보세요. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
) else (
    echo SMTP 서비스가 실행 중이지 않습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
)
echo --------------------------------------------------------------------------------

echo 결과가 C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt에 저장되었습니다.

:end
endlocal
echo 스크립트 실행이 완료되었습니다.
pause

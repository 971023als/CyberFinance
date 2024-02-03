@echo off
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
chcp 437
color 02
setlocal enabledelayedexpansion

echo ------------------------------------------Setting---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt  0
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt
for /f "tokens=2 delims=:" %%y in ('type C:\Window_%COMPUTERNAME%_raw\install_path.txt') do set install_path=c:%%y
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS Setting-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
:: (IIS 설정 처리 로직)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

echo ------------------------------------------Hard Disk Share Diagnostic------------------------------------------
echo Checking for unnecessary hard disk shares...

:: 기본 공유 존재 유무 확인
echo Checking default shares...
net share | findstr /C:"C$" /C:"D$" >nul 2>&1
if errorlevel 1 (
    echo No default shares found. This is good for security.
) else (
    echo Default shares found. Consider removing them if not needed.
)

:: AutoShareServer 및 AutoShareWks 레지스트리 값 확인
echo Checking AutoShareServer and AutoShareWks registry values...
reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareWks >nul 2>&1
if errorlevel 1 (
    echo AutoShareWks is not set. This is good for security on workstations.
) else (
    echo AutoShareWks is set. Consider setting it to 0 if not needed.
)

reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareServer >nul 2>&1
if errorlevel 1 (
    echo AutoShareServer is not set. This is good for security on servers.
) else (
    echo AutoShareServer is set. Consider setting it to 0 if not needed.
)

echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부-------------------------------------
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo Script execution completed.
pause

@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
chcp 65001
color 02
setlocal enabledelayedexpansion

echo ------------------------------------------Environment Setup---------------------------------------
if exist C:\Window_%COMPUTERNAME%_raw rd /S /Q C:\Window_%COMPUTERNAME%_raw
if exist C:\Window_%COMPUTERNAME%_result rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result

secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS Configuration-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_path1.txt

for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
    set "line=!line!%%a" 
)
echo !line! > C:\Window_%COMPUTERNAME%_raw\line.txt

for /L %%i in (1,1,5) do (
    for /F "tokens=%%i delims=*" %%a in (C:\Window_%COMPUTERNAME%_raw\line.txt) do (
        echo %%a >> C:\Window_%COMPUTERNAME%_raw\path%%i.txt
    )
)
type %WinDir%\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

echo ------------------------------------------SNMP Community String and Security------------------------------------------
:: Information and instructions about securing SNMP community strings

echo ------------------------------------------SMTP Service Check---------------------------------------
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt echo Checking SMTP service status...
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo Script execution completed.
pause

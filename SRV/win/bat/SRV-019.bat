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
:: Change code page to UTF-8 for better character encoding support
chcp 65001
color 02
setlocal enabledelayedexpansion

echo ------------------------------------------Setting---------------------------------------
:: Cleanup old directories and setup new ones
if exist C:\Window_%COMPUTERNAME%_raw rd /S /Q C:\Window_%COMPUTERNAME%_raw
if exist C:\Window_%COMPUTERNAME%_result rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result

:: Security policy and system information export
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS Setting-----------------------------------
:: Extract and process IIS settings
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
:: Processing IIS path information
for /F "delims=" %%a in (C:\Window_%COMPUTERNAME%_raw\iis_path1.txt) do (
    set "line=!line!%%a" 
)
echo !line! > C:\Window_%COMPUTERNAME%_raw\line.txt
:: Splitting into multiple files for readability
for /L %%i in (1,1,5) do (
    if exist C:\Window_%COMPUTERNAME%_raw\path%%i.txt del C:\Window_%COMPUTERNAME%_raw\path%%i.txt
    for /F "tokens=%%i delims=*" %%a in (C:\Window_%COMPUTERNAME%_raw\line.txt) do (
        echo %%a >> C:\Window_%COMPUTERNAME%_raw\path%%i.txt
    )
)
type %WinDir%\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

:: SNMP and SMTP sections remain largely unchanged but should ensure proper encoding and error handling

echo Script execution completed.
pause

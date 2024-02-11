@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
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
:: Set console to UTF-8 to improve compatibility with non-ASCII characters
chcp 65001
color 02
setlocal enabledelayedexpansion

echo ------------------------------------------Setting---------------------------------------
:: Clean up previous data and prepare environment
if exist C:\Window_%COMPUTERNAME%_raw rd /S /Q C:\Window_%COMPUTERNAME%_raw
if exist C:\Window_%COMPUTERNAME%_result rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result

:: Export local security policy and system info
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS Setting-----------------------------------
:: Extract IIS configuration for analysis
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
type %WinDir%\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

echo ------------------------------------------Hard Disk Share Diagnostic------------------------------------------
echo Checking for unnecessary hard disk shares...
:: Check for default and unnecessary shares
net share | findstr /C:"C$" /C:"D$" >nul 2>&1
if %errorlevel% == 0 (
    echo Default shares (C$, D$) exist. Consider reviewing them for security.
) else (
    echo No default shares detected. This is preferable for security.
)

:: Check for AutoShareServer and AutoShareWks in the registry
reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareWks >nul 2>&1
if %errorlevel% == 0 (
    echo AutoShareWks is enabled. Consider disabling it for enhanced security on workstations.
) else (
    echo AutoShareWks is disabled. This is preferable for workstation security.
)

reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareServer >nul 2>&1
if %errorlevel% == 0 (
    echo AutoShareServer is enabled. Consider disabling it for enhanced security on servers.
) else (
    echo AutoShareServer is disabled. This is preferable for server security.
)

echo -------------------------------------------end------------------------------------------

echo --------------------------------------SMTP Service Status-------------------------------------
:: Check SMTP service status and log to file
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt (
    echo Checking SMTP service status...
    sc query smtp
)
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo Script execution completed. Review the results for any necessary actions.
pause

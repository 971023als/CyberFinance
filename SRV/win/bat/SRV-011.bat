@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
:: Setting code page to ensure script runs correctly in different language settings
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------Settings Initialization---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw 2>nul
rd /S /Q C:\Window_%COMPUTERNAME%_result 2>nul
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result

:: Exporting local security policy
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

:: Extracting IIS settings
echo ------------------------------------------IIS Settings Extraction-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

:: Checking SNMP and SMTP service settings
echo ------------------------------------------SNMP and SMTP Service Check-----------------------------------------
:: Here you might include commands to check SNMP settings, e.g., querying registry or SNMP service configuration
echo Checking SMTP service status... >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

:: Additional security checks or configurations can be added here

echo Script execution completed. Check the results in C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt.

:end
endlocal
echo Script has finished.
pause

@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "getadmin.vbs"
    "getadmin.vbs"
    del "getadmin.vbs"
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
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
set "line=!line!%%a" 
)
echo !line!>>C:\Window_%COMPUTERNAME%_raw\line.txt
for /F "tokens=1 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path1.txt
)
for /F "tokens=2 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path2.txt
)
for /F "tokens=3 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path3.txt
)
for /F "tokens=4 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path4.txt
)
for /F "tokens=5 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path5.txt
)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------end-------------------------------------------
echo ------------------------------------------SRV-001------------------------------------------
SRV-001 (Windows) SNMP Community String Security Configuration

Guideline Introduction:
The SNMP service uses the SNMP protocol for network management and location monitoring/control. This guideline is for enhancing the security of SNMP community strings.

Risk Assessment:
- Action: Set SNMP Community String to something other than the default (Public, Private) with enhanced security.
- Result: If SNMP Community String is set to default (Public, Private) or not secured.

Community String Security:
Beyond the default (public, private), ensure complexity and length are sufficient – at least 10 characters including letters, numbers, and special characters, or at least 8 characters if including mixed case and special characters. It is recommended to use SNMP v3 for enhanced security.

Mitigation Steps:
1. Verify SNMP service and SNMP Community String security.
    Registry Path: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
    If no SNMP service is running, "Action" is recommended.

For Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022:
    Control Panel > Administrative Tools > services.msc > Properties > SNMP Service > Security tab >
    "Accepted community names" > "SNMP community string" entry
Or:
    cmd > reg query <registry_path>
        <SNMP_community_string>     REG_DWORD    0x4
Or:
    cmd > reg query <registry_path>
        ERROR: The system was unable to find the specified registry key or value.

"ValidCommunities" Key and Value:
    - Name: 
    - Type: REG_DWORD
    - Data: 1 (Read), 2 (Write), 4 (Create Delete) 8 (Create, Delete), 16 (Create, Delete, Notify)

Configuration Recommendations:
1. Apply settings to enhance the security of SNMP Community String.
    It is recommended to use secure strings (passwords, keys) and set "read-only" where necessary.
    If using SNMP service for management, ensure SNMP Manager and Agent have the same Community String configured for use.
2. Update SNMP service configuration.
echo -------------------------------------------end-------------------------------------------

echo --------------------------------------SRV-004 Essential SMTP Service Status Check------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

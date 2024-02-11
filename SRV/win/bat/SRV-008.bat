@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
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
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------설정 시작---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw 2>nul
rd /S /Q C:\Window_%COMPUTERNAME%_result 2>nul
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result

:: 보안 정책 및 시스템 정보 수집
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

:: IIS 설정 정보 수집
echo ------------------------------------------IIS 설정 검사-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

:: SNMP 및 SMTP 서비스 상태 검사
echo ------------------------------------------SNMP 설정 검사-----------------------------------------
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers > C:\Window_%COMPUTERNAME%_result\SNMP_Permissions.txt

echo ------------------------------------------SMTP 서비스 상태 검사--------------------------------------
sc query smtp > C:\Window_%COMPUTERNAME%_result\SMTP_Status.txt

echo 결과는 C:\Window_%COMPUTERNAME%_result\ 폴더에 저장되었습니다.
echo ------------------------------------------작업 완료-------------------------------------------

:end
endlocal
echo 스크립트 실행 완료.
pause

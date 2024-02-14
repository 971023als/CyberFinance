@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한이 필요합니다. 스크립트를 관리자 권한으로 다시 실행해 주세요.
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
chcp 949
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------환경 설정 중---------------------------------------
if exist C:\Window_%COMPUTERNAME%_raw rd /S /Q C:\Window_%COMPUTERNAME%_raw
if exist C:\Window_%COMPUTERNAME%_result rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS 설정 정보 수집 중-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr /i "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

echo ------------------------------------------SNMP 및 SMTP 설정 검토 중--------------------------------
:: SNMP 설정 검토가 필요합니다 (이 부분은 실제 환경에 맞게 구성해야 합니다)
:: SMTP 서비스 상태 확인
sc query smtp > C:\Window_%COMPUTERNAME%_result\SMTP_Status.txt

echo 모든 작업이 성공적으로 완료되었습니다.
pause

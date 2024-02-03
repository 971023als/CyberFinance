@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 요청 중: 관리자 권한...
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
echo ------------------------------------------Setting---------------------------------------
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
echo ------------------------------------------IIS Setting-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

:: SMTP 서비스 검사
echo ------------------------------------------SMTP Service Check-----------------------------------------
echo Checking SMTP service status... >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

:: SMTP 서비스 점검 결과 기록
echo SRV-001 (Windows) SNMP Community 스트링 설정 미흡 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo SRV-004 (Windows) 불필요한 SMTP 서비스 실행 여부 점검 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
netstat -an | findstr :25 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo ------------------------------------------End of Checks------------------------------------------ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo 점검 완료. 결과 파일은 C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 에 저장되었습니다.


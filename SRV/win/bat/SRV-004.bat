@echo off

:: 관리자 권한 확인 및 요청
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
echo ------------------------------------------IIS 설정 정보-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

:: SMTP 서비스 상태 점검
echo ------------------------------------------SMTP 서비스 점검-----------------------------------------
echo SMTP 서비스 상태 확인 중... >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

:: SMTP 서비스 상세 점검 및 결과 기록
echo SRV-001 (Windows) SNMP 커뮤니티 문자열 검증 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo SRV-004 (Windows) 필요 시 SMTP 서비스 비활성화 고려 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
netstat -an | findstr :25 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo ------------------------------------------점검 종료------------------------------------------ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo 점검 완료. 결과 파일은 C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 에 저장되었습니다.

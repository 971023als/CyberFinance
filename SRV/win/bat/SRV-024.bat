rem windows server script edit 2020
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
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
SRV-024 (Windows) 취약한 Telnet 인증 방식 사용

【 상세설명 】
Telnet 서비스는 평문으로 데이터를 송수신하므로 패스워드 방식으로 인증을 수행할 경우 계정 및 패스워드가 노출될 위험성이 존재함. 네트워크상으로 패스워드를 전송하지 않는 NTLM 인증 설정을 적용하고 있는지 점검

【 판단기준 】
- 양호 : Telnet 서비스가 실행 중이 아니거나 인증 방법 중 NTLM만 허용할 경우
- 취약 : Telnet 서비스가 실행되고 있으며 인증 방법 중 password 방식을 지원할 경우

【 판단방법 】
  1. Telnet 서비스 "인증 메커니즘" 설정 확인
      ※ "Authentication Mechanism(인증 메커니즘)" 에 "password" 설정이 존재하면 "취약"

  ■ Windows 2008, 2008 R2, 2012, 2012 R2
      cmd > tlntadmn config
            The following are the settings on localhost(다음은 localhost의 설정입니다.)

            Alt Key Mapped to 'CTRL+A'(<Ctrl+A>에 매핑된 <Alt> 키) : YES
            Idle session timeout(유휴 세션 시간 제한) : 1 hours
            Max connections(최대 연결) : 5
            Telnet port(텔넷 포트) : 23
            Max failed login attempts(실패한 최대 로그인 시도 횟수) : 3
            End tasks on disconnect(연결 해제 시 작업 마침) : YES
            Mode of Operation(작업 모드) : Console
            Authentication Mechanism(인증 메커니즘) : NTLM, Password
            Default Domain(기본 도메인) : 49block
            State(상태) : Running

  ※ Windows 서버 Telnet 서비스 인증 방식
      - NTLM 인증 : 암호를 전송하지 않고 negotiate/challenge/response 방식으로 인증
      - Password 인증 : 관리자 및 TelnetClients 그룹에 포함된 ID/PWD로 인증

  ■ Windows 2016, 2019, 2022 : Telnet 서비스를 지원하지 않으므로 해당사항 없음

【 조치방법 】
  1. Telnet 서비스 "인증 메커니즘" 설정에서 "password" 설정 제거
  2. 업무상 불필요한 경우 Telnet 서비스 중지

  2024-01-13 : (조치과정 삭제)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

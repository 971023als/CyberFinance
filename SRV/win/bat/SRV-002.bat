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
SRV-001 (Windows) SNMP Community 스트링 설정 미흡

SRV-003 (Windows) SNMP 접근 통제 미설정

【 상세설명 】
SNMP 서비스는 네트워크 관리 및 네트워크 장치의 동작을 감시/통할하는 SNMP 프로토콜을 기반으로 하는 서비스로, SNMP서비스를 사용할 수 있는 호스트를 특정하여 접근통제를 수행하고 있는지 점검

【 판단기준 】
- 양호 : 특정 호스트로부터만 SNMP 패킷 받아들이기로 설정되어 있는 경우
- 취약 : 모든 호스트로부터 SNMP 패킷 받아들이기로 설정되어 있는 경우

【 판단방법 】
  1. 특정 호스트로부터만 SNMP 패킷 받아들이기로 설정되어 있는지 확인
      ※ <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers
      ※ 설정된 특정 호스트 존재할 시 "양호"
      ※ 레지스트리 값이 존재하지 않으면 등록된 호스트 주소가 없으므로 "취약" 으로 판단

  ■ Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      ① 시작 > 실행 > services.msc > 서비스 > SNMP Service 속성 > "보안" 탭
      ② "인증 트랩 보내기", "다음 호스트로부터 SNMP 패킷 받아들이기" 체크 확인 및 등록된 호스트 확인
  또는
      cmd > reg query <registry_path>

  또는
      cmd > reg query <registry_path>
          1     REG_SZ    localhost
          2     REG_SZ    <ip_address>
          …

  ※ "PermittedManagers" Key 의 Value 값
      - 이름 : <Number> 
      - 종류 : REG_SZ
      - 데이터 : <Host_name>, <ip_address>, <ipx_address>

【 조치방법 】
  1. "인증 트랩 보내기", "다음 호스트로부터만 SNMP 패킷 받아들이기" 설정 및 접근 허용 특정 호스트 등록
      ※ 레지스트리 값을 등록하면 "다음 호스트로부터만 SNMP 패킷 받아들이기" 으로 설정이 변경됨
  2. SNMP 서비스 재시작
 
  2024-01-13 : (조치과정 삭제)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

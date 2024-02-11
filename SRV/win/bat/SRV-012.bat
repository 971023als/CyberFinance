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
SRV-001 (Windows) SNMP Community 스트링 보안 설정

이 가이드라인은
SNMP 서비스는 네트워크 관리 및 네트워크 위치의 모니터링/관리를 위한 SNMP 프로토콜을 사용하여, SNMP 요청 및 응답 메시지를 처리하는 서비스로, SNMP 커뮤니티 스트링의 보안성을 강화하기 위한 SNMP community string의 보안성을 강화하기 위한 지침입니다

이 위험성 평가는
- 조치 : SNMP Community String 기본 값(Public, Private)이 아니고, 아래의 보안성을 강화한 값으로 설정
- 결과 : SNMP Community String 기본 값(Public, Private)이거나, 보안성을 강화하지 않은 경우

이 (커뮤니티) 기본값(public, private) 이외에, 복잡도, 길이가 최소 10자 이상 혹은 특수문자, 숫자, 대소문자를 포함 8자 이상
이 SNMP v3를 사용하여 보안을 강화하는 것을 권장하며, 해당 비밀번호의 보안성을 강화하기 위해 "조치"를 권장

이 조치 방법은
  1. SNMP 서비스 및 SNMP Community String의 보안성을 강화하는지 확인
      예 <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
      예 시스템에서 실행 중인 SNMP 서비스가 없으면 "조치"를 권장

  대상 Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      예 제어판 > 관리 도구 > services.msc > 속성 > SNMP Service 속성 > "보안" 탭 >
      예 "수신하는 트랩 커뮤니티 이름" > "SNMP community string" 항목
  또는
      cmd > reg query <registry_path>
          <SNMP_community_string>     REG_DWORD    0x4
  또는
      cmd > reg query <registry_path>
          ERROR: The system was unable to find the specified registry key or value.

  예 "ValidCommunities" Key 및 Value는
      - 이름 : 
      - 유형 : REG_DWORD
      - 데이터 : 1(읽기), 2(쓰기), 4(생성 삭제) 8(생성, 삭제), 16(생성, 삭제, 알림)

이 설정방법은
  1. SNMP Community String의 보안성을 강화하는 설정을 적용
      예 문자열(암호, 키) 등의 보안 문자열을 사용하는 것을 권장하며, "읽기 전용" 설정이 필요한 경우 "쓰기 금지" 설정을 권장
      예 NMS, 관리도구 등이 사용하는 SNMP 서비스를 관리하는 경우 SNMP Manager 및 Agent 간에 동일한 Community String을 설정하여 사용 권장
  2. SNMP 서비스 설정 변경
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 필수적인 SMTP 서비스 상태 확인------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

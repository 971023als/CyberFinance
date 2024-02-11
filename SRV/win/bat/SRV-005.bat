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
echo ------------------------------------------설정 시작---------------------------------------
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
echo ------------------------------------------IIS 설정 확인-----------------------------------
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
echo ------------------------------------------종료-------------------------------------------
echo ------------------------------------------SRV-005------------------------------------------
SRV-005 (Windows) SNMP Community 문자열 보안 점검

상세 설명:
SNMP 서비스는 네트워크 관리 및 네트워크 위치 정보를 수집/관리하는 SNMP 프로토콜을 지원하는 서비스로, SNMP 서비스를 사용하여 네트워크 장치 상태를 모니터링할 수 있습니다. SNMP community string은 해당 서비스의 보안 수준을 결정합니다.

위험 분석:
- 위험: SNMP Community String이 기본 값(Public, Private)이거나, 약한 보안 수준을 가진 경우
- 영향: SNMP Community String이 기본 값(Public, Private)이거나, 약한 보안 수준을 가진 경우

(보안 수준) 기본값(public, private) 이상, 복잡도, 길이, 특수문자 포함 8자 이상
- SNMP v3의 경우 보다 강화된 보안 설정을 권장하며, 해당 비밀번호는 약한 보안 수준을 가지지 않아야 합니다.

위치 점검 방법:
1. SNMP 서비스 및 SNMP Community String의 보안 수준을 점검
   - <registry_path>: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
   - 관련 문서에 따르면 SNMP 서비스가 설치된 경우 해당 서비스를 사용하여 네트워크 장치 상태를 모니터링할 때 "위험" 또는 "안전"을 판단

Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
- 제어판 > 관리 도구 > services.msc > 속성 > SNMP Service 속성 > "보안" 탭 >
- "수신 허용 커뮤니티", "수신 허용 호스트에서 SNMP 메시지 수신" 체크 확인 및 관련 호스트 확인
또는
cmd > reg query <registry_path>
    <SNMP_community_string>     REG_DWORD    0x4
또는
cmd > reg query <registry_path>
    ERROR: The system was unable to find the specified registry key or value.

"ValidCommunities" Key의 Value:
- 이름: 
- 타입: REG_DWORD
- 데이터: 1(읽기), 2(쓰기), 4(생성 삭제) 8(생성, 삭제), 16(생성, 삭제, 알림)

설정 변경 방법:
1. SNMP Community String의 보안 수준을 강화하는 설정 변경
   - 복잡한 문자열(대문자, 소문자 등)을 포함한 비밀번호를 사용하고, 공식 문서에 따라 "읽기 전용" 또는 "쓰기 전용" 설정 권장
   - NMS, 관리자에게만 SNMP 서비스를 사용할 수 있도록 SNMP Manager 및 Agent 사이의 Community String을 공유하고 변경된 설정을 적용하여 보안 강화
2. SNMP 서비스 재설정
echo -------------------------------------------종료------------------------------------------

echo --------------------------------------SRV-005 필수 SMTP 서비스 실행 상태 확인------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

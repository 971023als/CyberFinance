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
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0
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
echo ------------------------------------------설정 완료-------------------------------------------

echo ------------------------------------------SRV-001------------------------------------------
SRV-001 (Windows) SNMP Community 문자열 안전 설정

상세 설명 및 점검 방법
SNMP 서비스는 네트워크 관리 및 네트워크 위치 정보를 수집/관리하는 SNMP 프로토콜을 지원하는 애플리케이션으로, SNMP 서비스를 통해 외부 호스트가 네트워크 정보를 수집할 수 있으므로 SNMP community string이 안전하게 설정되어야 합니다.

점검 기준 및 결과
- 합격: SNMP Community String이 기본값(Public, Private)이 아니며, 아래 기준에 부합하는 경우
- 불합격: SNMP Community String이 기본값(Public, Private)이거나, 안전하지 않은 설정인 경우

(안전 기준) 기본값(public, private) 이외, 알파벳, 숫자가 포함된 10자 이상 또는 특수문자, 대소문자를 포함한 8자 이상
SNMP v3을 사용하여 보안성 강화 및 해당 비밀번호가 안전하게 설정된 경우 "합격"으로 판단

점검 방법 및 설정 방법
  1. SNMP 서비스 및 SNMP Community String의 안전성 여부를 확인
      경로: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
      네트워크상에서 SNMP 서비스가 활성화되어 외부에서 SNMP 프로토콜을 통해 정보를 수집할 수 있는 경우 "불합격"으로 판단

  Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      방법: 제어판 > 관리 도구 > services.msc > 속성 > SNMP Service 속성 > "보안" 탭 >
      "수신하는 커뮤니티 이름" > "SNMP community string" 상태
  또는
      cmd > reg query <registry_path>
          <SNMP_community_string>     REG_DWORD    0x4
  또는
      cmd > reg query <registry_path>
          ERROR: The system was unable to find the specified registry key or value.

  "ValidCommunities" Key의 Value 설명
      - 이름:
      - 유형: REG_DWORD
      - 데이터: 1(읽기), 2(쓰기), 4(생성 삭제) 8(생성, 삭제), 16(생성, 삭제, 알림)

설정 방법
  1. SNMP Community String의 안전성을 강화하는 설정을 적용
      알파벳, 숫자를 포함한 복잡한 문자열로 변경하고, 외부에서 접근할 수 없도록 설정
      "보안" 탭이 필요한 경우가 아니면 "생성 삭제" 권한 제한
      NMS, 관리자만 SNMP 서비스를 통해 정보를 수집할 수 있도록 SNMP Manager 및 Agent에 동일한 Community String이 설정되어 있어야 합니다.
  2. SNMP 서비스 강화
echo -------------------------------------------end-------------------------------------------

echo --------------------------------------SRV-004 필수적인 SMTP 서비스 실행 상태 확인------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

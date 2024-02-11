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
echo ------------------------------------------IIS 설정-----------------------------------
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
echo ------------------------------------------설정 끝-------------------------------------------

echo ------------------------------------------SRV-001------------------------------------------
SRV-001 (Windows) SNMP 커뮤니티 문자열의 안전한 설정

SRV-003 (Windows) SNMP 서비스 실행 점검

이 항목의 개요는 다음과 같습니다:
SNMP 서비스는 네트워크 관리 및 네트워크 위치 정보를 수집/제공하는 SNMP 프로토콜을 지원하는 서비스로, SNMP 서비스를 실행하는 호스트에서 관리 정보를 요청하고 제공하는 기능을 합니다.

이 항목의 진단 방법은 다음과 같습니다:
- 위험: 특정 호스트에서 SNMP 패킷을 수신하여 정보가 유출될 위험이 있습니다.
- 보호: 모든 호스트에서 SNMP 패킷을 수신하여 정보가 유출되지 않도록 보호합니다.

이 항목의 진단 절차는 다음과 같습니다:
1. 특정 호스트에서 SNMP 패킷을 수신하여 정보가 유출되는지 확인합니다.
    - 레지스트리 경로: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers
    - 위험한 호스트 목록에는 "위험"이라고 표시됩니다.
    - 보호된 호스트 목록에는 "보호"라고 표시됩니다.

Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022에서는 다음 절차를 따릅니다:
    - 제어판 > 관리 도구 > services.msc > 속성 > SNMP 서비스 속성 > "보안" 탭
    - "보안 커뮤니티 문자열", "제한된 호스트에서 SNMP 패킷 수신" 옵션 체크 및 제한된 호스트 확인
또는
    cmd > reg query <registry_path>

또는
    cmd > reg query <registry_path>
        1     REG_SZ    localhost
        2     REG_SZ    <ip_address>
        ...

"PermittedManagers" 키의 값은 다음과 같습니다:
    - 이름: <Number>
    - 유형: REG_SZ
    - 데이터: <Host_name>, <ip_address>, <ipx_address>

이 설정의 조치 방법은 다음과 같습니다:
1. "보안 커뮤니티 문자열", "제한된 호스트에서 SNMP 패킷 수신" 옵션을 비활성화 하고 특정 호스트만 허용
    - 관리도구에서 해당 옵션을 변경하거나 "제한된 호스트에서 SNMP 패킷 수신" 옵션을 비활성화
2. SNMP 서비스 재구성

2024-01-13: (설정 절차 업데이트)
echo -------------------------------------------끝-------------------------------------------

echo --------------------------------------SRV-004 필수적인 SMTP 서비스 실행 점검------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

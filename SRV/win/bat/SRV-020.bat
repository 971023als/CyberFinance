@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
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
echo ------------------------------------------IIS 설정 검토-----------------------------------
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
echo ------------------------------------------설정 종료-------------------------------------------

echo ------------------------------------------SRV-020 공유에 대한 접근 통제 미비------------------------------------------
echo
[상세 설명]
Windows의 공유 기능은 폴더, 디스크 드라이브, 프린터 등을 공유하여 다른 사용자들과 함께 사용할 수 있게 합니다. 공유에 대한 접근 통제가 미흡하면 비인가 접근 위험이 있으므로, 사용자 권한 및 그룹 설정 등 보안 설정의 적절성을 점검해야 합니다.

[판단 기준]
- 양호: 공유폴더가 없거나, 공유 폴더의 접근 권한에 Everyone이 없는 등 접근 통제가 잘 되어 있을 경우
- 취약: 공유폴더에 Everyone 권한이 존재하는 등 접근 통제가 미흡할 경우

[판단 방법]
공유폴더 존재 유무 및 권한 확인
※ 시스템에서 설정한 "공유 폴더(ADMIN$, IPC$, C$ 등)"를 제외한 폴더만 점검
※ 시스템에서 설정한 "공유 폴더"는 관리 목적으로 공유되어 있는 상태이며 "공유 사용 권한" 및 "파일 보안" 설정 변경이 불가능

[Windows 버전 지원]: 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022

공유폴더 및 권한 확인...
net share > %TEMP%\shares.txt
echo 공유 목록을 %TEMP%\shares.txt에 저장했습니다.

공유 폴더 중 Everyone 권한이 설정된 폴더 확인...
for /f "skip=4 tokens=1,* delims= " %%i in ('net share ^| findstr /vi "C$ IPC$ ADMIN$"') do (
    icacls "%%j" | findstr /c:"Everyone" > nul && (
        echo 취약한 공유폴더 발견: %%i - Everyone 권한이 감지되었습니다.
    ) || (
        echo %%i - Everyone 권한이 없습니다. 양호합니다.
    )
)

[조치 방법]
공유 폴더에서 불필요하게 부여된 Everyone 권한 제거

echo -------------------------------------------종료-------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부 확인---------------------------------------
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt echo 불필요한 SMTP 서비스 실행 여부를 확인합니다...
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo 스크립트 실행이 완료되었습니다.
pause

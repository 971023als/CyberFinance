@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ������ ������ ��û�մϴ�...
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
echo ------------------------------------------���� ����---------------------------------------
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
echo ------------------------------------------IIS ���� ����-----------------------------------
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
echo ------------------------------------------���� ����-------------------------------------------

echo ------------------------------------------SRV-020 ������ ���� ���� ���� �̺�------------------------------------------
echo
[�� ����]
Windows�� ���� ����� ����, ��ũ ����̺�, ������ ���� �����Ͽ� �ٸ� ����ڵ�� �Բ� ����� �� �ְ� �մϴ�. ������ ���� ���� ������ �����ϸ� ���ΰ� ���� ������ �����Ƿ�, ����� ���� �� �׷� ���� �� ���� ������ �������� �����ؾ� �մϴ�.

[�Ǵ� ����]
- ��ȣ: ���������� ���ų�, ���� ������ ���� ���ѿ� Everyone�� ���� �� ���� ������ �� �Ǿ� ���� ���
- ���: ���������� Everyone ������ �����ϴ� �� ���� ������ ������ ���

[�Ǵ� ���]
�������� ���� ���� �� ���� Ȯ��
�� �ý��ۿ��� ������ "���� ����(ADMIN$, IPC$, C$ ��)"�� ������ ������ ����
�� �ý��ۿ��� ������ "���� ����"�� ���� �������� �����Ǿ� �ִ� �����̸� "���� ��� ����" �� "���� ����" ���� ������ �Ұ���

[Windows ���� ����]: 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022

�������� �� ���� Ȯ��...
net share > %TEMP%\shares.txt
echo ���� ����� %TEMP%\shares.txt�� �����߽��ϴ�.

���� ���� �� Everyone ������ ������ ���� Ȯ��...
for /f "skip=4 tokens=1,* delims= " %%i in ('net share ^| findstr /vi "C$ IPC$ ADMIN$"') do (
    icacls "%%j" | findstr /c:"Everyone" > nul && (
        echo ����� �������� �߰�: %%i - Everyone ������ �����Ǿ����ϴ�.
    ) || (
        echo %%i - Everyone ������ �����ϴ�. ��ȣ�մϴ�.
    )
)

[��ġ ���]
���� �������� ���ʿ��ϰ� �ο��� Everyone ���� ����

echo -------------------------------------------����-------------------------------------------

echo --------------------------------------SRV-004 ���ʿ��� SMTP ���� ���� ���� Ȯ��---------------------------------------
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt echo ���ʿ��� SMTP ���� ���� ���θ� Ȯ���մϴ�...
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo ��ũ��Ʈ ������ �Ϸ�Ǿ����ϴ�.
pause

rem windows server script edit 2020
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ������ ������ ��û�մϴ�...
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
SRV-024 (Windows) ����� Telnet ���� ��� ���

�� �󼼼��� ��
Telnet ���񽺴� ������ �����͸� �ۼ����ϹǷ� �н����� ������� ������ ������ ��� ���� �� �н����尡 ����� ���輺�� ������. ��Ʈ��ũ������ �н����带 �������� �ʴ� NTLM ���� ������ �����ϰ� �ִ��� ����

�� �Ǵܱ��� ��
- ��ȣ : Telnet ���񽺰� ���� ���� �ƴϰų� ���� ��� �� NTLM�� ����� ���
- ��� : Telnet ���񽺰� ����ǰ� ������ ���� ��� �� password ����� ������ ���

�� �Ǵܹ�� ��
  1. Telnet ���� "���� ��Ŀ����" ���� Ȯ��
      �� "Authentication Mechanism(���� ��Ŀ����)" �� "password" ������ �����ϸ� "���"

  �� Windows 2008, 2008 R2, 2012, 2012 R2
      cmd > tlntadmn config
            The following are the settings on localhost(������ localhost�� �����Դϴ�.)

            Alt Key Mapped to 'CTRL+A'(<Ctrl+A>�� ���ε� <Alt> Ű) : YES
            Idle session timeout(���� ���� �ð� ����) : 1 hours
            Max connections(�ִ� ����) : 5
            Telnet port(�ڳ� ��Ʈ) : 23
            Max failed login attempts(������ �ִ� �α��� �õ� Ƚ��) : 3
            End tasks on disconnect(���� ���� �� �۾� ��ħ) : YES
            Mode of Operation(�۾� ���) : Console
            Authentication Mechanism(���� ��Ŀ����) : NTLM, Password
            Default Domain(�⺻ ������) : 49block
            State(����) : Running

  �� Windows ���� Telnet ���� ���� ���
      - NTLM ���� : ��ȣ�� �������� �ʰ� negotiate/challenge/response ������� ����
      - Password ���� : ������ �� TelnetClients �׷쿡 ���Ե� ID/PWD�� ����

  �� Windows 2016, 2019, 2022 : Telnet ���񽺸� �������� �����Ƿ� �ش���� ����

�� ��ġ��� ��
  1. Telnet ���� "���� ��Ŀ����" �������� "password" ���� ����
  2. ������ ���ʿ��� ��� Telnet ���� ����

  2024-01-13 : (��ġ���� ����)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 ���ʿ��� SMTP ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

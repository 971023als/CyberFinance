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
SRV-001 (Windows) SNMP Community ��Ʈ�� ���� ����

�� �󼼼��� ��
SNMP ���񽺴� ��Ʈ��ũ ���� �� ��Ʈ��ũ ��ġ�� ������ ����/�����ϴ� SNMP ���������� ������� �ϴ� ���񽺷�, SNMP ��� �� ���� ��� ���θ� �����ϱ� ���� SNMP community string�� ���⵵�� ���� �����Ǿ����� ����

�� �Ǵܱ��� ��
- ��ȣ : SNMP Community String �ʱ� ��(Public, Private)�� �ƴϰ�, �Ʒ��� ���⵵�� ���� �� ���
- ��� : SNMP Community String �ʱ� ��(Public, Private)�̰ų�, ���⵵�� �������� ���� ���

�� (���⵵) �⺻��(public, private) �̻��, ������, ���ڰ� ���� 10�ڸ� �̻� �Ǵ� ������, ����, Ư������ ���� 8�ڸ� �̻�
�� SNMP v3�� ��� ���� ���� ����� ����ϰ�, �ش� ��й�ȣ�� ���⵵�� ������ ��� "��ȣ"�� �Ǵ�

�� �Ǵܹ�� ��
  1. SNMP ���� �� SNMP Community String �� ���⵵�� �����ϴ��� Ȯ��
      �� <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
      �� ������Ʈ�� ���� �������� ������ SNMP ���񽺰� ���� ���̾ ���񽺸� ����� �� �����Ƿ� "��ȣ" �� �Ǵ�

  �� Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      �� ���� > ���� > services.msc > ���� > SNMP Service �Ӽ� > "����" �� >
      �� "�޾Ƶ��� Ŀ�´�Ƽ �̸�"  "> SNMP community string" �׸�
  �Ǵ�
      cmd > reg query <registry_path>
          <SNMP_community_string>     REG_DWORD    0x4
  �Ǵ�
      cmd > reg query <registry_path>
          ERROR: The system was unable to find the specified registry key or value.

  �� "ValidCommunities" Key �� Value ��
      - �̸� : 
      - ���� : REG_DWORD
      - ������ : 1(����), 2(�˸�), 4(�б� ����) 8(�б�, ����), 16(�б�, �����)

�� ��ġ��� ��
  1. SNMP Community String �� ���⵵�� �����ϴ� ������ ����
      �� �����ϱ� ���� ���ڿ�(�����, ���� ��) ��� ���� �� �Ϻ� ������� ���� �ǰ��ϴ� ����
      �� "����" ������ �ʿ��� ��찡 �ƴϸ� "�б� ����" ���� �ο�
      �� NMS, ����͸� �� �������� SNMP ���񽺸� ����ϴ� ��� SNMP Manager �� Agent �� ���� Community String �� �����Ǿ� �־�� ���� ����
  2. SNMP ���� �����
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 ���ʿ��� SMTP ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
s

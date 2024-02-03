# ������ ���� Ȯ�� �� ��û
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# ȯ�� ����
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir -ItemType Directory -Force
New-Item -Path $resultDir -ItemType Directory -Force

# ���� ��å �� �ý��� ���� ����
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force
cd $rawDir
[System.IO.File]::WriteAllText("$rawDir\install_path.txt", (Get-Location).Path)
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS ���� ����
if (Test-Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config) {
    Get-Content $env:WinDir\System32\Inetsrv\Config\applicationHost.Config | Out-File "$rawDir\iis_setting.txt"
    Get-Content "$rawDir\iis_setting.txt" | Select-String "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
    # �߰� ������ �ʿ��� ��� ���⿡ �ۼ�
}

# SNMP �� SMTP ���� ���� ����
$snmpStatus = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers
if ($snmpStatus) {
    "SNMP ������ ��ȣ�մϴ�. Ư�� ȣ��Ʈ�κ��͸� SNMP ��Ŷ�� �޾Ƶ��Դϴ�." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
} else {
    "SNMP ������ ����մϴ�. ��� ȣ��Ʈ�κ��� SNMP ��Ŷ�� �޾Ƶ��� �� �ֽ��ϴ�. ��ġ�� �ʿ��մϴ�." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
}

$smtpService = Get-Service smtp -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    "SMTP ���񽺰� ���� ���Դϴ�. ���ʿ��� ���, ���񽺸� ��Ȱ��ȭ�ϴ� ���� ����ϼ���." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
} else {
    "SMTP ���񽺰� ���� ������ �ʽ��ϴ�." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
}

# ��� �˸�
Write-Host "����� $resultDir\W-Window-$computerName-rawdata.txt�� ����߽��ϴ�."
Write-Host "��ũ��Ʈ ������ �Ϸ�Ǿ����ϴ�."

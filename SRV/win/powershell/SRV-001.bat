# 관리자 권한?�로 ?�행 ?�청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# 콘솔 ?�경 ?�정
$OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "------------------------------------------Setting---------------------------------------" -ForegroundColor Green

# ?�렉?�리 ?�정
$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"

Remove-Item $rawPath -Recurse -ErrorAction SilentlyContinue
Remove-Item $resultPath -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawPath, $resultPath -Force

# ?�스???�보 �?보안 ?�책 ?�보?�기
secedit /EXPORT /CFG "$rawPath\Local_Security_Policy.txt"
New-Item -ItemType File -Path "$rawPath\compare.txt" -Force
[System.IO.File]::WriteAllText("$rawPath\install_path.txt", (Get-Location).Path)

# ?�스???�보
systeminfo | Out-File -FilePath "$rawPath\systeminfo.txt"

# IIS ?�정
$applicationHostConfig = Get-Content $env:windir\System32\inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawPath\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath|bindingInformation" | Out-File -FilePath "$rawPath\iis_path.txt"

# MetaBase.xml ?�보 (IIS 6 ?�환??모드?�서 ?�용??경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawPath\iis_setting.txt" -Append
}

Write-Host "------------------------------------------End-------------------------------------------" -ForegroundColor Green

# SNMP �?SMTP ?�비???�정 ?��? (SRV-001, SRV-004)
# SNMP �?SMTP ?�정 ?��????�요??로직??추�??�세??

# ê´€ë¦¬ì ê¶Œí•œ?¼ë¡œ ?¤í–‰ ?”ì²­
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# ì½˜ì†” ?˜ê²½ ?¤ì •
$OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "------------------------------------------Setting---------------------------------------" -ForegroundColor Green

# ?”ë ‰?°ë¦¬ ?¤ì •
$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"

Remove-Item $rawPath -Recurse -ErrorAction SilentlyContinue
Remove-Item $resultPath -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawPath, $resultPath -Force

# ?œìŠ¤???•ë³´ ë°?ë³´ì•ˆ ?•ì±… ?´ë³´?´ê¸°
secedit /EXPORT /CFG "$rawPath\Local_Security_Policy.txt"
New-Item -ItemType File -Path "$rawPath\compare.txt" -Force
[System.IO.File]::WriteAllText("$rawPath\install_path.txt", (Get-Location).Path)

# ?œìŠ¤???•ë³´
systeminfo | Out-File -FilePath "$rawPath\systeminfo.txt"

# IIS ?¤ì •
$applicationHostConfig = Get-Content $env:windir\System32\inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawPath\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath|bindingInformation" | Out-File -FilePath "$rawPath\iis_path.txt"

# MetaBase.xml ?•ë³´ (IIS 6 ?¸í™˜??ëª¨ë“œ?ì„œ ?¬ìš©??ê²½ìš°)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawPath\iis_setting.txt" -Append
}

Write-Host "------------------------------------------End-------------------------------------------" -ForegroundColor Green

# SNMP ë°?SMTP ?œë¹„???¤ì • ?ê? (SRV-001, SRV-004)
# SNMP ë°?SMTP ?¤ì • ?ê????„ìš”??ë¡œì§??ì¶”ê??˜ì„¸??

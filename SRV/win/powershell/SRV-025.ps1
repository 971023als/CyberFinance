# 결과 파일 초기화
$TMP1 = "$(Get-Location)\$(($MyInvocation.MyCommand.Name).Replace('.ps1', '.log'))"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

@"
[양호]: hosts.equiv 및 .rhosts 파일이 없거나, 안전하게 구성된 경우
[취약]: hosts.equiv 또는 .rhosts 파일에 취약한 설정이 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# hosts.equiv 및 .rhosts 파일의 존재 및 내용을 확인합니다.
$hostsEquiv = "/etc/hosts.equiv"
$userDirectories = Get-ChildItem -Path C:\Users -Directory | Select-Object -ExpandProperty FullName
$checkFiles = @($hostsEquiv) + $userDirectories | ForEach-Object { $_ + "\.rhosts" }

foreach ($file in $checkFiles) {
    if (Test-Path $file) {
        $fileOwner = (Get-Acl $file).Owner
        if ($fileOwner -eq "BUILTIN\Administrators" -or $fileOwner -eq $env:COMPUTERNAME + "\Administrator") {
            $filePermission = (Get-Acl $file).AccessToString
            if ($filePermission -match "\+"){
                WARN "$file 파일에 '+' 설정이 있습니다."
            }
            else {
                OK "$file 파일이 안전하게 구성되어 있습니다."
            }
        }
        else {
            WARN "$file 파일의 소유자(owner)가 Administrator가 아닙니다."
        }
    }
}

# r 계열 서비스 사용 확인 (Windows 환경에 대한 직접적인 대응은 PowerShell에서 제한적입니다.)
$services = "rsh", "rexec", "rlogin"
foreach ($service in $services) {
    $serviceStatus = Get-Service $service -ErrorAction SilentlyContinue
    if ($null -ne $serviceStatus -and $serviceStatus.Status -eq 'Running') {
        WARN "$service 서비스가 실행 중입니다."
    }
}

# 최종 결과 출력
Get-Content $TMP1 | Write-Host

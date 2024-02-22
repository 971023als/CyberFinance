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

CODE "[SRV-040] 웹 서비스 디렉터리 리스팅 방지"

BAR

@"
[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우
[취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# IIS 웹 사이트의 디렉터리 브라우징 설정을 점검합니다.
Import-Module WebAdministration

$websites = Get-Website
foreach ($website in $websites) {
    $directoryBrowsing = Get-WebConfigurationProperty -pspath "IIS:\Sites\$($website.name)" -filter "system.webServer/directoryBrowse" -name "enabled"
    if ($directoryBrowsing.Value -eq $true) {
        WARN "웹 사이트 '$($website.name)'에서 디렉터리 리스팅이 활성화되어 있습니다."
    } else {
        OK "웹 사이트 '$($website.name)'에서 디렉터리 리스팅이 비활성화되어 있습니다."
    }
}

BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

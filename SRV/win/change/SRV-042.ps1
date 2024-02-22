# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-040_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "$message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

Write-OK "[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우"

Write-BAR

# IIS 웹 사이트의 디렉터리 브라우징 설정을 점검합니다.
Import-Module WebAdministration

$websites = Get-Website
foreach ($website in $websites) {
    $directoryBrowsing = Get-WebConfigurationProperty -pspath "IIS:\Sites\$($website.name)" -filter "system.webServer/directoryBrowse" -name "enabled"
    if ($directoryBrowsing.Value -eq $true) {
        Write-WARN "웹 사이트 '$($website.name)'에서 디렉터리 리스팅이 활성화되어 있습니다."
    } else {
        Write-OK "웹 사이트 '$($website.name)'에서 디렉터리 리스팅이 비활성화되어 있습니다."
    }
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

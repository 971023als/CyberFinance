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

@"
[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우
[취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf", "userdir.conf")
foreach ($file in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Path / -Filter $file -Recurse -ErrorAction SilentlyContinue
    foreach ($confFile in $findWebConfFiles) {
        if ($confFile.Name -eq "userdir.conf") {
            $content = Get-Content $confFile.FullName
            $userdirConfDisabledCount = ($content | Where-Object { $_ -match "userdir" -and $_ -match "disabled"}).Count
            if ($userdirConfDisabledCount -eq 0) {
                $userdirConfIndexesCount = ($content | Where-Object { $_ -match "Options" -and $_ -notmatch "\-indexes" -and $_ -match "indexes"}).Count
                if ($userdirConfIndexesCount -gt 0) {
                    Write-WARN "Apache 설정 파일에 디렉터리 검색 기능을 사용하도록 설정되어 있습니다: $($confFile.FullName)"
                    return
                }
            }
        } else {
            $content = Get-Content $confFile.FullName
            $webConfFileIndexesCount = ($content | Where-Object { $_ -match "Options" -and $_ -notmatch "\-indexes" -and $_ -match "indexes"}).Count
            if ($webConfFileIndexesCount -gt 0) {
                Write-WARN "Apache 설정 파일에 디렉터리 검색 기능을 사용하도록 설정되어 있습니다: $($confFile.FullName)"
                return
            }
        }
    }
}
Write-OK "※ 양호(Good)"

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

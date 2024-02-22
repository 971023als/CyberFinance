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

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf", "userdir.conf")
$warnings = $false

foreach ($file in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Path / -Filter $file -Recurse -ErrorAction SilentlyContinue
    foreach ($confFile in $findWebConfFiles) {
        $content = Get-Content $confFile.FullName
        $indexesOptionCount = ($content | Where-Object { $_ -match "Options" -and $_ -match "Indexes"}).Count
        if ($indexesOptionCount -gt 0) {
            WARN "Apache 설정 파일에 디렉터리 검색 기능을 사용하도록 설정되어 있습니다: $($confFile.FullName)"
            $warnings = $true
            break
        }
    }
    if ($warnings) { break }
}

if (-not $warnings) {
    OK "※ 양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

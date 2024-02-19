# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-045_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "$message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 웹 서비스 프로세스가 root 권한으로 실행되지 않는 경우
[취약]: 웹 서비스 프로세스가 root 권한으로 실행되는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf")
$found = $false

foreach ($webConfFile in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Recurse -Path / -Filter $webConfFile -ErrorAction SilentlyContinue
    foreach ($file in $findWebConfFiles) {
        $content = Get-Content -Path $file.FullName
        $groupRootCounts = ($content | Where-Object { $_ -match '^\s*Group.*root' }).Count
        if ($groupRootCounts -gt 0) {
            Write-WARN "Apache 데몬이 root 권한으로 구동되도록 설정되어 있습니다."
            $found = $true
            break
        }
    }
    if ($found) { break }
}

if (-not $found) {
    Write-OK "※ 양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

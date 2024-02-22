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

# Linux 환경의 파일 시스템 접근 경로를 Windows 환경에 적합하게 수정해야 함
# 예시 경로: C:\apache\conf\
$webConfFiles = @("httpd.conf", "apache2.conf") # .htaccess 파일은 Apache 구성의 일부이지만, 일반적으로 DocumentRoot 내에 위치합니다.
$apacheConfigPath = "C:\apache\conf\" # Apache 구성 파일 경로를 예시로 사용합니다. 실제 경로에 따라 조정해야 합니다.

$found = $false

foreach ($webConfFile in $webConfFiles) {
    $filePath = Join-Path -Path $apacheConfigPath -ChildPath $webConfFile
    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath
        $groupRootCounts = ($content | Where-Object { $_ -match '^\s*Group.*root' }).Count
        if ($groupRootCounts -gt 0) {
            Write-WARN "Apache 데몬이 root 권한으로 구동되도록 설정되어 있습니다: $filePath"
            $found = $true
            break
        }
    }
}

if (-not $found) {
    Write-OK "※ 양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

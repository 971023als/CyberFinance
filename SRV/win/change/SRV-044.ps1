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

CODE "[SRV-044] 웹 서비스에서 파일 업로드 및 다운로드 용량이 제한"

BAR

@"
[양호]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 적절하게 제한된 경우
[취약]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 제한되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf", "userdir.conf")
$fileExistsCount = 0

foreach ($webConfFile in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Recurse -Path / -Filter $webConfFile -ErrorAction SilentlyContinue
    if ($findWebConfFiles) {
        $fileExistsCount++
        foreach ($file in $findWebConfFiles) {
            $content = Get-Content -Path $file.FullName
            $limitRequestBodyLines = $content | Where-Object { $_ -match 'LimitRequestBody' }
            if (-not $limitRequestBodyLines) {
                Write-WARN "Apache 설정 파일에 파일 업로드 및 다운로드를 제한하도록 설정하지 않았습니다."
                return
            }
        }
    }
}

if ($fileExistsCount -eq 0) {
    Write-WARN "Apache 설정 파일이 발견되지 않았습니다."
} else {
    Write-OK "※ 양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

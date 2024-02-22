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

CODE "[SRV-043] 웹 서비스 디렉터리 리스팅 방지"

BAR

@"
[양호]: 웹 서비스 경로에 불필요한 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로에 불필요한 파일이 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf")
$fileExistsCount = 0

foreach ($webConfFile in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Recurse -Path / -Filter $webConfFile -ErrorAction SilentlyContinue
    if ($findWebConfFiles) {
        $fileExistsCount++
        foreach ($file in $findWebConfFiles) {
            $content = Get-Content -Path $file.FullName
            $documentRootLines = $content | Where-Object { $_ -match 'DocumentRoot' -and $_ -match '/' }
            if ($documentRootLines) {
                foreach ($line in $documentRootLines) {
                    $documentRoot = $line -replace '.*DocumentRoot\s+"?(.*?)"?\s*$', '$1'
                    if ($documentRoot -match '/usr/local/apache/htdocs|/usr/local/apache2/htdocs|/var/www/html') {
                        Write-WARN "Apache DocumentRoot를 기본 디렉터리로 설정했습니다."
                        return
                    }
                }
            } else {
                Write-WARN "Apache DocumentRoot를 설정하지 않았습니다."
                return
            }
        }
    }
}

$psApacheCount = (Get-Process -Name 'httpd', 'apache2' -ErrorAction SilentlyContinue).Count
if ($psApacheCount -gt 0 -and $fileExistsCount -eq 0) {
    Write-WARN "Apache 서비스를 사용하고, DocumentRoot를 설정하는 파일이 없습니다."
} else {
    Write-OK "양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

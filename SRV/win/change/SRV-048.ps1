# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-048_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-Result {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 불필요한 웹 서비스가 실행되지 않고 있는 경우
[취약]: 불필요한 웹 서비스가 실행되고 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 웹 서비스 설정 파일 목록
$webconfFiles = @(".htaccess", "httpd.conf", "apache2.conf")
$serverRootDirectories = @()

# 설정 파일 검색 및 ServerRoot 디렉토리 찾기
foreach ($file in $webconfFiles) {
    $findWebconfFiles = Get-ChildItem -Path C:\ -Filter $file -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $findWebconfFiles) {
        $content = Get-Content $f.FullName
        foreach ($line in $content) {
            if ($line -match "ServerRoot") {
                $serverRootDirectories += $line -replace '.*ServerRoot\s+"', '' -replace '"', ''
            }
        }
    }
}

# ServerRoot 디렉토리 내 manual 디렉토리 검사 및 제거
foreach ($dir in $serverRootDirectories) {
    $manualDirPath = "$dir\manual"
    $manualDirExists = Test-Path -Path $manualDirPath -ErrorAction SilentlyContinue
    if ($manualDirExists) {
        Remove-Item -Path $manualDirPath -Recurse -Force
        Write-Result "OK: Apache 홈 디렉터리에서 불필요한 'manual' 디렉토리를 제거하여 양호한 상태를 확보했습니다."
    } else {
        Write-Result "OK: Apache 홈 디렉터리 내 불필요한 'manual' 디렉토리가 존재하지 않습니다. 결과 : 양호(Good)"
    }
}

# 모든 ServerRoot 디렉토리가 처리되었을 때만 양호한 결과를 기록
if (!$serverRootDirectories) {
    Write-Result "WARN: Apache ServerRoot 디렉토리를 찾을 수 없습니다. 웹 서버 구성을 확인하세요."
}

Get-Content $TMP1 | Write-Output

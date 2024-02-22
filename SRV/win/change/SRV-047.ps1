# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-047_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# IIS 웹 사이트의 루트 디렉토리 경로를 설정합니다.
# 이 예에서는 C:\inetpub\wwwroot를 사용하지만, 실제 경로에 맞게 조정해야 합니다.
$webRootPath = "C:\inetpub\wwwroot"

# 웹 서비스 경로 내 심볼릭 링크 파일 검사
$symLinks = Get-ChildItem -Path $webRootPath -Recurse | Where-Object { $_.Attributes -match 'ReparsePoint' }

if ($symLinks.Count -eq 0) {
    Write-OK "웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않습니다: 양호"
} else {
    foreach ($link in $symLinks) {
        Write-WARN "불필요한 심볼릭 링크 파일이 존재합니다: $($link.FullName)"
    }
}

Get-Content $TMP1 | Write-Output

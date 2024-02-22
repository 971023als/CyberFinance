# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-037_log.txt"
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

Write-OK "[양호]: FTP 서비스가 비활성화 되어 있는 경우"

Write-BAR

# FTP 서비스가 실행 중인지 확인합니다.
$ftpService = Get-Service -Name 'FTPSVC*' -ErrorAction SilentlyContinue

if ($ftpService -and $ftpService.Status -eq 'Running') {
    Write-WARN "FTP 서비스가 실행 중입니다."
} else {
    Write-OK "FTP 서비스가 비활성화 되어 있습니다."
}

Write-BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

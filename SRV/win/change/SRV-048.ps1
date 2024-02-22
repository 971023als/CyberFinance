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

# IIS에서 실행 중인 모든 웹 사이트 나열
$websites = Get-Website

# IIS에서 실행 중인 모든 웹 애플리케이션 나열
$webApplications = Get-WebApplication

# 웹 사이트 및 웹 애플리케이션 검토
if ($websites.Count -eq 0 -and $webApplications.Count -eq 0) {
    Write-Result "OK: 실행 중인 웹 서비스가 없습니다. 결과: 양호(Good)"
} else {
    Write-Result "WARN: 다음 웹 서비스가 실행 중입니다. 필요에 따라 검토 및 조치가 필요할 수 있습니다."
    foreach ($site in $websites) {
        Write-Result "웹 사이트: $($site.Name)"
    }
    foreach ($app in $webApplications) {
        Write-Result "웹 애플리케이션: $($app.ApplicationPool)"
    }
}

Get-Content $TMP1 | Write-Output

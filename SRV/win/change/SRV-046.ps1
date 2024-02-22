# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-046_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-INFO {
    Param ([string]$message)
    "INFO: $message" | Out-File -FilePath $TMP1 -Append
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
[양호]: 웹 서비스의 경로 설정이 안전하게 구성된 경우
[취약]: 웹 서비스의 경로 설정이 취약하게 구성된 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# IIS 설정 확인
$IIS_CONFIG_FILE = "$env:windir\system32\inetsrv\config\applicationHost.config"
If (Test-Path $IIS_CONFIG_FILE) {
    $iisConfig = Get-Content $IIS_CONFIG_FILE
    If ($iisConfig -match "<directoryBrowse enabled=\"false\"") {
        Write-OK "IIS 설정에서 디렉토리 브라우징 비활성화 확인됨: $IIS_CONFIG_FILE"
    } Else {
        Write-WARN "IIS 설정에서 디렉토리 브라우징이 활성화되어 있음: $IIS_CONFIG_FILE"
    }
} Else {
    Write-INFO "IIS 설정 파일이 존재하지 않습니다: $IIS_CONFIG_FILE"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

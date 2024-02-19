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

# Apache 설정 확인
$APACHE_CONFIG_FILE = "/etc/apache2/apache2.conf"
If (Test-Path $APACHE_CONFIG_FILE) {
    $apacheConfig = Get-Content $APACHE_CONFIG_FILE
    If ($apacheConfig -match "^\s*<Directory" -and $apacheConfig -match "Options -Indexes") {
        Write-OK "Apache 설정에서 적절한 경로 설정이 확인됨: $APACHE_CONFIG_FILE"
    } Else {
        Write-WARN "Apache 설정에서 취약한 경로 설정이 확인됨: $APACHE_CONFIG_FILE"
    }
} Else {
    Write-INFO "Apache 설정 파일이 존재하지 않습니다: $APACHE_CONFIG_FILE"
}

# Nginx 설정 확인
$NGINX_CONFIG_FILE = "/etc/nginx/nginx.conf"
If (Test-Path $NGINX_CONFIG_FILE) {
    $nginxConfig = Get-Content $NGINX_CONFIG_FILE
    If ($nginxConfig -match "^\s*location") {
        Write-OK "Nginx 설정에서 적절한 경로 설정이 확인됨: $NGINX_CONFIG_FILE"
    } Else {
        Write-WARN "Nginx 설정에서 취약한 경로 설정이 확인됨: $NGINX_CONFIG_FILE"
    }
} Else {
    Write-INFO "Nginx 설정 파일이 존재하지 않습니다: $NGINX_CONFIG_FILE"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

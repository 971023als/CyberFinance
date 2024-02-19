# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-055_log.txt"
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
[양호]: 웹 서비스 설정 파일이 외부에서 접근 불가능한 경우
[취약]: 웹 서비스 설정 파일이 외부에서 접근 가능한 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 웹 서비스 설정 파일의 예시 경로
$APACHE_CONFIG = "C:\path\to\apache2\apache2.conf" # 예시 경로, 실제 경로로 변경 필요
$NGINX_CONFIG = "C:\path\to\nginx\nginx.conf" # 예시 경로, 실제 경로로 변경 필요

# Apache 설정 파일의 접근 권한 확인
if (Test-Path $APACHE_CONFIG) {
    $filePermission = (Get-Acl $APACHE_CONFIG).AccessToString
    if ($filePermission -like "*-rw-------*") {
        Write-Result "OK: Apache 설정 파일($APACHE_CONFIG)이 외부 접근으로부터 보호됩니다."
    } else {
        Write-Result "WARN: Apache 설정 파일($APACHE_CONFIG)의 접근 권한이 취약합니다."
    }
} else {
    Write-Result "INFO: Apache 설정 파일($APACHE_CONFIG)이 존재하지 않습니다."
}

# Nginx 설정 파일의 접근 권한 확인
if (Test-Path $NGINX_CONFIG) {
    $filePermission = (Get-Acl $NGINX_CONFIG).AccessToString
    if ($filePermission -like "*-rw-------*") {
        Write-Result "OK: Nginx 설정 파일($NGINX_CONFIG)이 외부 접근으로부터 보호됩니다."
    } else {
        Write-Result "WARN: Nginx 설정 파일($NGINX_CONFIG)의 접근 권한이 취약합니다."
    }
} else {
    Write-Result "INFO: Nginx 설정 파일($NGINX_CONFIG)이 존재하지 않습니다."
}

Get-Content $TMP1 | Write-Output

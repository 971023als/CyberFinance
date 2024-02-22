# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-057_log.txt"
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
[양호]: 웹 서비스 경로 내 파일의 접근 권한이 적절하게 설정된 경우
[취약]: 웹 서비스 경로 내 파일의 접근 권한이 적절하게 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 웹 서비스 경로 설정
$WEB_SERVICE_PATH = "C:\path\to\web\service" # 실제 경로에 맞게 조정하세요.

# 웹 서비스 경로 내 파일 접근 권한 확인
$incorrectPermissions = Get-ChildItem -Path $WEB_SERVICE_PATH -Recurse -File | Where-Object {
    ($_.Mode -notmatch "d-----") -and ($_.Mode -notmatch "-----") # PowerShell에서는 파일 권한을 직접적으로 숫자로 표현하지 않으므로, Mode 속성을 검사합니다.
}

if ($incorrectPermissions) {
    Write-Result "WARN: 웹 서비스 경로 내에 부적절한 파일 권한이 있습니다."
    $incorrectPermissions | ForEach-Object { Write-Result $_.FullName }
} else {
    Write-Result "OK: 웹 서비스 경로 내의 모든 파일의 권한이 적절하게 설정되어 있습니다."
}

Get-Content $TMP1 | Write-Output
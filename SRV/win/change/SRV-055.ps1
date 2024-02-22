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

# 웹 서비스 설정 파일의 경로 설정
# 여기서는 IIS 웹 사이트의 루트 디렉토리를 예로 들며, 실제 환경에 맞게 경로를 조정해야 합니다.
$WebConfigPaths = Get-ChildItem -Path C:\inetpub\wwwroot\ -Filter web.config -Recurse

foreach ($WebConfigPath in $WebConfigPaths) {
    $filePermission = (Get-Acl $WebConfigPath.FullName).AccessToString
    # 접근 권한이 적절히 제한되어 있는지 확인
    # 예시: 웹 서버와 관리자만 읽기 권한을 가지며, 그 외에는 접근 불가능해야 함
    if ($filePermission -notlike "*Everyone Allow*" -and $filePermission -like "*Read*") {
        Write-Result "OK: 웹 서비스 설정 파일($($WebConfigPath.FullName))이 외부 접근으로부터 보호됩니다."
    } else {
        Write-Result "WARN: 웹 서비스 설정 파일($($WebConfigPath.FullName))의 접근 권한이 취약합니다."
    }
}

if ($WebConfigPaths.Count -eq 0) {
    Write-Result "INFO: web.config 파일이 검색되지 않았습니다."
}

Get-Content $TMP1 | Write-Output

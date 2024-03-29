# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-035] 취약한 서비스 활성화" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 취약한 서비스가 비활성화된 경우
[취약]: 취약한 서비스가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 취약한 서비스 목록
$services = @('Telnet', 'RemoteRegistry')

# 서비스 상태 확인
foreach ($service in $services) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus -and $serviceStatus.Status -eq 'Running') {
        "WARN: 취약한 서비스 '$service'가 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: 서비스 '$service'가 비활성화되어 있거나, 시스템에 설치되지 않았습니다." | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Host

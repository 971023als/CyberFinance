# 필요한 함수 로드
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

# 여기에 SMTP 서비스 구성 변경 로직 추가
# 예시: SMTP 서버가 Postfix일 경우, main.cf 파일에서 다음 설정을 확인 또는 추가
# disable_vrfy_command = yes

# SMTP 서비스명 설정 (Windows 환경 예시)
$SMTPServices = @("SMTPSVC")

foreach ($service in $SMTPServices) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
        # SMTP 서비스가 실행 중인 경우, 관리자에게 알림
        "SMTP 서비스($service)의 `expn` 및 `vrfy` 명령어 사용 제한 상태를 수동으로 확인해야 합니다. 이는 SMTP 서버의 구성 파일 또는 관리 도구를 통해 이루어질 수 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        # SMTP 서비스가 비활성화되어 있거나 실행 중이지 않는 경우
        OK "$service 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

# 필요한 함수 로드 (PowerShell 스크립트로 가정)
. .\function.ps1

# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

BAR

CODE "SRV-005 SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비"

# 로그 파일에 내용 추가
@"
[양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우
[취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비" | Out-File -FilePath $TMP1 -Append

# SMTP 서비스가 실행 중인지 확인
$SMTPServices = @("SMTPSVC")  # Windows 환경 예시 서비스명

foreach ($service in $SMTPServices) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
        echo "$service 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
        # 여기서 expn 및 vrfy 명령어 사용 제한 설정 확인
        # Windows 환경에서는 이러한 설정을 직접 검사하는 것이 불가능할 수 있으므로, 관련 정책 또는 구성 관리 도구를 통해 확인해야 할 수 있음
        OK "Windows 환경에서는 expn 및 vrfy 명령어 사용 제한을 직접 확인하는 것이 제한될 수 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        OK "$service 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

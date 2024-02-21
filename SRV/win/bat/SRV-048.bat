# PowerShell 스크립트 예시: 불필요한 웹 서비스 실행 여부 확인 및 중지

# IIS 웹 서비스 및 기타 불필요한 웹 서비스의 이름 목록
$unnecessaryServices = @("W3SVC", "AnotherWebService")

# 각 서비스의 실행 상태 확인 및 중지
foreach ($service in $unnecessaryServices) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($null -ne $serviceStatus) {
        if ($serviceStatus.Status -eq "Running") {
            Write-Output "불필요한 서비스가 실행 중입니다: $service"
            # 서비스를 중지하려면 다음 명령어의 주석을 해제하세요.
            # Stop-Service -Name $service
            # Write-Output "$service 서비스가 중지되었습니다."
        } else {
            Write-Output "서비스가 실행 중이지 않습니다: $service"
        }
    } else {
        Write-Output "서비스가 설치되어 있지 않습니다: $service"
    }
}

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-048.log"
"불필요한 웹 서비스 실행 여부 점검 완료" | Out-File -FilePath $TMP1

# IIS SMTP 서비스 실행 상태 확인
$smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue

if ($null -ne $smtpService) {
    if ($smtpService.Status -eq 'Running') {
        Write-Host "SMTP 서비스가 실행 중입니다."
        # SMTP 서비스 구성 파일이나 IIS 관리 콘솔을 통해 추가적인 설정 점검 필요
    } else {
        Write-Host "SMTP 서비스가 설치되어 있으나 실행 중이지 않습니다."
    }
} else {
    Write-Host "SMTP 서비스가 설치되어 있지 않습니다."
}

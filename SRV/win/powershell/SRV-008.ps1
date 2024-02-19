# 임시 로그 파일 생성
$TMP1 = "$([IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1
BAR

CODE "SRV-008 SMTP 서비스의 DoS 방지 기능 미설정"

@"
[양호]: SMTP 서비스에 DoS 방지 설정이 적용된 경우
[취약]: SMTP 서비스에 DoS 방지 설정이 적용되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR
"[SRV-008] SMTP 서비스의 DoS 방지 기능 미설정" | Out-File -FilePath $TMP1 -Append

# Sendmail과 Postfix는 일반적으로 Windows에서 사용되지 않음
# Windows 환경에서는 SMTP 관련 설정을 IIS에서 관리할 수 있음
echo "Windows 환경에서 Sendmail과 Postfix 설정을 직접 점검하는 것은 일반적이지 않습니다." | Out-File -FilePath $TMP1 -Append
echo "대신, IIS 관리 콘솔 또는 PowerShell을 통해 SMTP 서비스 관련 설정을 점검할 수 있습니다." | Out-File -FilePath $TMP1 -Append
echo "SMTP 서비스의 DoS 방지 기능 설정 점검은 서버 관리자 또는 네트워크 관리자에게 문의하세요." | Out-File -FilePath $TMP1 -Append

# 예시: IIS SMTP 서비스 상태 확인
$IISStatus = Get-Service -Name 'IISADMIN' -ErrorAction SilentlyContinue
if ($IISStatus -and $IISStatus.Status -eq 'Running') {
    "IIS 서비스가 실행 중입니다. IIS 관리 콘솔을 통해 SMTP 설정을 점검하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "IIS 서비스가 실행 중이지 않습니다. SMTP 서비스 관련 설정이 적용되지 않았을 수 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

Get-Content $TMP1
Write-Host `n

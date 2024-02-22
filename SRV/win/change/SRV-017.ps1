# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-009] SMTP 서비스 스팸 메일 릴레이 제한 미설정" | Out-File -FilePath $TMP1 -Append

@"
[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우
[취약]: SMTP 서비스를 사용하거나 릴레이 제한이 설정이 없는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMTP 포트 상태 확인
$smtpPort = 25
$smtpPortStatus = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $smtpPort }

if ($smtpPortStatus) {
    "SMTP 포트($smtpPort)가 열려 있습니다. 릴레이 제한 설정을 확인하세요." | Out-File -FilePath $TMP1 -Append
    
    # IIS에서 SMTP 릴레이 제한 설정을 확인
    # IIS 관리 콘솔을 사용하거나 PowerShell cmdlet을 사용해 설정 확인
    # 예시: IIS 관리 콘솔을 사용하는 경우, 관리자는 IIS 관리자를 통해 SMTP 서비스 속성에서 릴레이 제한을 확인할 수 있습니다.
    # PowerShell을 사용하는 경우, 아래의 cmdlet 예시를 참고하세요. (실제 작동하는 cmdlet은 아님, 예시 목적으로 제공됨)
    # Get-IisSmtpRelayRestrictions -ServerName "localhost"

    # 릴레이 제한이 적절히 설정되어 있는지 확인
    # 이 부분은 실제 환경에서 구현해야 할 로직입니다. 예시로는 제공되지 않음.
} else {
    "SMTP 포트($smtpPort)가 닫혀 있습니다. 서비스가 비활성화되었거나 릴레이 제한이 설정될 수 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host `n

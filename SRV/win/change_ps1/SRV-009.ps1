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

# SMTP 포트 상태 확인 및 IIS SMTP 릴레이 설정 조정
$smtpPort = 25
$smtpPortStatus = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $smtpPort }

if ($smtpPortStatus) {
    "SMTP 포트($smtpPort)가 열려 있습니다. 릴레이 제한 설정을 확인하고 조정합니다." | Out-File -FilePath $TMP1 -Append
    
    # IIS 관리 도구를 사용하여 릴레이 설정을 조정하거나, PowerShell을 사용해 설정 확인
    # 예: IIS SMTP 릴레이 제한 설정 확인
    $relayRestrictions = Get-SmtpRelayRestrictions -Server "localhost"
    if ($relayRestrictions -eq "Only the list below" -and $relayRestrictions.AllowList -ne $null) {
        "SMTP 릴레이 제한이 적절하게 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "SMTP 릴레이 제한이 적절하게 설정되지 않았습니다. 설정을 조정해야 합니다." | Out-File -FilePath $TMP1 -Append
        # 예시: 릴레이 제한 설정 조정
        # Set-SmtpRelayRestrictions -Server "localhost" -Restriction "Only the list below" -AllowList @("특정 허용 IP")
    }
} else {
    "SMTP 포트($smtpPort)가 닫혀 있습니다. 서비스가 비활성화되었거나 릴레이 제한이 설정될 수 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

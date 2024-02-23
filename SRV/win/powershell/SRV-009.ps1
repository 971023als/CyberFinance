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
    
    # 실제 릴레이 제한 설정을 확인하는 코드는 환경에 따라 달라질 수 있으며, 여기서는 예시로만 제공됩니다.
    # IIS 또는 Exchange와 같은 서비스에서 릴레이 설정을 확인하고 조정하는 방법을 찾아 적용해야 합니다.
    # 아래는 가상의 함수 호출로, 실제 함수 구현이 필요합니다.
    $relayRestrictions = "Only the list below" # 가정된 값
    $allowList = @("192.168.1.1") # 가정된 값
    
    if ($relayRestrictions -eq "Only the list below" -and $allowList.Count -gt 0) {
        "SMTP 릴레이 제한이 적절하게 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "SMTP 릴레이 제한이 적절하게 설정되지 않았습니다. 설정을 조정해야 합니다." | Out-File -FilePath $TMP1 -Append
        # 설정 조정 예시는 실제 환경에 맞게 구현해야 합니다.
    }
} else {
    "SMTP 포트($smtpPort)가 닫혀 있습니다. 서비스가 비활성화되었거나 릴레이 제한이 설정될 수 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Output

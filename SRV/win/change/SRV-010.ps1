# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File $TMP1

# 메시지 구분자 함수
Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우
[취약]: SMTP 서비스의 메일 queue 처리 권한이 업무와 무관한 일반 사용자에게도 부여되도록 설정된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMTP 서비스의 메일 queue 처리 권한 설정 점검 및 조정 (예시)
# PowerShell을 사용한 Exchange 서버의 메일 queue 권한 관리 예시
$MailQueueAdmins = @("업무 관리자 계정1", "업무 관리자 계정2") # 실제 업무 관리자 계정으로 대체

# 메일 queue 처리 권한 부여
foreach ($admin in $MailQueueAdmins) {
    # Exchange PowerShell cmdlet을 사용해 권한 부여 (가상의 cmdlet 사용 예시)
    # Set-MailQueuePermissions -User $admin -Permissions "Manage"
    "메일 queue 처리 권한이 [$admin]에게 부여되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 일반 사용자의 메일 queue 처리 권한 제거 (실제 cmdlet과 다를 수 있음)
$GeneralUsers = @("일반 사용자 계정1", "일반 사용자 계정2") # 실제 일반 사용자 계정으로 대체
foreach ($user in $GeneralUsers) {
    # Exchange PowerShell cmdlet을 사용해 권한 제거 (가상의 cmdlet 사용 예시)
    # Remove-MailQueuePermissions -User $user
    "[$user]의 메일 queue 처리 권한이 제거되었습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1
Write-Host `n

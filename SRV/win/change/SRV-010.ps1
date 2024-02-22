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

# SMTP 서비스 설정 파일 점검 (예시: Exchange 서버 설정 점검)
# Windows 환경에서는 SMTP 설정이 파일 시스템에 저장되지 않을 수 있으며, Exchange 관리 콘솔이나 PowerShell cmdlet을 통해 관리됩니다.
# 아래 코드는 Exchange 서비스의 권한 설정을 점검하는 예시입니다.
# 실제 환경에서는 Exchange 서버 또는 IIS의 SMTP 기능에 대한 구체적인 권한 설정 점검 방법을 적용해야 합니다.

"SMTP 서비스의 메일 queue 처리 권한 설정 점검은 환경에 따라 다르므로, 이 부분은 상황에 맞게 구현해야 합니다." | Out-File -FilePath $TMP1 -Append

BAR

Get-Content $TMP1
Write-Host `n

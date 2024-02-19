# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content $TMP1

Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비" | Out-File -FilePath $TMP1 -Append

@"
[양호]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되는 경우
[취약]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# FTP 사용자 제한 설정 확인 (IIS 기반)
# 이 예시에서는 'root' 계정에 해당하는 Windows 환경에서의 관리자 계정 접근 제한을 확인합니다.
# 실제 환경에서는 해당 FTP 서비스의 구성에 따라 확인 방법이 다를 수 있습니다.

$FTPUsersFile = "C:\Windows\System32\inetsrv\config\applicationHost.config" # 예시 경로

if (Test-Path $FTPUsersFile) {
    $content = Get-Content $FTPUsersFile -Raw
    if ($content -match 'system\.applicationHost\/sites\/site\/ftpServer\/security\/authorization') {
        "OK: FTP 서비스에서 관리자 계정의 접근이 제한됩니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: FTP 서비스에서 관리자 계정의 접근이 제한되지 않습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "WARN: FTP 사용자 제한 설정 파일($FTPUsersFile)이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

Get-Content $TMP1
Write-Host `n

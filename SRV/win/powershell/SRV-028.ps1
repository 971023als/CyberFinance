# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-028] 원격 터미널 접속 타임아웃 미설정" | Out-File -FilePath $TMP1 -Append
@"
[양호]: SSH 원격 터미널 접속 타임아웃이 적절하게 설정된 경우
[취약]: SSH 원격 터미널 접속 타임아웃이 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SSH 타임아웃 설정 확인
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'
if (Test-Path $SshdConfigPath) {
    $ConfigContent = Get-Content $SshdConfigPath
    $ClientAliveInterval = $ConfigContent | Where-Object { $_ -match '^ClientAliveInterval' }
    $ClientAliveCountMax = $ConfigContent | Where-Object { $_ -match '^ClientAliveCountMax' }
    if ($ClientAliveInterval -and $ClientAliveCountMax) {
        "OK: SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: SSH 원격 터미널 타임아웃 설정이 미비합니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "INFO: OpenSSH 구성 파일(sshd_config)이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Host

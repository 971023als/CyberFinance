# function.ps1 파일 포함 (예: BAR, OK, WARN 함수 정의 포함)
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-060_log.txt"
# TMP1 파일을 초기화합니다.
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-060] IIS 웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경"

# 결과를 TMP1 파일에 기록
$result = $TMP1
Add-Content -Path $result -Value "[양호]: IIS 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경된 경우"
Add-Content -Path $result -Value "[취약]: IIS 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않은 경우"

BAR

# IIS 웹 서비스의 기본 계정 설정 파일 경로
# 실제 경로로 변경 필요. 예를 들어, web.config 파일 또는 기타 사용자 계정 정보를 저장하는 파일.
$CONFIG_FILE = "C:\inetpub\wwwroot\YourApp\web.config"

# 기본 계정 설정 확인
# 'admin'과 'password'는 예시입니다. 실제 기본 계정 이름과 비밀번호에 따라 조정하세요.
If ((Select-String -Path $CONFIG_FILE -Pattern "username='admin'|password='password'" -Quiet)) {
    WARN "IIS 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않았습니다: $CONFIG_FILE"
} Else {
    OK "IIS 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되었습니다: $CONFIG_FILE"
}

Get-Content -Path $result | Out-Host

Write-Host "`n"

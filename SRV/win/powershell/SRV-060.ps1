# PowerShell 함수 파일 포함 (function.ps1 등으로 가정)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일을 초기화합니다.
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-060] 웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경"

$result = "결과 파일 경로 지정 필요"
# 결과 파일에 내용을 추가합니다.
Add-Content -Path $result -Value "[양호]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경된 경우"
Add-Content -Path $result -Value "[취약]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않은 경우"

BAR

# 웹 서비스의 기본 계정 설정 파일 경로
$CONFIG_FILE = "/etc/web_service/config"

# 기본 계정 설정 확인
If ((Select-String -Path $CONFIG_FILE -Pattern "username=admin|password=password" -Quiet)) {
    WARN "웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않았습니다: $CONFIG_FILE"
} Else {
    OK "웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되었습니다: $CONFIG_FILE"
}

Get-Content -Path $result

Write-Host "`n"

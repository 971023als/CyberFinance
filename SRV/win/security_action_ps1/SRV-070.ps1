# function.ps1 내용 포함 (BAR, OK, WARN 함수 포함)
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-070_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-070] 취약한 패스워드 저장 방식 사용"

$result = $TMP1
Add-Content -Path $result -Value "[양호]: 패스워드 저장에 강력한 해싱 알고리즘을 사용하는 경우"
Add-Content -Path $result -Value "[취약]: 패스워드 저장에 취약한 해싱 알고리즘을 사용하는 경우"

BAR

# 웹 애플리케이션 구성 파일의 경로
$CONFIG_FILE = "C:\inetpub\wwwroot\YourApp\web.config"

# 구성 파일에서 패스워드 저장 설정 확인
# 이 부분은 예시이며, 실제 구현에 따라 확인해야 할 설정이 다를 수 있습니다.
# 예를 들어, 패스워드 해싱 알고리즘 설정이 포함된 구성 섹션을 확인합니다.
$hashAlgorithm = Select-String -Path $CONFIG_FILE -Pattern "passwordFormat=\"Hashed\"" -Quiet
if ($hashAlgorithm) {
    OK "패스워드 저장에 강력한 해싱 알고리즘이 사용 중입니다: $CONFIG_FILE"
} else {
    WARN "패스워드 저장에 취약한 해싱 알고리즘이 사용 중일 수 있습니다: $CONFIG_FILE"
}

Get-Content -Path $result | Out-Host

Write-Host "`n"

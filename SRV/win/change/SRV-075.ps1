# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-075] 유추 가능한 계정 비밀번호 존재"

Add-Content -Path $TMP1 -Value "[양호]: 암호 정책이 강력하게 설정되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 암호 정책이 약하게 설정되어 있는 경우"

BAR

# 비밀번호 정책 검사
# 비밀번호 최소 길이 검사
$minLength = (secedit /export /cfg "$env:TEMP\secpol.cfg" 2>$null; (Get-Content "$env:TEMP\secpol.cfg" | Select-String "MinimumPasswordLength" -SimpleMatch).ToString().Split('=')[1].Trim(); Remove-Item "$env:TEMP\secpol.cfg" -ErrorAction SilentlyContinue)
if ([int]$minLength -lt 8) {
    WARN "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
} else {
    OK "패스워드 최소 길이가 적절하게 설정되어 있습니다."
}

# 추가적인 비밀번호 정책 검사 로직 추가 가능

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

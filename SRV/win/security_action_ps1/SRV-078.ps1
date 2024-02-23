# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-078] 불필요한 Guest 계정 활성화"

Add-Content -Path $TMP1 -Value "[양호]: 불필요한 Guest 계정이 비활성화 되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 불필요한 Guest 계정이 활성화 되어 있는 경우"

BAR

# Guest 계정의 활성화 상태 확인
try {
    $guestAccount = Get-LocalUser -Name "Guest"
    if ($guestAccount.Enabled) {
        WARN "불필요한 Guest 계정이 활성화 되어 있습니다."
    } else {
        OK "불필요한 Guest 계정이 비활성화 되어 있습니다."
    }
} catch {
    OK "Guest 계정이 시스템에 존재하지 않습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

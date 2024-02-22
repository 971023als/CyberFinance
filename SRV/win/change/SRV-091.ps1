function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[U-91] 불필요하게 SUID, SGID bit가 설정된 파일 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정되지 않은 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정된 경우"

BAR

# Windows 환경에서는 SUID/SGID 비트 개념이 직접 적용되지 않습니다.
# 여기서는 Windows 환경에 맞는 권한 검사 메시지를 추가합니다.
Add-Content -Path $global:TMP1 -Value "OK: Windows 환경에서는 SUID/SGID 비트 개념이 직접 적용되지 않습니다. 중요 파일 및 디렉터리의 권한 설정을 정기적으로 검토하는 것이 좋습니다."

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

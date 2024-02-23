# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-073] 관리자 그룹에 불필요한 사용자 존재"

Add-Content -Path $TMP1 -Value "[양호]: 관리자 그룹에 불필요한 사용자가 없는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 관리자 그룹에 불필요한 사용자가 존재하는 경우"

BAR

# 관리자 그룹 이름을 정의합니다 (Windows 환경에서는 주로 'Administrators')
$admin_group = "Administrators"

# 관리자 그룹의 멤버 확인
$admin_members = Get-LocalGroupMember -Group $admin_group | Select-Object -ExpandProperty Name

# 관리자 그룹에 포함되어서는 안 되는 사용자 목록 (실제 환경에 따라 수정 필요)
$unauthorized_users = @("testuser", "anotherUser") # 예시 사용자 목록

# 관리자 그룹 내 불필요한 사용자 확인
$unauthorized_members = $admin_members | Where-Object { $_ -in $unauthorized_users }

if ($unauthorized_members) {
    foreach ($user in $unauthorized_members) {
        WARN "관리자 그룹($admin_group)에 불필요한 사용자가 포함되어 있습니다: $user"
    }
} else {
    OK "관리자 그룹($admin_group)에 불필요한 사용자가 없습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-074] 불필요하거나 관리되지 않는 계정 존재"

Add-Content -Path $TMP1 -Value "[양호]: 불필요하거나 관리되지 않는 계정이 존재하지 않는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 불필요하거나 관리되지 않는 계정이 존재하는 경우"

BAR

# 시스템에 존재하는 모든 사용자 계정을 검사
$unnecessaryAccounts = @('daemon', 'bin', 'sys', 'adm', 'listen', 'nobody', 'nobody4', 'noaccess', 'diag', 'operator', 'gopher', 'games', 'ftp', 'apache', 'httpd', 'www-data', 'mysql', 'mariadb', 'postgres', 'mail', 'postfix', 'news', 'lp', 'uucp', 'nuucp')
$existingAccounts = Get-LocalUser | ForEach-Object { $_.Name }
$foundAccounts = $existingAccounts | Where-Object { $unnecessaryAccounts -contains $_ }

if ($foundAccounts) {
    foreach ($account in $foundAccounts) {
        WARN "불필요한 계정이 존재합니다: $account"
    }
} else {
    OK "불필요한 계정이 존재하지 않습니다."
}

# 관리자 그룹에 불필요한 계정이 등록되어 있는지 검사
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators" | ForEach-Object { $_.Name.Split('\')[-1] }
$foundInAdmin = $adminGroupMembers | Where-Object { $unnecessaryAccounts -contains $_ }

if ($foundInAdmin) {
    foreach ($account in $foundInAdmin) {
        WARN "관리자 그룹(Administrators)에 불필요한 계정이 등록되어 있습니다: $account"
    }
} else {
    OK "관리자 그룹(Administrators)에 불필요한 계정이 등록되어 있지 않습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

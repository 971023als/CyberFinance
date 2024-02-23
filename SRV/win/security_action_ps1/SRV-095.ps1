function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-095] 존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 없는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 있는 경우"

BAR

# 소유자나 그룹이 존재하지 않는 파일 또는 디렉터리 검색
$itemsWithInvalidOwnerOrGroup = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    $acl = Get-Acl $_.FullName -ErrorAction SilentlyContinue
    $owner = $acl.Owner
    $group = $acl.Group
    # 소유자나 그룹이 SID 형태인 경우, 해당 계정이 실제 존재하는지 확인
    $ownerExists = try { [System.Security.Principal.SecurityIdentifier]::new($owner).Translate([System.Security.Principal.NTAccount]) } catch { $null }
    $groupExists = try { [System.Security.Principal.SecurityIdentifier]::new($group).Translate([System.Security.Principal.NTAccount]) } catch { $null }
    -not $ownerExists -or -not $groupExists
}

if ($itemsWithInvalidOwnerOrGroup) {
    foreach ($item in $itemsWithInvalidOwnerOrGroup) {
        Add-Content -Path $global:TMP1 -Value "WARN: 소유자나 그룹이 존재하지 않는 항목이 있습니다: $($item.FullName)"
    }
} else {
    Add-Content -Path $global:TMP1 -Value "OK: 시스템에 소유자나 그룹이 존재하지 않는 파일 또는 디렉터리가 존재하지 않습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

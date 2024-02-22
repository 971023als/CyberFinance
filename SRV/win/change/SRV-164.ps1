# 로컬 컴퓨터에서 모든 그룹을 나열
$groups = Get-LocalGroup

foreach ($group in $groups) {
    # 그룹에 속한 구성원을 가져옴
    $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
    if ($members -eq $null) {
        Write-Warning "구성원이 존재하지 않는 그룹이 존재합니다: $($group.Name)"
    }
}

Write-Host "검사 완료."

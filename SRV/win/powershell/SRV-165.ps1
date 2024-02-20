# 모든 로컬 사용자 계정을 가져옴
$users = Get-LocalUser

foreach ($user in $users) {
    # 사용자 계정이 활성화되어 있는지 확인
    if ($user.Enabled -eq $true) {
        # 사용자가 관리자 그룹의 일원인지 확인
        $isAdministrator = $user | Get-LocalGroupMember | Where-Object { $_.Name -like "*Administrators" } | Measure-Object
        if ($isAdministrator.Count -gt 0) {
            Write-Host "$($user.Name) 계정은 활성화되어 있으며 관리자 권한을 가지고 있습니다."
        } else {
            Write-Host "$($user.Name) 계정은 활성화되어 있으나 관리자 권한은 없습니다."
        }
    } else {
        Write-Host "$($user.Name) 계정은 비활성화되어 있습니다."
    }
}

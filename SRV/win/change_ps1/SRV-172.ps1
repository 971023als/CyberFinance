# SMB 공유 목록을 가져옵니다.
$smbShares = Get-SmbShare

if ($smbShares -ne $null -and $smbShares.Count -gt 0) {
    Write-Host "시스템에 구성된 SMB 공유 목록:"
    foreach ($share in $smbShares) {
        Write-Host "공유 이름: $($share.Name)"
        Write-Host "경로: $($share.Path)"
        Write-Host "-------------------------"
    }
} else {
    Write-Host "시스템에 구성된 SMB 공유가 없습니다."
}

# 추가적으로, 공유 권한을 확인하려면 다음 명령어를 사용할 수 있습니다.
# Get-SmbShareAccess -Name "공유이름"

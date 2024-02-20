Import-Module WebAdministration

# IIS의 FTP 사이트 목록을 가져옵니다.
$ftpSites = Get-ChildItem IIS:\Sites | Where-Object { $_.bindings.Protocol -eq "ftp" }

if ($ftpSites -ne $null -and $ftpSites.Count -gt 0) {
    Write-Host "IIS에 구성된 FTP 사이트 목록:"
    foreach ($site in $ftpSites) {
        Write-Host "사이트 이름: $($site.name)"
        Write-Host "사이트 ID: $($site.id)"
        Write-Host "바인딩: $($site.bindings.Collection)"
        Write-Host "상태: $($site.state)"
        Write-Host "-------------------------"
    }
} else {
    Write-Host "IIS에 구성된 FTP 사이트가 없습니다."
}

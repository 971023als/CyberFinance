# DNS 서버 버전 정보 숨김 설정 확인
$dnsServers = Get-DnsServer
foreach ($dnsServer in $dnsServers) {
    $hideVersion = Get-DnsServerSetting -ComputerName $dnsServer.Name | Select-Object -ExpandProperty HideVersion
    if ($hideVersion) {
        Write-Host "OK: DNS 서비스에서 버전 정보가 숨겨져 있습니다. - 서버: $($dnsServer.Name)"
    } else {
        Write-Host "WARN: DNS 서비스에서 버전 정보가 노출될 수 있습니다. - 서버: $($dnsServer.Name)"
    }
}

# DNS 서버에서 불필요한 Zone Transfer 설정 확인
$zoneTransfers = Get-DnsServerZoneTransferPolicy
foreach ($zoneTransfer in $zoneTransfers) {
    if ($zoneTransfer.AllowTransfer -ne "None") {
        Write-Host "WARN: DNS 서비스에서 불필요한 Zone Transfer가 허용될 수 있습니다. - 정책: $($zoneTransfer.Name)"
    } else {
        Write-Host "OK: DNS 서비스에서 불필요한 Zone Transfer가 제한됩니다. - 정책: $($zoneTransfer.Name)"
    }
}

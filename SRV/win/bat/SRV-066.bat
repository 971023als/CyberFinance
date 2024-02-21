# DNS Zone Transfer 설정 확인
$dnsZones = Get-DnsServerZone

foreach ($zone in $dnsZones) {
    $zoneName = $zone.ZoneName
    $zoneTransfer = Get-DnsServerZoneTransfer -Name $zoneName

    if ($zoneTransfer -ne $null -and $zoneTransfer.AllowTransfer -ne "None") {
        Write-Host "취약: $zoneName Zone에서 Zone Transfer가 적절하게 제한되지 않았습니다. 허용된 전송: $($zoneTransfer.AllowTransfer)"
    } else {
        Write-Host "양호: $zoneName Zone에서 Zone Transfer가 안전하게 제한되어 있습니다."
    }
}

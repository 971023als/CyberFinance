# DNS 서버의 동적 업데이트 설정을 확인합니다.
# 이 예제는 Windows 환경에서 실행되어야 하며, DNS 서버 역할이 설치되어 있어야 합니다.

# 설치된 모든 DNS 영역을 가져옵니다.
$dnsZones = Get-DnsServerZone

foreach ($zone in $dnsZones) {
    # 동적 업데이트 설정을 확인합니다.
    $dynamicUpdate = $zone.DynamicUpdate

    switch ($dynamicUpdate) {
        "None" {
            Write-Host "영역 $($zone.ZoneName)은 동적 업데이트가 비활성화되어 있습니다. - 양호"
        }
        "NonsecureAndSecure" {
            Write-Host "영역 $($zone.ZoneName)은 모든 동적 업데이트를 허용합니다. - 취약"
        }
        "Secure" {
            Write-Host "영역 $($zone.ZoneName)은 보안 동적 업데이트만 허용합니다. - 양호"
        }
        default {
            Write-Host "영역 $($zone.ZoneName)의 동적 업데이트 설정을 확인할 수 없습니다."
        }
    }
}

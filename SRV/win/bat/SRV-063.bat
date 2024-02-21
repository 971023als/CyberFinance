# DNS 서버의 재귀적 쿼리 설정 확인
$dnsServers = Get-DnsServer

foreach ($dnsServer in $dnsServers) {
    $recursionScope = Get-DnsServerRecursionScope -ComputerName $dnsServer.Name
    
    foreach ($scope in $recursionScope) {
        if ($scope.EnableRecursion -eq $true) {
            if ($scope.RecursionScopeName -eq "RootHints" -or $scope.RecursionScopeName -eq "Custom") {
                Write-Host "OK: DNS 서버에서 재귀적 쿼리가 안전하게 제한됨 - 서버: $($dnsServer.Name), 스코프: $($scope.RecursionScopeName)"
            } else {
                Write-Host "WARN: DNS 서버에서 재귀적 쿼리 제한이 미흡함 - 서버: $($dnsServer.Name), 스코프: $($scope.RecursionScopeName)"
            }
        } else {
            Write-Host "OK: DNS 서버에서 재귀적 쿼리가 기본적으로 제한됨 - 서버: $($dnsServer.Name)"
        }
    }
}

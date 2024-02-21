@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-062] DNS Service Information Exposure >> "%TMP1%"
echo [Good]: DNS service information is securely protected >> "%TMP1%"
echo [Vulnerable]: DNS service information is being exposed >> "%TMP1%"

:: Check for DNS version hiding and unnecessary zone transfers using PowerShell
echo Checking DNS service configuration for information exposure and zone transfer settings: >> "%TMP1%"
powershell -Command "& {
    $dnsServers = Get-DnsServer
    foreach ($server in $dnsServers) {
        $zoneTransfers = Get-DnsServerZoneTransfer -ComputerName $server.Name
        $hideVersion = Get-DnsServerSetting -ComputerName $server.Name | Select-Object -ExpandProperty DisableVersionQuery

        if ($hideVersion -eq $true) {
            Write-Output 'DNS version information is hidden.'
        } else {
            Write-Output 'DNS version information might be exposed.'
        }

        foreach ($transfer in $zoneTransfers) {
            if ($transfer.AllowZoneTransfer -eq 'None') {
                Write-Output 'Unnecessary Zone Transfers are restricted.'
            } else {
                Write-Output 'Unnecessary Zone Transfers might be allowed.'
            }
        }
    }
}" >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.

# PowerShell 함수 파일 포함 (예: function.ps1)
. .\function.ps1

$TMP1 = "SRV-063_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-063] DNS Recursive Query 설정 미흡"

$result = $TMP1
# 결과 파일에 내용 추가
Add-Content -Path $result -Value "[양호]: DNS 서버에서 재귀적 쿼리가 제한적으로 설정된 경우"
Add-Content -Path $result -Value "[취약]: DNS 서버에서 재귀적 쿼리가 적절하게 제한되지 않은 경우"

BAR

# Windows DNS 서버에서 재귀적 쿼리 설정 확인
Import-Module DNSServer

# 재귀 설정 확인
$recursionSetting = Get-DnsServerSetting | Select-Object -ExpandProperty RecursionScope

Switch ($recursionSetting) {
    "OnlySecure" { OK "DNS 서버에서 재귀적 쿼리가 안전하게 제한됨: $recursionSetting" }
    "OnlyThisServer" { OK "DNS 서버에서 재귀적 쿼리가 이 서버에만 제한됨: $recursionSetting" }
    "NoRecursion" { OK "DNS 서버에서 재귀적 쿼리가 비활성화됨: $recursionSetting" }
    Default { WARN "DNS 서버에서 재귀적 쿼리 제한이 미흡함: $recursionSetting" }
}

Get-Content -Path $result | Out-Host

Write-Host "`n"

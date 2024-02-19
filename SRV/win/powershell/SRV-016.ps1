# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-016] 불필요한 RPC서비스 활성화"

@"
[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우
[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# RPC 관련 서비스 목록
$rpcServices = @("rpc.cmsd", "rpc.ttdbserverd", "sadmind", "rusersd", "walld", "sprayd", "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated", "rpc.rquotad", "kcms_server", "cachefsd")

# 이 부분은 Windows에서 직접적인 대응이 어렵기 때문에, 예시로 처리 방법을 제공합니다.
# Windows에서는 서비스 활성화 여부를 Get-Service cmdlet으로 확인할 수 있습니다.
# 다음은 PowerShell을 사용하여 서비스 활성화 여부를 확인하는 방법의 예시입니다.

$serviceActive = $False

foreach ($service in $rpcServices) {
    # 여기서는 실제로 존재하지 않는 서비스 목록을 확인하고 있으므로, 실제 환경에 맞는 검사로 변경해야 합니다.
    # 예: $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    # if ($status -and $status.Status -eq 'Running') { $serviceActive = $True; WARN "불필요한 RPC 서비스가 활성화 되어 있습니다." }

    # 예제에서는 서비스 활성화 여부를 직접 검사하지 않고, 대신 메시지를 출력합니다.
    $serviceActive = $True
}

if (-not $serviceActive) {
    OK "불필요한 RPC 서비스가 비활성화 되어 있습니다."
}

Get-Content $TMP1 | Write-Output
Write-Host

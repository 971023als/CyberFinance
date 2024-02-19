# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-035_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "$message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 취약한 서비스가 비활성화된 경우
[취약]: 취약한 서비스가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 취약한 서비스 목록
$services = @("echo", "discard", "daytime", "chargen")

# /etc/xinetd.d 폴더 내의 서비스 파일들을 확인합니다.
if (Test-Path -Path "/etc/xinetd.d") {
    foreach ($service in $services) {
        $filePath = "/etc/xinetd.d/$service"
        if (Test-Path -Path $filePath) {
            $content = Get-Content -Path $filePath
            $disabled = $content | Where-Object { $_ -match "disable\s*=\s*yes" }
            if (-not $disabled) {
                Write-WARN "$service 서비스가 /etc/xinetd.d 디렉터리 내 서비스 파일에서 실행 중입니다."
                exit
            }
        }
    }
}

# /etc/inetd.conf 파일에서 서비스들을 확인합니다.
if (Test-Path -Path "/etc/inetd.conf") {
    $inetdConfContent = Get-Content -Path "/etc/inetd.conf"
    foreach ($service in $services) {
        $enabled = $inetdConfContent | Where-Object { $_ -match $service -and -not $_.StartsWith('#') }
        if ($enabled) {
            Write-WARN "$service 서비스가 /etc/inetd.conf 파일에서 실행 중입니다."
            exit
        }
    }
}

Write-OK "※ U-23 결과 : 양호(Good)"

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

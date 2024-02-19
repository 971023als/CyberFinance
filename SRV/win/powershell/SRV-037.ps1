# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-037_log.txt"
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
[양호]: FTP 서비스가 비활성화 되어 있는 경우
[취약]: FTP 서비스가 활성화 되어 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# FTP 서비스가 실행 중인지 확인합니다.
$netstatOutput = netstat -ano | Select-String -Pattern ":21\s"
if ($netstatOutput) {
    Write-WARN "ftp 서비스가 실행 중입니다."
} else {
    # vsftpd.conf 및 proftpd.conf 파일의 존재 여부와 설정을 확인합니다.
    $vsftpdConfFiles = Get-ChildItem -Path / -Filter "vsftpd.conf" -Recurse -ErrorAction SilentlyContinue
    $proftpdConfFiles = Get-ChildItem -Path / -Filter "proftpd.conf" -Recurse -ErrorAction SilentlyContinue

    $ftpServiceActive = $False

    foreach ($file in $vsftpdConfFiles, $proftpdConfFiles) {
        $content = Get-Content $file.FullName
        foreach ($line in $content) {
            if ($line -match "listen_port=(\d+)" -or $line -match "Port (\d+)") {
                $port = $matches[1]
                $netstatPortCheck = netstat -ano | Select-String -Pattern ":$port\s"
                if ($netstatPortCheck) {
                    Write-WARN "ftp 서비스가 실행 중입니다: $($file.FullName)"
                    $ftpServiceActive = $True
                    break
                }
            }
        }
        if ($ftpServiceActive) { break }
    }

    if (-not $ftpServiceActive) {
        $psFtpCount = (Get-Process | Where-Object { $_.ProcessName -match 'ftp|vsftpd|proftpd' }).Count
        if ($psFtpCount -gt 0) {
            Write-WARN "ftp 서비스가 실행 중입니다."
        } else {
            Write-OK "※ U-61 결과 : 양호(Good)"
        }
    }
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

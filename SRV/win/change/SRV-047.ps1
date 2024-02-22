# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-047_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function Write-WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webconfFiles = @(".htaccess", "httpd.conf", "apache2.conf", "userdir.conf")

foreach ($file in $webconfFiles) {
    $findWebconfFiles = Get-ChildItem -Path C:\ -Filter $file -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $findWebconfFiles) {
        $webConfContent = Get-Content $f.FullName
        if ($webConfContent -match "Options.*SymLinksIfOwnerMatch" -and -not $webConfContent -match "Options.*FollowSymLinks") {
            Write-OK "Apache 설정 파일에서 심볼릭 링크 사용이 안전하게 제한됨: $($f.FullName)"
        } elseif ($webConfContent -match "Options.*FollowSymLinks") {
            Write-WARN "Apache 설정 파일에 심볼릭 링크 사용을 제한하도록 설정하지 않습니다: $($f.FullName)"
        }
    }
}

if ($findWebconfFiles.Count -eq 0) {
    Write-OK "※ U-39 결과 : 양호(Good)"
} else {
    # 만약 양호한 구성이 하나도 발견되지 않았다면, 모든 파일이 취약한 구성을 가지고 있다고 판단할 수 있습니다.
    Write-WARN "※ U-39 결과 : 취약(Vulnerable)"
}

Get-Content $TMP1 | Write-Output

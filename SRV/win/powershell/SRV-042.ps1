# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-042_log.txt"
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
[양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우
[취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

$webConfFiles = @(".htaccess", "httpd.conf", "apache2.conf", "userdir.conf")
$fileExistsCount = 0

foreach ($webConfFile in $webConfFiles) {
    $findWebConfFiles = Get-ChildItem -Recurse -Path / -Filter $webConfFile -ErrorAction SilentlyContinue
    if ($findWebConfFiles) {
        $fileExistsCount++
        foreach ($file in $findWebConfFiles) {
            if ($file.Name -eq "userdir.conf") {
                $userDirConfContent = Get-Content $file.FullName
                $userDirConfDisabledCount = ($userDirConfContent | Where-Object {$_ -match 'userdir' -and $_ -match 'disabled'}).Count
                $userDirConfAllowOverrideCount = ($userDirConfContent | Where-Object {$_ -match 'AllowOverride'}).Count
                $userDirConfAllowOverrideNoneCount = ($userDirConfContent | Where-Object {$_ -match 'AllowOverride' -and $_ -match 'None'}).Count
                if ($userDirConfAllowOverrideCount -gt 0 -and $userDirConfAllowOverrideNoneCount -eq 0) {
                    Write-WARN "웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다."
                    return
                }
            } else {
                $webConfContent = Get-Content $file.FullName
                $webConfAllowOverrideCount = ($webConfContent | Where-Object {$_ -match 'AllowOverride'}).Count
                $webConfAllowOverrideNoneCount = ($webConfContent | Where-Object {$_ -match 'AllowOverride' -and $_ -match 'None'}).Count
                if ($webConfAllowOverrideCount -gt 0 -and $webConfAllowOverrideNoneCount -eq 0) {
                    Write-WARN "웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다."
                    return
                }
            }
        }
    }
}

$psApacheCount = (Get-Process -Name 'httpd', 'apache2' -ErrorAction SilentlyContinue).Count
if ($psApacheCount -gt 0 -and $fileExistsCount -eq 0) {
    Write-WARN "Apache 서비스를 사용하고, 웹 서비스 상위 디렉터리에 이동 제한을 설정하는 파일이 없습니다."
} else {
    Write-OK "※ U-37 결과: 양호(Good)"
}

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output

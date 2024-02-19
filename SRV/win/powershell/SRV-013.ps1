# 결과 파일 초기화
$TMP1 = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name) + ".log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
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

"CODE [SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비" | Out-File -FilePath $TMP1 -Append

@"
[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우
[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 익명 계정 접속 제한 설정 확인
$ftpUserExists = Get-Content -Path C:\Windows\System32\drivers\etc\passwd | Where-Object { $_ -match "^(ftp|anonymous)" }

if ($ftpUserExists) {
    $fileExistsCount = 0
    $proftpdConfFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter "proftpd.conf"
    $vsftpdConfFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter "vsftpd.conf"
    
    # ProFTPD 설정 파일 검사
    foreach ($file in $proftpdConfFiles) {
        $content = Get-Content -Path $file.FullName
        if ($content -match '<Anonymous' -and $content -match '</Anonymous>') {
            if ($content -match 'User\s' -or $content -match 'UserAlias\s') {
                WARN " ${file.FullName} 파일에서 'User' 또는 'UserAlias' 옵션이 삭제 또는 주석 처리되어 있지 않습니다."
                return
            }
        }
    }

    # VsFTPD 설정 파일 검사
    foreach ($file in $vsftpdConfFiles) {
        $content = Get-Content -Path $file.FullName
        $anonymousEnable = $content | Where-Object { $_ -match 'anonymous_enable' }
        if ($anonymousEnable) {
            if ($anonymousEnable -match 'yes') {
                WARN " ${file.FullName} 파일에서 익명 ftp 접속을 허용하고 있습니다."
                return
            }
        } else {
            WARN " ${file.FullName} 파일에 익명 ftp 접속을 설정하는 옵션이 없습니다."
            return
        }
    }

    if (-not $proftpdConfFiles -and -not $vsftpdConfFiles) {
        WARN " 익명 ftp 접속을 설정하는 파일이 없습니다."
        return
    }
} else {
    OK "Anonymous FTP (익명 ftp) 접속을 차단"
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host

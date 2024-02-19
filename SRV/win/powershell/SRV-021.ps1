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

CODE "[SRV-021] FTP 서비스 접근 제어 설정 미비"

@"
[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우
[취약]: ftpusers 파일의 소유자가 root가 아니고, 권한이 640 이상인 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# FTP 서비스 구성 파일에서 익명 사용자 접속을 확인합니다.
$fileExistsCount = 0
$ftpusersFiles = @("/etc/ftpusers", "/etc/pure-ftpd/ftpusers", "/etc/wu-ftpd/ftpusers", "/etc/vsftpd/ftpusers", "/etc/proftpd/ftpusers", "/etc/ftpd/ftpusers", "/etc/vsftpd.ftpusers", "/etc/vsftpd.user_list", "/etc/vsftpd/user_list")

foreach ($file in $ftpusersFiles) {
    if (Test-Path $file) {
        $fileExistsCount++
        $fileInfo = Get-Item $file
        $fileOwner = $fileInfo.GetAccessControl().Owner
        if ($fileOwner -eq "BUILTIN\Administrators" -or $fileOwner -eq "NT SERVICE\TrustedInstaller") {
            $filePermission = (Get-Acl $file).Access | Where-Object { $_.FileSystemRights -match "FullControl|Modify|ReadAndExecute|Read|Write" } | Select-Object -First 1
            if ($filePermission) {
                if ($filePermission.FileSystemRights -notmatch "FullControl|Modify") {
                    if ($filePermission.FileSystemRights -match "ReadAndExecute|Read" -and $filePermission.AccessControlType -eq "Allow") {
                        OK "ftpusers 파일의 소유자가 관리자이고, 권한이 적절하게 설정됨: $file" | Out-File -FilePath $TMP1 -Append
                    }
                    else {
                        WARN "ftpusers 파일의 다른 사용자(other)에 대한 권한이 취약합니다: $file" | Out-File -FilePath $TMP1 -Append
                    }
                }
                else {
                    WARN "ftpusers 파일의 권한이 640보다 큽니다: $file" | Out-File -FilePath $TMP1 -Append
                }
            }
            else {
                WARN "ftpusers 파일의 사용자(owner)에 대한 권한이 취약합니다: $file" | Out-File -FilePath $TMP1 -Append
            }
        }
        else {
            WARN "ftpusers 파일의 소유자(owner)가 관리자가 아닙니다: $file" | Out-File -FilePath $TMP1 -Append
        }
    }
}

if ($fileExistsCount -eq 0) {
    WARN "ftp 접근 제어 파일이 없습니다." | Out-File -FilePath $TMP1 -Append
}
else {
    OK "※ U-63 결과: 양호(Good)" | Out-File -FilePath $TMP1 -Append
}

Get-Content $TMP1 | Write-Output
Write-Host

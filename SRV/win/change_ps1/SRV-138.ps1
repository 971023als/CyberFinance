# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_BackupAndRecoveryPermissions.log"

# 백업 디렉토리 경로 설정
$backupDirs = @("C:\path\to\backup\dir1", "C:\path\to\backup\dir2")

foreach ($dir in $backupDirs) {
    if (Test-Path $dir) {
        $acl = Get-Acl $dir
        $owner = $acl.Owner
        $permissions = $acl.Access | Where-Object { $_.FileSystemRights -eq "FullControl" -and $_.IdentityReference -eq "DOMAIN\backup_user" }

        if ($null -ne $permissions) {
            "OK: $dir 은 적절한 권한 및 소유자($owner)를 가집니다." | Out-File -FilePath $TMP1 -Append
        } else {
            "WARN: $dir 은 부적절한 권한 또는 소유자($owner)를 가집니다." | Out-File -FilePath $TMP1 -Append
        }
    } else {
        "INFO: $dir 디렉토리가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1

function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$global:TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-096] 사용자 환경파일의 소유자 또는 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 사용자 환경 파일의 소유자가 해당 사용자이고, 권한이 적절하게 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 사용자 환경 파일의 소유자가 해당 사용자가 아니거나, 권한이 부적절하게 설정된 경우"

BAR

# 사용자 프로필 디렉터리 검사
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
$startFiles = @(".profile", ".cshrc", ".login", ".kshrc", ".bash_profile", ".bashrc", ".bash_login")

foreach ($profile in $userProfiles) {
    foreach ($file in $startFiles) {
        $filePath = Join-Path -Path $profile.FullName -ChildPath $file
        if (Test-Path $filePath) {
            $fileOwner = (Get-Acl $filePath).Owner
            $everyonePermissions = (Get-Acl $filePath).Access | Where-Object { $_.IdentityReference.Value -eq "Everyone" -and $_.FileSystemRights -match "Write" }
            if ($everyonePermissions) {
                Add-Content -Path $global:TMP1 -Value "WARN: $($filePath) 파일에 Everyone 그룹에 쓰기 권한이 부여되어 있습니다."
            } else {
                Add-Content -Path $global:TMP1 -Value "OK: $($filePath) 파일의 소유자 및 권한 설정이 적절합니다."
            }
        }
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n"

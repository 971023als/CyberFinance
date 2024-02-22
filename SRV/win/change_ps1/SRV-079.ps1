# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-079] 익명 사용자에게 부적절한 권한(Everyone) 적용"

$result = $TMP1
Add-Content -Path $result -Value "[양호]: 익명 사용자에게 부적절한 권한이 적용되지 않은 경우"
Add-Content -Path $result -Value "[취약]: 익명 사용자에게 부적절한 권한이 적용된 경우"

BAR

# C:\ 드라이브 내의 모든 파일 및 폴더에 대한 권한 검사
$worldWritableFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    $acl = Get-Acl -Path $_.FullName
    $accessRules = $acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference.Value -eq "Everyone" }
    return $accessRules
}

if ($worldWritableFiles) {
    foreach ($file in $worldWritableFiles) {
        WARN "Everyone 쓰기 권한이 설정된 항목이 있습니다: $($file.FullName)"
    }
} else {
    OK "Everyone 쓰기 권한이 설정된 항목이 없습니다."
}

Get-Content -Path $result | Out-Host

Write-Host "`n"

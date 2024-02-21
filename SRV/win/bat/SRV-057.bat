# PowerShell 스크립트 예시: 웹 서비스 경로 내 파일의 접근 권한 확인

# 웹 서비스 경로 설정 (실제 경로에 맞게 조정하세요)
$webServicePath = "C:\inetpub\wwwroot"

# 웹 서비스 경로 내 파일 접근 권한 확인
# 예: 특정 사용자 또는 그룹에게 읽기 권한만 부여되어 있는지 확인
Get-ChildItem -Path $webServicePath -Recurse -File | ForEach-Object {
    $filePath = $_.FullName
    $fileAcl = Get-Acl $filePath
    $hasInappropriatePermission = $false

    foreach ($access in $fileAcl.Access) {
        # 여기서는 예시로 'Everyone' 그룹에 대한 'FullControl' 권한이 설정되어 있는지를 확인합니다.
        # 실제 상황에 맞는 조건으로 수정하세요.
        if ($access.IdentityReference -eq "Everyone" -and $access.FileSystemRights -eq "FullControl") {
            $hasInappropriatePermission = $true
            break
        }
    }

    if ($hasInappropriatePermission) {
        Write-Host "부적절한 권한이 있는 파일: $filePath"
    }
}

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-057.log"
"웹 서비스 경로 내 파일의 접근 권한 점검 완료" | Out-File -FilePath $TMP1

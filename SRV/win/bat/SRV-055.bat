# PowerShell 스크립트 예시: 웹 서비스 설정 파일의 접근 권한 확인

# 중요한 웹 서비스 설정 파일의 경로를 지정합니다.
$webConfigFiles = @(
    "C:\inetpub\wwwroot\web.config", # IIS 웹 서비스 구성 파일 예시
    "C:\Path\To\Another\Web\Service\Config.file" # 기타 웹 서비스 구성 파일 예시
)

# 각 설정 파일의 접근 권한을 확인합니다.
foreach ($configFile in $webConfigFiles) {
    if (Test-Path $configFile) {
        $fileAcl = Get-Acl $configFile
        $isProtected = $fileAcl.Access | Where-Object { $_.FileSystemRights -eq "FullControl" -and $_.IdentityReference -eq "BUILTIN\Administrators" }
        if ($null -ne $isProtected) {
            Write-Output "설정 파일이 보호됩니다: $configFile"
        } else {
            Write-Output "설정 파일의 접근 권한이 취약합니다: $configFile"
        }
    } else {
        Write-Output "설정 파일이 존재하지 않습니다: $configFile"
    }
}

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-055.log"
"웹 서비스 설정 파일의 접근 권한 점검 완료" | Out-File -FilePath $TMP1

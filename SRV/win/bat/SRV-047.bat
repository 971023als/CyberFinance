# PowerShell 스크립트 예시: 웹 서버 경로 내 심볼릭 링크 사용 제한 및 접근 권한 설정

# 웹 서비스 경로 지정
$webServicePath = "C:\inetpub\wwwroot"

# 웹 서비스 경로 내 심볼릭 링크 찾기
$symbolicLinks = Get-ChildItem -Path $webServicePath -Recurse | Where-Object { $_.Attributes -match 'ReparsePoint' }

# 심볼릭 링크가 존재하는 경우, 사용자에게 알림
if ($symbolicLinks.Count -gt 0) {
    Write-Output "웹 서비스 경로 내 다음 심볼릭 링크가 발견되었습니다:"
    $symbolicLinks.FullName
    # 추가 조치: 심볼릭 링크 삭제 또는 접근 권한 변경
} else {
    Write-Output "웹 서비스 경로 내 심볼릭 링크가 발견되지 않았습니다."
}

# 특정 경로에 대한 접근 권한 설정 (예: Everyone 그룹의 읽기 권한 제거)
$securityPath = "C:\inetpub\wwwroot\restricted"
$acl = Get-Acl $securityPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "Read", "Allow")
$acl.RemoveAccessRule($rule)
Set-Acl -Path $securityPath -AclObject $acl

# 실행 결과를 로그 파일에 저장합니다.
$TMP1 = "SRV-047.log"
"웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않는 경우" | Out-File -FilePath $TMP1 -Append

# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_SystemShutdownPermissions.log"
New-Item -Path $TMP1 -ItemType File

# Local Security Policy의 User Rights Assignment 조회는 직접적인 PowerShell 명령이 없으므로,
# 대안적인 접근 방법으로 시스템의 중요 권한을 갖는 계정을 확인

# 예: 'Administrators' 그룹 멤버 조회
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name

# 파일에 결과 저장
if ($adminGroupMembers) {
    "OK: 'Administrators' 그룹에 포함된 사용자 목록: $($adminGroupMembers -join ', ')" | Out-File -FilePath $TMP1
} else {
    "WARN: 'Administrators' 그룹에 사용자가 없습니다." | Out-File -FilePath $TMP1
}

# 결과 파일 출력
Get-Content -Path $TMP1

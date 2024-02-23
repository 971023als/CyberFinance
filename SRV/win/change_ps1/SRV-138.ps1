# 스크립트 이름 정의
$ScriptName = "SCRIPTNAME"

# 로그 파일 경로 설정
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-138] 백업 및 복구 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 백업 및 복구 권한이 적절히 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 백업 및 복구 권한이 적절히 설정되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 백업 디렉토리 설정
$backupDir = "C:\Backup"

# 디렉토리 존재 여부 확인
if (-Not (Test-Path -Path $backupDir)) {
    "INFO: $backupDir 디렉토리가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    # 권한 확인 (icacls와 유사한 출력)
    $acl = Get-Acl -Path $backupDir
    $acl.Access | Out-File -FilePath $TMP1 -Append

    # 추가적인 권한 분석 및 판단 로직은 필요에 따라 구현
    "권한 분석 결과는 $TMP1 파일을 참조하세요." | Out-File -FilePath $TMP1 -Append
}

# 로그 파일 출력
Get-Content -Path $TMP1 | Write-Output


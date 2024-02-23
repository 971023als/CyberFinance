# 스크립트 이름 정의
$ScriptName = "SCRIPTNAME"

# 로그 파일 경로 설정
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 타겟 경로 설정
$targetPath = "C:\Windows\System32"

# 파일 권한 확인 (icacls와 유사한 출력)
$acl = Get-Acl -Path $targetPath
$acl.Access | Out-File -FilePath $TMP1 -Append

# 추가적인 권한 분석 로직은 필요에 따라 구현
"파일 권한 분석 결과는 $TMP1 파일을 참조하십시오." | Out-File -FilePath $TMP1 -Append

# 로그 파일 출력
Get-Content -Path $TMP1 | Write-Output

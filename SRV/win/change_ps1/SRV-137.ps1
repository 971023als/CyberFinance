# 스크립트 이름 정의 및 로그 파일 경로 설정
$ScriptName = "SCRIPTNAME"
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-137] 네트워크 서비스의 접근 제한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 네트워크 서비스의 접근 제한이 적절히 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 네트워크 서비스의 접근 제한이 설정되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# Windows 방화벽 규칙 검사 및 결과 로깅
Get-NetFirewallRule | Where-Object { $_.Enabled -eq $true -and $_.Action -eq 'Allow' } | Format-Table Name, Action, Direction, Enabled -AutoSize | Out-File -FilePath $TMP1 -Append

# 추가적인 분석 및 판단 로직 필요
"추가적인 분석 및 판단 로직이 필요합니다. 결과는 $TMP1 파일을 참조하세요." | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

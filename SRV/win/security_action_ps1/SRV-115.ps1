# 로그 파일 경로 설정 및 초기화
$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
"" | Out-File -FilePath $TMP1

# 로그 파일에 코드와 설명 추가
"코드 [SRV-115] 로그의 정기적 검토 및 보고 미수행" | Out-File -FilePath $TMP1 -Append
"[양호]: 로그가 정기적으로 검토 및 보고되고 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 로그가 정기적으로 검토 및 보고되지 않는 경우" | Out-File -FilePath $TMP1 -Append
"-" * 50 | Out-File -FilePath $TMP1 -Append

# 로그 검토 및 보고 스크립트 존재 여부 확인
$logReviewScriptPath = "C:\Path\To\Log\Review\Script.ps1"
if (-not (Test-Path -Path $logReviewScriptPath)) {
    "WARN: 로그 검토 및 보고 스크립트가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 로그 검토 및 보고 스크립트가 존재합니다." | Out-File -FilePath $TMP1 -Append
}

# 로그 보고서 존재 여부 확인
$logReportPath = "C:\Path\To\Log\Report.txt"
if (-not (Test-Path -Path $logReportPath)) {
    "WARN: 로그 보고서가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 로그 보고서가 존재합니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host

# 이벤트 로그 감사 설정 방법 안내
"이벤트 로그 감사 설정 방법 안내:" | Out-Host
"1. 제어판을 이용한 설정:" | Out-Host
"   - gpedit.msc 실행 후 '컴퓨터 구성 > Windows 설정 > 보안 설정 > 로컬 정책 > 감사 정책' 경로를 따라 설정을 조정합니다." | Out-Host
"   - '고급 감사 정책 구성 > 시스템 감사 정책'에서 추가 설정을 조정할 수 있습니다." | Out-Host
"2. 시스템 복원 설정:" | Out-Host
"   - '제어판 > 시스템 및 보안 > 시스템 > 시스템 보호'에서 설정을 조정합니다." | Out-Host
"3. 이벤트 로그 설정 (윈도우 방화벽, 저장매체 연결, 네트워크 연결 등):" | Out-Host
"   - 이벤트 뷰어를 통해 각 항목별 로그 크기 및 로깅 설정을 조정합니다." | Out-Host

Write-Host "`n스크립트 실행 완료."

# 결과 파일 정의
$TMP1 = "$(Get-Location)\SCRIPTNAME.log"
"CODE [SRV-133] Cron 서비스 사용 계정 제한 미비" | Out-File -FilePath $TMP1

# Task Scheduler에서 모든 태스크 조회
$tasks = Get-ScheduledTask | Where-Object {$_.Principal.UserId -notmatch 'SYSTEM|LOCALSERVICE|NETWORKSERVICE'}

# 특정 계정에 대한 작업 실행 제한 검사
if ($tasks.Count -eq 0) {
    "OK: 모든 스케줄된 태스크가 시스템 계정으로 제한되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    foreach ($task in $tasks) {
        "WARN: $($task.TaskName) 태스크가 $($task.Principal.UserId) 계정으로 실행되도록 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1

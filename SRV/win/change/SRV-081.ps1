# 로그 파일 초기화 및 기본 정보 기록
$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Clear-Content -Path $TMP1

# 구분선 추가
function BAR {
    Add-Content -Path $TMP1 -Value ("-" * 50)
}

BAR

$CODE = "[SRV-081] 일반 사용자의 프린터 드라이버 설치 제한 미비"

Add-Content -Path $TMP1 -Value "[양호]: 스케줄러 작업의 권한 설정이 적절히 이루어진 경우"
Add-Content -Path $TMP1 -Value "[취약]: 스케줄러 작업의 권한 설정이 적절히 이루어지지 않은 경우"

BAR

# 스케줄러 작업 조회 및 권한 검사
$scheduledTasks = Get-ScheduledTask | Where-Object {
    $_.Principal.UserId -notmatch '^(NT AUTHORITY\\SYSTEM|NT AUTHORITY\\LOCAL SERVICE|NT AUTHORITY\\NETWORK SERVICE)$'
}

if ($scheduledTasks) {
    foreach ($task in $scheduledTasks) {
        $taskName = $task.TaskName
        $userId = $task.Principal.UserId
        Add-Content -Path $TMP1 -Value "WARN: 사용자 권한으로 실행되는 스케줄러 작업이 있습니다: TaskName: $taskName, UserId: $userId"
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: 모든 스케줄러 작업이 적절한 권한으로 설정되어 있습니다."
}

# 로그 파일의 내용을 출력
Get-Content -Path $TMP1 | Out-Host

Write-Host "`n"

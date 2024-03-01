# 로그 시작
Write-Host "===================="
Write-Host "CODE [DBM-008] 주기적인 비밀번호 변경 미흡"

# 사용자 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL. 사용 중인 데이터베이스 유형을 입력하세요"
$DB_USER = Read-Host "$DB_TYPE 사용자 이름을 입력하세요"
$DB_PASS = Read-Host "$DB_TYPE 비밀번호를 입력하세요" -AsSecureString

# 주기적인 비밀번호 변경 정책 설정 확인
if ($DB_TYPE -eq "MySQL") {
    $MYSQL_CMD = "mysql.exe -u $DB_USER --password=$DB_PASS -Bse"
    $QUERY = "SELECT user, password_last_changed FROM mysql.user;"
    $PASSWORD_CHANGE_POLICY = Invoke-Expression "$MYSQL_CMD `"$QUERY`""
} elseif ($DB_TYPE -eq "PostgreSQL") {
    $PGSQL_CMD = "psql.exe -U $DB_USER -c"
    $QUERY = "SELECT usename as user, rolpassword as password_last_changed FROM pg_shadow;"
    $PASSWORD_CHANGE_POLICY = Invoke-Expression "$PGSQL_CMD `"$QUERY`""
} else {
    Write-Host "지원하지 않는 데이터베이스 유형입니다."
    exit
}

# 비밀번호 변경 정책 확인
if (-not $PASSWORD_CHANGE_POLICY) {
    Write-Host "주기적인 비밀번호 변경 정책이 설정되어 있지 않습니다."
} else {
    $MAX_DAYS = 90
    $CURRENT_DATE = Get-Date

    foreach ($row in $PASSWORD_CHANGE_POLICY) {
        $user, $last_changed = $row -split '\s+', 2
        $last_changed_date = [datetime]::ParseExact($last_changed, "yyyy-MM-dd", $null)

        if ($last_changed_date -lt $CURRENT_DATE.AddDays(-$MAX_DAYS)) {
            Write-Host "주기적으로 비밀번호가 변경되지 않은 계정이 존재합니다: $user (마지막 변경: $last_changed_date)"
        }
    }
}

# 로그 종료
Write-Host "===================="

# Define a function to display headers
function Write-Bar {
    Write-Host "=================================================="
}

# Define a function to display code
function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

# Define a function to warn about settings
function Warn {
    param($message)
    Write-Host "WARNING: $message"
}

# Define a function to confirm settings
function OK {
    param($message)
    Write-Host "OK: $message"
}

Write-Bar
Write-Code "DBM-009] 사용되지 않는 세션 종료 미흡"

# Prompt for database type
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL. 사용 중인 데이터베이스 유형을 입력하세요"

# Execute based on database type
switch ($DB_TYPE) {
    "MySQL" {
        $MYSQL_USER = Read-Host "Enter MySQL username"
        $MYSQL_PASS = Read-Host "Enter MySQL password" -AsSecureString
        $MYSQL_PASS = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MYSQL_PASS))
        $QUERY = "SHOW VARIABLES LIKE 'wait_timeout';"
        $SESSION_TIMEOUT = & mysql.exe -u $MYSQL_USER -p$MYSQL_PASS -Bse $QUERY
    }
    "PostgreSQL" {
        $PGSQL_USER = Read-Host "Enter PostgreSQL username"
        $PGSQL_PASS = Read-Host "Enter PostgreSQL password" -AsSecureString
        $PGSQL_PASS = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PGSQL_PASS))
        $QUERY = "SHOW idle_in_transaction_session_timeout;"
        $SESSION_TIMEOUT = & psql.exe -U $PGSQL_USER -c $QUERY
    }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

# Check and display session timeout settings
if ([string]::IsNullOrWhiteSpace($SESSION_TIMEOUT)) {
    Warn "세션 종료 시간이 설정되어 있지 않습니다."
} else {
    $TIMEOUT_VALUE = $SESSION_TIMEOUT.Split('=')[1].Trim()
    if ($TIMEOUT_VALUE -le 300) {
        OK "세션 종료 시간이 적절히 설정되어 있습니다: $TIMEOUT_VALUE seconds."
    } else {
        Warn "세션 종료 시간이 너무 길게 설정되어 있습니다: $TIMEOUT_VALUE seconds."
    }
}

Write-Bar

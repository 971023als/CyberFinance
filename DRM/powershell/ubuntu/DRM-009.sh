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
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"

# Execute based on database type
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL logic...
    }
    "PostgreSQL" {
        # PostgreSQL logic...
    }
    "MSSQL" {
        $MSSQL_USER = Read-Host "Enter MSSQL username"
        $MSSQL_PASS = Read-Host "Enter MSSQL password" -AsSecureString
        $ConnectionString = "Server=localhost; User ID=$MSSQL_USER; Password=$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MSSQL_PASS)));"
        $QUERY = "SELECT name, value_in_use FROM sys.configurations WHERE name = 'remote query timeout';"
        $SESSION_TIMEOUT = Invoke-Sqlcmd -Query $QUERY -ConnectionString $ConnectionString
    }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

# Check and display session timeout settings for MSSQL
if ($DB_TYPE -eq "MSSQL") {
    if ($SESSION_TIMEOUT.value_in_use -eq 0) {
        Warn "MSSQL 세션 종료 시간이 무제한으로 설정되어 있습니다."
    } else {
        OK "MSSQL 세션 종료 시간이 설정되어 있습니다: $($SESSION_TIMEOUT.value_in_use) seconds."
    }
} elseif (-not [string]::IsNullOrWhiteSpace($SESSION_TIMEOUT)) {
    # MySQL and PostgreSQL logic...
}

Write-Bar

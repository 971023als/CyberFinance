# Start log
Write-Host "===================="
Write-Host "CODE [DBM-008] 주기적인 비밀번호 변경 미흡"

# Prompt for database type, username, and password
$DB_TYPE = Read-Host "Supported databases: MySQL, PostgreSQL, MSSQL. Enter the type of database you are using"
$DB_USER = Read-Host "$DB_TYPE user name"
$DB_PASS = Read-Host "$DB_TYPE password" -AsSecureString

# Check periodic password change policy settings
switch ($DB_TYPE) {
    "MySQL" {
        # Existing MySQL logic
    }
    "PostgreSQL" {
        # Existing PostgreSQL logic
    }
    "MSSQL" {
        # Convert SecureString password to plaintext for Invoke-Sqlcmd
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $PlainTextPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # Define the query to check the password last change date in MSSQL
        $Query = @"
SELECT name, modify_date FROM sys.sql_logins
"@
        # Execute the query and process the results
        $PASSWORD_CHANGE_POLICY = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $PlainTextPass
    }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

# Check password change policy
if (-not $PASSWORD_CHANGE_POLICY) {
    Write-Host "주기적인 비밀번호 변경 정책이 설정되어 있지 않습니다."
} else {
    $MAX_DAYS = 90
    $CURRENT_DATE = Get-Date

    foreach ($row in $PASSWORD_CHANGE_POLICY) {
        $user = $row.name
        $last_changed_date = $row.modify_date

        if ($last_changed_date -lt $CURRENT_DATE.AddDays(-$MAX_DAYS)) {
            Write-Host "주기적으로 비밀번호가 변경되지 않은 계정이 존재합니다: $user (마지막 변경: $last_changed_date)"
        }
    }
}

# End log
Write-Host "===================="

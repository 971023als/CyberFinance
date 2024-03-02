# Prompt for database type, username, and password
$DB_TYPE = Read-Host "Supported databases: MySQL, PostgreSQL, MSSQL. Enter the type of database you are using"
$DB_USER = Read-Host "$DB_TYPE user name"
$DB_PASS = Read-Host "$DB_TYPE password" -AsSecureString

# Process according to the database type
switch ($DB_TYPE) {
    "MySQL" {
        # Existing logic for MySQL password complexity check
    }
    "PostgreSQL" {
        # Existing logic for PostgreSQL password complexity check
    }
    "MSSQL" {
        # Convert SecureString password to plaintext for Invoke-Sqlcmd
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $PlainTextPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # Define the query to check password policy enforcement in MSSQL
        $Query = @"
SELECT name, is_policy_checked, is_expiration_checked FROM sys.sql_logins
"@

        # Execute the query and process the results
        try {
            $Results = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $PlainTextPass
            foreach ($Result in $Results) {
                if ($Result.is_policy_checked -eq $true) {
                    Write-Host "Account: $($Result.name) has password policy enforcement."
                } else {
                    Write-Host "Account: $($Result.name) does not have password policy enforcement."
                }
            }
        } catch {
            Write-Host "Error connecting to MSSQL database or executing query: $_"
        }
    }
    default {
        Write-Host "Unsupported database type."
    }
}

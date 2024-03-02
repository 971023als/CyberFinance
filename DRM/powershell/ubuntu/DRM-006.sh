# Prompt for database type, username, and password
$DB_TYPE = Read-Host "Supported databases: MySQL, PostgreSQL, MSSQL. Enter the type of database you are using"
$DB_USER = Read-Host "$DB_TYPE user name"
$DB_PASS = Read-Host "$DB_TYPE password" -AsSecureString

# Process according to the database type
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL connection and query execution logic (as before)
    }
    "PostgreSQL" {
        # PostgreSQL does not natively support a login failure limit as MySQL does
        # Inform the user about alternative methods
    }
    "MSSQL" {
        # Convert the secure string password back to plain text for SQL Server connection
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        # Define the query to check for login failure limit
        # MSSQL uses security policies for this, which can be found in the sys.sql_logins table
        $Query = @"
SELECT name, is_disabled, login_failures, is_policy_checked, is_expiration_checked
FROM sys.sql_logins
"@
        
        try {
            # Execute the query
            $Results = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $UnsecurePassword -Database "master"
            
            # Process the results
            foreach ($Result in $Results) {
                if ($Result.is_policy_checked -eq $true) {
                    Write-Host "Account: $($Result.name) has login failure policy enforced."
                } else {
                    Write-Host "Account: $($Result.name) does not have login failure policy enforced."
                }
            }
        } catch {
            Write-Host "An error occurred: $_"
        }
    }
    default {
        Write-Host "Unsupported database type."
    }
}

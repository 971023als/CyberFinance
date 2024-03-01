# PowerShell script for checking unnecessary system table access permissions

# Placeholder for result accumulation
$result = @()

# Define a function to output results
function Add-Result {
    param (
        [string]$message
    )
    $global:result += $message
}

# Ask user for database type
Write-Host "Supported databases: 1. MySQL 2. PostgreSQL"
$dbType = Read-Host "Enter the number corresponding to your database type"

# Ask user for database credentials
$dbUser = Read-Host "Enter the database username"
$dbPass = Read-Host "Enter the database password" -AsSecureString
$dbPassPlain = [System.Net.NetworkCredential]::new("", $dbPass).Password

# Check for unnecessary system table access permissions based on the selected database type
switch ($dbType) {
    "1" {
        # MySQL check
        $mysqlCmd = "mysql -u $dbUser -p$dbPassPlain -Bse"
        $query = "SELECT GRANTEE, TABLE_SCHEMA, PRIVILEGE_TYPE FROM information_schema.SCHEMA_PRIVILEGES WHERE TABLE_SCHEMA IN ('mysql', 'information_schema', 'performance_schema');"
        try {
            $systemTablePrivileges = Invoke-Expression "$mysqlCmd `"$query`""
            if (-not $systemTablePrivileges) {
                Add-Result "OK: No unnecessary system table access permissions exist."
            } else {
                Add-Result "WARN: The following users have unnecessary system table access permissions: `n$systemTablePrivileges"
            }
        } catch {
            Add-Result "Error: Could not execute MySQL command."
        }
    }
    "2" {
        # PostgreSQL check
        $psqlCmd = "psql -U $dbUser -c"
        $query = "SELECT grantee, table_schema, privilege_type FROM information_schema.role_table_grants WHERE table_schema = 'pg_catalog';"
        try {
            $systemTablePrivileges = & psql -U $dbUser -c $query -h localhost | Out-String
            if ($systemTablePrivileges -match "grantee") {
                Add-Result "WARN: The following users have unnecessary system table access permissions: `n$systemTablePrivileges"
            } else {
                Add-Result "OK: No unnecessary system table access permissions exist."
            }
        } catch {
            Add-Result "Error: Could not execute PostgreSQL command."
        }
    }
    default {
        Add-Result "Unsupported database type."
    }
}

# Output the result
$result | ForEach-Object { Write-Host $_ }


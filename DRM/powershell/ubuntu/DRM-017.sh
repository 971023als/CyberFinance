# PowerShell script for checking unnecessary system table access permissions in MSSQL

# Define a function to execute a SQL query using Invoke-Sqlcmd
function Invoke-SqlQuery {
    param (
        [string]$Query,
        [string]$DatabaseUser,
        [string]$DatabasePassword,
        [string]$Database,
        [string]$ServerInstance = "localhost"
    )
    
    $ConnectionString = "Server=$ServerInstance;User ID=$DatabaseUser;Password=$DatabasePassword;Database=$Database;"
    Invoke-Sqlcmd -Query $Query -ConnectionString $ConnectionString
}

# Ask user for database type
Write-Host "Supported databases: 1. MySQL 2. PostgreSQL 3. MSSQL"
$dbType = Read-Host "Enter the number corresponding to your database type"

# Ask user for database credentials
$dbUser = Read-Host "Enter the database username"
$dbPass = Read-Host "Enter the database password" -AsSecureString
$dbPassPlain = [System.Net.NetworkCredential]::new("", $dbPass).Password

# Placeholder for result accumulation
$results = @()

# Check for unnecessary system table access permissions based on the selected database type
switch ($dbType) {
    "3" {
        # MSSQL check
        $Database = "master" # Change as necessary
        $ServerInstance = "localhost" # Change as necessary if your SQL Server is not on localhost
        
        $Query = @"
SELECT dp.name AS Grantee, 
       dp.type_desc AS GranteeType, 
       OBJECT_NAME(major_id) AS Object, 
       permission_name AS PermissionType
FROM sys.database_permissions AS perm
INNER JOIN sys.database_principals AS dp ON perm.grantee_principal_id = dp.principal_id
WHERE perm.class = 1 AND OBJECT_NAME(major_id) IN ('sysobjects', 'syscolumns', 'sysusers') -- Adjust object names as necessary
"@        
        try {
            $systemTablePrivileges = Invoke-SqlQuery -Query $Query -DatabaseUser $dbUser -DatabasePassword $dbPassPlain -Database $Database -ServerInstance $ServerInstance
            if ($systemTablePrivileges) {
                $results += "WARN: The following users have unnecessary system table access permissions:`n$($systemTablePrivileges | Out-String)"
            } else {
                $results += "OK: No unnecessary system table access permissions exist."
            }
        } catch {
            $results += "Error: Could not execute MSSQL command. Exception: $_"
        }
    }
    # Include cases for "1" and "2" to handle MySQL and PostgreSQL, similar to the initial script part
    default {
        $results += "Unsupported database type."
    }
}

# Output the results
$results | ForEach-Object { Write-Host $_ }

# Function to execute SQL query and return results
function Invoke-SqlQuery {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPass,
        [string]$Query
    )
    switch ($DBType) {
        "1" { # MySQL
            $ConnectionString = "server=localhost;user=$DBUser;password=$DBPass;database=mysql;"
            $Query = "SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
            $MySQLCommand = "mysql -u $DBUser -p$DBPass -Bse `"$Query`""
            return Invoke-Expression $MySQLCommand
        }
        "2" { # PostgreSQL
            $ConnectionString = "Host=localhost;Username=$DBUser;Password=$DBPass;Database=postgres;"
            $Query = "SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
            $PGSQLCommand = "psql -U $DBUser -c `"$Query`""
            return Invoke-Expression $PGSQLCommand
        }
        "3" { # Oracle
            Write-Host "Oracle support not implemented in this script."
            return $null
        }
        Default {
            Write-Host "Unsupported database type."
            return $null
        }
    }
}

# Prompt user for database type
Write-Host "Supported Databases: 1. MySQL 2. PostgreSQL 3. Oracle"
$DBType = Read-Host "Enter the number for your database type"
$DBUser = Read-Host "Enter database username"
$DBPass = Read-Host -AsSecureString "Enter database password" # Note: Handling passwords as secure string for demonstration, conversion needed for actual use
$DBPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass))

# Placeholder query, actual query will be set in the function based on DB type
$Query = ""

# Execute query and check privileges
$GrantOptionPrivileges = Invoke-SqlQuery -DBType $DBType -DBUser $DBUser -DBPass $DBPass -Query $Query

# Check if any unnecessary privileges are found
if ($null -ne $GrantOptionPrivileges -and $GrantOptionPrivileges.Count -gt 0) {
    Write-Warning "The following privileges are granted with 'WITH GRANT OPTION' unnecessarily:"
    $GrantOptionPrivileges
} else {
    Write-Host "No unnecessary privileges are granted with 'WITH GRANT OPTION'."
}

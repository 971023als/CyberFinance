# Prompt user for database type, including SQL Server
Write-Host "Supported Databases: 1. MySQL 2. PostgreSQL 3. Oracle 4. SQL Server"
$DBType = Read-Host "Enter the number for your database type"

# Variables for database credentials remain the same
$DBUser = Read-Host "Enter database username"
$DBPass = Read-Host -AsSecureString "Enter database password" # Secure password handling

# Convert SecureString password back to plain text for this example
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass)
$DBPassPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

function Check-DatabaseVersion {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPassPlainText
    )
    
    switch ($DBType) {
        # MySQL and PostgreSQL checks remain the same
        
        "4" { # SQL Server
            # Assuming sqlcmd is available in the path
            $VersionQuery = "SELECT @@VERSION;"
            $Version = sqlcmd -S localhost -U $DBUser -P $DBPassPlainText -Q $VersionQuery |
                       Where-Object {$_ -notmatch "rows affected"} |
                       Select-Object -First 1
            # Example check (simplified for demonstration)
            if ($Version -like "*SQL Server 2008*") {
                Write-Warning "SQL Server version is End-of-Support."
            } else {
                Write-Host "Current SQL Server version is supported."
            }
        }
        
        # Oracle and default cases remain the same
    }
}

# Invoke the version check function
Check-DatabaseVersion -DBType $DBType -DBUser $DBUser -DBPassPlainText $DBPassPlainText

# Prompt user for database type
Write-Host "Supported Databases: 1. MySQL 2. PostgreSQL 3. Oracle"
$DBType = Read-Host "Enter the number for your database type"

# Variables for database credentials
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
        "1" { # MySQL
            $VersionQuery = "SELECT VERSION();"
            $Version = mysql -u $DBUser -p$DBPassPlainText -e $VersionQuery | Where-Object {$_ -notmatch "VERSION"}
            # Example check
            if ($Version -like "5.6.*") {
                Write-Warning "MySQL version $Version is End-of-Support."
            } else {
                Write-Host "Current MySQL version $Version is supported."
            }
        }
        "2" { # PostgreSQL
            $VersionQuery = "SELECT version();"
            $Version = psql -U $DBUser -c $VersionQuery | Where-Object {$_ -match "PostgreSQL"} | ForEach-Object {$_ -split " "} | Select-Object -Index 1
            # Example check
            if ($Version -like "9.4.*") {
                Write-Warning "PostgreSQL version $Version is End-of-Support."
            } else {
                Write-Host "Current PostgreSQL version $Version is supported."
            }
        }
        "3" { # Oracle
            Write-Host "Oracle database version check needs to be implemented based on specific environment."
        }
        Default {
            Write-Host "Unsupported database type."
        }
    }
}

# Invoke the version check function
Check-DatabaseVersion -DBType $DBType -DBUser $DBUser -DBPassPlainText $DBPassPlainText

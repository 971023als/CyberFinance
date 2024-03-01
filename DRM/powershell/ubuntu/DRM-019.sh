# PowerShell Script for Checking Password Reuse Prevention Settings

# Define variables
$dbType = Read-Host "Supported databases: 1. MySQL, 2. PostgreSQL. Enter the type of your database"
$dbUser = Read-Host "Enter the database username"
$dbPass = Read-Host "Enter the database password" -AsSecureString
$convertedPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPass))

# Define function to execute database command
function Execute-DbCommand {
    param (
        [string]$dbType,
        [string]$dbUser,
        [string]$dbPass,
        [string]$query
    )
    switch ($dbType) {
        "1" {
            # MySQL command
            $query = "SELECT VARIABLE_VALUE FROM information_schema.global_variables WHERE VARIABLE_NAME = 'validate_password_history';"
            $command = "mysql -u $dbUser -p$dbPass -e `"$query`""
            Invoke-Expression $command
        }
        "2" {
            # PostgreSQL command
            $query = "SHOW password_encryption;"
            $command = "psql -U $dbUser -c `"$query`""
            Invoke-Expression $command
        }
        default {
            Write-Host "Unsupported database type."
            exit
        }
    }
}

# Execute command based on database type
$passwordReusePolicy = Execute-DbCommand -dbType $dbType -dbUser $dbUser -dbPass $convertedPass -query $query

# Check and display the policy settings
if ([string]::IsNullOrWhiteSpace($passwordReusePolicy)) {
    Write-Host "WARN: Password reuse prevention setting is not configured."
} else {
    $passwordHistory = $passwordReusePolicy -split "\r\n" | Where-Object { $_ -ne '' } | Select-Object -Last 1
    if ($dbType -eq "1" -and $passwordHistory -ge 1) {
        Write-Host "OK: MySQL password reuse prevention is correctly set to $passwordHistory history."
    } elseif ($dbType -eq "2") {
        Write-Host "OK: PostgreSQL password reuse prevention policy needs to be verified."
    } else {
        Write-Host "WARN: Password reuse prevention setting is present but may not be sufficient: $passwordHistory history."
    }
}

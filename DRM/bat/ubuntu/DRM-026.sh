# Function to execute a remote command via SSH (placeholder, adjust accordingly)
function Invoke-SSHCommand {
    param (
        [string]$Server,
        [string]$Username,
        [string]$Password, # Consider using SecureString and a more secure method in production
        [string]$Command
    )
    # Placeholder for SSH command execution
    # You would replace this with your actual SSH execution code, e.g., using Posh-SSH or similar
    Write-Host "Executing SSH Command on $Server"
}

# Main script
Write-Host "Supported Databases: 1. MySQL 2. PostgreSQL 3. Oracle"
$DBType = Read-Host "Enter the number for your database type"

# Setting the database service account based on DB type
$DatabaseServiceAccount = switch ($DBType) {
    "1" { "mysql" }
    "2" { "postgres" }
    "3" { "oracle" }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

$ExpectedUmask = "027"

# Assuming remote Linux/Unix environment for simplicity
$Server = Read-Host "Enter the server address"
$Username = Read-Host "Enter your SSH username"
$Password = Read-Host "Enter your SSH password" # Consider using SecureString in production

# Command to check umask value
$Command = "su - $DatabaseServiceAccount -c umask"

# Execute the remote command
$UmaskValue = Invoke-SSHCommand -Server $Server -Username $Username -Password $Password -Command $Command

if ($UmaskValue -eq $ExpectedUmask) {
    Write-Host "Database service account ($DatabaseServiceAccount) has the correct umask value ($ExpectedUmask)."
} else {
    Write-Host "Database service account ($DatabaseServiceAccount)'s umask value ($UmaskValue) does not meet the expected ($ExpectedUmask)."
}

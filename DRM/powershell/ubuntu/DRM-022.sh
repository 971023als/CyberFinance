# Define the list of critical files for MySQL, Oracle, PostgreSQL, and SQL Server
# Adjust the paths according to your environment
$filesToCheck = @{
    "1" = "C:\ProgramData\MySQL\MySQL Server X.X\my.ini" # Update X.X with your MySQL version
    "2" = "C:\app\oracle\product\11.2.0\dbhome_1\network\admin\listener.ora"
    "3" = "C:\Program Files\PostgreSQL\X.X\data\postgresql.conf" # Update X.X with your PostgreSQL version
    "4" = "C:\Program Files\Microsoft SQL Server\MSSQLXX.MSSQLSERVER\MSSQL\Binn\sqlservr.ini" # Update XX with your SQL Server version
}

# Prompt user for database choice
Write-Host "Supported Databases: 1. MySQL 2. Oracle 3. PostgreSQL 4. SQL Server"
$DB_CHOICE = Read-Host "Enter the number of your database"

if (-not $filesToCheck.ContainsKey($DB_CHOICE)) {
    Write-Host "Invalid selection."
    exit
}

# Get the file to check based on user choice
$fileToCheck = $filesToCheck[$DB_CHOICE]

# Check if file exists
if (Test-Path $fileToCheck) {
    # Get file ACL
    $fileACL = Get-Acl $fileToCheck
    $ownerPermissions = $fileACL.Access | Where-Object { $_.FileSystemRights -match "FullControl|Modify|ReadAndExecute|Read|Write" -and $_.IdentityReference -eq $fileACL.Owner }

    # Check if permissions are more permissive than "Read and Write" for the owner only
    if ($ownerPermissions -ne $null -and $ownerPermissions.Count -gt 1) {
        Write-Host "File $fileToCheck has insecure permissions: $($ownerPermissions.FileSystemRights)"
    } else {
        Write-Host "File $fileToCheck has secure permissions."
    }
} else {
    Write-Host "File $fileToCheck does not exist"
}

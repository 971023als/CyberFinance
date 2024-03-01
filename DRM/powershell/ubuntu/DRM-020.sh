# Define function to prompt for secure password
function Read-SecurePassword {
    $securePassword = Read-Host "Enter the database administrator password" -AsSecureString
    return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# Prompt for database information
$dbType = Read-Host "Supported databases: MySQL, PostgreSQL. Enter the type of your database"
$dbUser = Read-Host "Enter the database administrator username"
$dbPass = Read-SecurePassword

# Define and execute database command based on the database type
if ($dbType -eq "MySQL") {
    $query = "SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv FROM mysql.db;"
    $command = "mysql -u $dbUser -p$dbPass -e `"$query`""
    Invoke-Expression $command
}
elseif ($dbType -eq "PostgreSQL") {
    $query = "SELECT rolname, rolselectpriv, rolinsertpriv, rolupdatepriv FROM pg_roles JOIN pg_database ON (rolname = datname);"
    $command = "psql -U $dbUser -c `"$query`""
    Invoke-Expression $command
}
else {
    Write-Host "Unsupported database type."
    exit
}

# Note: Direct execution of database commands in PowerShell using Invoke-Expression with concatenated strings is a security risk similar to SQL injection.
# It's recommended to use parameterized queries or stored procedures to mitigate this risk.

# The above example demonstrates how to execute database-specific commands in PowerShell.
# The actual execution and results parsing will require adjustments based on your database setup and security policies.

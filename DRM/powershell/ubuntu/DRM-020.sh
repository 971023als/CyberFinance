# Define function to prompt for secure password
function Read-SecurePassword {
    $securePassword = Read-Host "Enter the database administrator password" -AsSecureString
    return $securePassword
}

# Import SQLServer module
Import-Module SqlServer

# Prompt for database information
$dbType = Read-Host "Supported databases: 1. MySQL, 2. PostgreSQL, 3. SQL Server. Enter the number corresponding to your database type"
$dbUser = Read-Host "Enter the database administrator username"
$dbPass = Read-SecurePassword

# Define and execute database command based on the database type
switch ($dbType) {
    "1" { # MySQL
        $query = "SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv FROM mysql.db;"
        # For MySQL, you might use a .NET connector or call a command-line tool
        Write-Host "MySQL command execution not implemented in this script. Please use a MySQL client."
    }
    "2" { # PostgreSQL
        $query = "SELECT rolname, rolselectpriv, rolinsertpriv, rolupdatepriv FROM pg_roles JOIN pg_database ON (rolname = datname);"
        # For PostgreSQL, psql or a .NET connector could be used
        Write-Host "PostgreSQL command execution not implemented in this script. Please use psql or a .NET connector."
    }
    "3" { # SQL Server
        $secureStringPassword = Read-SecurePassword
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStringPassword))
        $sqlCredential = New-Object System.Management.Automation.PSCredential ($dbUser, $secureStringPassword)

        $query = "SELECT name, is_disabled FROM sys.sql_logins"
        Invoke-Sqlcmd -Query $query -Username $dbUser -Password $plainPassword -ServerInstance "YourServerInstanceName" # Adjust ServerInstance as necessary
    }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

# Note: For SQL Server, using Invoke-Sqlcmd with a PSCredential object is a secure way to handle passwords.
# Ensure to replace "YourServerInstanceName" with your actual SQL Server instance name.
# This script assumes SQL Server PowerShell module (SqlServer) is installed and available.

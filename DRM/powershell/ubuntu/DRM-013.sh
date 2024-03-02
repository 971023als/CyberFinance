# Define helper functions
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

function Warn {
    param($message)
    Write-Host "WARNING: $message"
}

function OK {
    param($message)
    Write-Host "OK: $message"
}

# Script start
Write-Bar
Write-Code "DBM-013] 원격 접속에 대한 접근 제어 미흡 for MSSQL"

# Use SQL Server authentication or integrated security as per your setup
$SQLServer = "YourSqlServerInstance" # Update this with your server/instance name
$SQLDBUser = "YourDbUsername" # Only needed if using SQL Server Authentication
$SQLDBPass = "YourDbPassword" # Only needed if using SQL Server Authentication
$Database = "master" # Default to master database or specify as needed

# Using SQL Server Authentication
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$SQLServer; Database=$Database; User ID=$SQLDBUser; Password=$SQLDBPass;"

# Or, for Windows Authentication (Integrated Security)
# $SqlConnection.ConnectionString = "Server=$SQLServer; Database=$Database; Integrated Security=True;"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT name FROM sys.server_principals WHERE type_desc = 'SQL_LOGIN' AND is_disabled = 0;"
$SqlCmd.Connection = $SqlConnection

try {
    $SqlConnection.Open()
    $reader = $SqlCmd.ExecuteReader()
    if ($reader.HasRows) {
        while ($reader.Read()) {
            $name = $reader["name"]
            # Modify the condition to fit your requirements for identifying remote access control issues
            Warn "Active SQL Server login found: $name"
        }
    } else {
        OK "No active SQL Server logins found."
    }
}
catch {
    Warn "Error accessing SQL Server: $_"
}
finally {
    $SqlConnection.Close()
}

Write-Bar

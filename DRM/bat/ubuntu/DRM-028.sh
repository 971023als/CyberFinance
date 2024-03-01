# PowerShell Version

# Ask user for database type
$DBType = Read-Host "Enter the number for your database type (1. MySQL, 2. PostgreSQL, 3. Oracle)"
$DBUser = Read-Host "Enter database username"
$DBPass = Read-Host "Enter database password" -AsSecureString

# Function to check unnecessary database objects
function Check-UnnecessaryDBObjects {
    param (
        [string]$Query,
        [string]$DBType,
        [string]$DBUser,
        [PSCredential]$Credential
    )

    # Placeholder connection string, adjust according to your environment
    $ConnectionString = ""

    switch ($DBType) {
        "1" { # MySQL
            $ConnectionString = "server=localhost;port=3306;uid=$DBUser;pwd=$($Credential.GetNetworkCredential().password);"
            # Assuming MySql.Data is available
            # Install the module or .NET assembly if necessary
            [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
            $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
            $Connection.ConnectionString = $ConnectionString
            $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
        }
        "2" { # PostgreSQL
            $ConnectionString = "Host=localhost;Port=5432;Username=$DBUser;Password=$($Credential.GetNetworkCredential().password);"
            # Assuming PSPgSql is available
            # Install the module or .NET assembly if necessary
            [void][System.Reflection.Assembly]::LoadWithPartialName("Npgsql")
            $Connection = New-Object Npgsql.NpgsqlConnection
            $Connection.ConnectionString = $ConnectionString
            $Command = New-Object Npgsql.NpgsqlCommand($Query, $Connection)
        }
        "3" { # Oracle
            Write-Host "Oracle database checks need to be performed with appropriate Oracle .NET connectivity tools."
            return
        }
    }

    try {
        $Connection.Open()
        $Reader = $Command.ExecuteReader()
        while ($Reader.Read()) {
            $ObjectName = $Reader.GetString(0) # Assuming the object name is in the first column
            Write-Host "Checking object: $ObjectName"
            # Add logic to determine if the object is unnecessary
        }
    }
    catch {
        Write-Host "Error connecting to database: $_"
    }
    finally {
        $Connection.Close()
    }
}

# Define your query to list database objects here
$Query = switch ($DBType) {
    "1" { "SHOW TABLES;" }
    "2" { "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';" }
    "3" { "SELECT table_name FROM user_tables;" }
}

# Convert password to PSCredential
$Credential = New-Object System.Management.Automation.PSCredential ($DBUser, $DBPass)

# Call the function
Check-UnnecessaryDBObjects -Query $Query -DBType $DBType -DBUser $DBUser -Credential $Credential

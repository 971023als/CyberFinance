# Define database credentials
$DBType = Read-Host "Enter your database type (1. MySQL, 2. PostgreSQL, 3. Oracle, 4. SQL Server)"
$DBUser = Read-Host "Enter database username"
$DBPass = Read-Host "Enter database password" -AsSecureString
$DBHost = "localhost" # Update as needed

# Convert SecureString password to plain text
$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Ptr)

function Check-ResourceLimits {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPass,
        [string]$DBHost
    )

    switch ($DBType) {
        "1" { # MySQL
            # MySQL specific connection and query execution logic
        }
        "2" { # PostgreSQL
            # PostgreSQL specific connection and query execution logic
        }
        "3" { # Oracle
            # Oracle specific connection and query execution logic
        }
        "4" { # SQL Server
            $ConnectionString = "Data Source=$DBHost;Initial Catalog=master;User ID=$DBUser;Password=$DBPass;"
            $Query = "SELECT value_in_use FROM sys.configurations WHERE name = 'max degree of parallelism';"
            Try {
                $Connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
                $Connection.Open()
                $Command = $Connection.CreateCommand()
                $Command.CommandText = $Query
                $Result = $Command.ExecuteScalar()
                Write-Host "SQL Server maximum degree of parallelism is set to: $Result"
            }
            Catch {
                Write-Host "Error in SQL Server query execution: $_"
            }
            Finally {
                $Connection.Close()
            }
        }
        default {
            Write-Host "Unsupported database type."
        }
    }
}

# Calling the function to check resource limits
Check-ResourceLimits -DBType $DBType -DBUser $DBUser -DBPass $PlainPassword -DBHost $DBHost

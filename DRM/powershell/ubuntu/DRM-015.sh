function Invoke-SqlQuery {
    param (
        [string]$ServerInstance,
        [string]$Database,
        [PSCredential]$Credential,
        [string]$Query
    )
    $ConnectionString = "Server=$ServerInstance; Database=$Database; Integrated Security=True;"
    if ($Credential) {
        $ConnectionString = "Server=$ServerInstance; Database=$Database; User ID=$($Credential.UserName); Password=$($Credential.GetNetworkCredential().Password);"
    }
    $Connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
    $Command = $Connection.CreateCommand()
    $Command.CommandText = $Query
    $Connection.Open()
    $Result = $Command.ExecuteScalar()
    $Connection.Close()
    return $Result
}

function Check-PublicRolePrivileges {
    param (
        [string]$DBType,
        [string]$ServerInstance,
        [PSCredential]$Credential = $null,
        [string]$Database = "master"
    )

    if ($DBType -eq "MSSQL") {
        $QueryDatabaseLevel = "SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('public')"
        $QueryServerLevel = "SELECT COUNT(*) FROM sys.server_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('public')"
        $DatabaseLevelPrivileges = Invoke-SqlQuery -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $QueryDatabaseLevel
        $ServerLevelPrivileges = Invoke-SqlQuery -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $QueryServerLevel
        
        if ($DatabaseLevelPrivileges -eq 0 -and $ServerLevelPrivileges -eq 0) {
            Write-Host "OK: No unnecessary privileges granted to PUBLIC role at both database and server levels."
        } else {
            Write-Host "WARNING: Unnecessary privileges are granted to PUBLIC role. Please review database and server level permissions."
        }
    } else {
        Write-Host "Unsupported database type for this script."
    }
}

# Main script starts here
$DBType = Read-Host "Enter the type of your database (MSSQL)"
$ServerInstance = Read-Host "Enter SQL Server instance (e.g., ServerName\\InstanceName)"
$Credential = Get-Credential -Message "Enter SQL Server admin credentials"

Check-PublicRolePrivileges -DBType $DBType -ServerInstance $ServerInstance -Credential $Credential

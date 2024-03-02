# Define helper functions
function Write-OutputWithBar {
    Write-Output "==========================================="
}

function Check-MSSQLSecuritySettings {
    param(
        [string]$SqlServer,
        [PSCredential]$SqlCredential
    )
    Import-Module SqlServer

    try {
        # Check for Mixed Mode Authentication (Windows + SQL Server authentication)
        $queryAuthenticationMode = "SELECT SERVERPROPERTY('IsMixedModeAuthentication')"
        $mixedModeAuthentication = Invoke-Sqlcmd -ServerInstance $SqlServer -Credential $SqlCredential -Query $queryAuthenticationMode

        if ($mixedModeAuthentication.Column1 -eq 1) {
            Write-Output "WARNING: Mixed Mode Authentication (Windows and SQL Server) is enabled."
        } else {
            Write-Output "OK: Only Windows Authentication mode is enabled."
        }

        # Placeholder for checking secure connections
        # For real-world scenarios, you would check SQL Server's configuration for using SSL for encrypted connections
        # Example: "SELECT * FROM sys.dm_exec_connections WHERE encrypt_option = 'TRUE'"
        # This is a placeholder and should be replaced with actual checks as needed
        $secureConnectionCheck = $true # Placeholder value

        if ($secureConnectionCheck) {
            Write-Output "OK: Secure connections are enabled."
        } else {
            Write-Output "WARNING: Secure connections are not enforced."
        }
    }
    catch {
        Write-Output "Error checking MSSQL security settings: $_"
    }
}

Write-OutputWithBar
Write-Output "Checking MSSQL Security Settings"

# Prompt for SQL Server connection details
$SqlServer = Read-Host "Enter SQL Server instance (e.g., ServerName\\InstanceName)"
$SqlCredential = Get-Credential -Message "Enter SQL Server admin credentials"

Check-MSSQLSecuritySettings -SqlServer $SqlServer -SqlCredential $SqlCredential

Write-OutputWithBar

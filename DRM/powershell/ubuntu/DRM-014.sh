# Define helper functions
function Write-OutputWithBar {
    Write-Output "==========================================="
}

function Check-OracleRoles {
    param(
        [string]$OracleUser,
        [string]$OraclePass,
        [string]$OracleDB
    )
    $sqlPlusCmd = "sqlplus -s /nolog"
    $connectCmd = "CONNECT $OracleUser/$OraclePass@$OracleDB"
    $osRolesQuery = "SELECT value FROM v\$parameter WHERE name = 'os_roles';"
    $remoteOsRolesQuery = "SELECT value FROM v\$parameter WHERE name = 'remote_os_roles';"
    
    $scriptBlock = @"
        $connectCmd
        SET HEADING OFF;
        SET FEEDBACK OFF;
        $osRolesQuery
        EXIT;
"@
    
    $osRolesResult = Invoke-Expression "$sqlPlusCmd | echo $scriptBlock"
    $osRolesDisabled = $osRolesResult -contains "FALSE"
    
    $scriptBlockRemote = @"
        $connectCmd
        SET HEADING OFF;
        SET FEEDBACK OFF;
        $remoteOsRolesQuery
        EXIT;
"@
    
    $remoteOsRolesResult = Invoke-Expression "$sqlPlusCmd | echo $scriptBlockRemote"
    $remoteOsRolesDisabled = $remoteOsRolesResult -contains "FALSE"

    if ($osRolesDisabled -and $remoteOsRolesDisabled) {
        Write-Output "OK: OS_ROLES 및 REMOTE_OS_ROLES 기능이 안전하게 비활성화되어 있습니다."
    } else {
        Write-Output "WARNING: OS_ROLES 또는 REMOTE_OS_ROLES 기능이 활성화되어 있어 취약할 수 있습니다."
    }
}

Write-OutputWithBar
Write-Output "CODE [DBM-014] 취약한 운영체제 역할 인증 기능(OS_ROLES, REMOTE_OS_ROLES) 사용"

# Prompt for Oracle DB user information
$OracleUser = Read-Host "Enter Oracle DB username"
$OraclePass = Read-Host "Enter Oracle DB password" -AsSecureString
$OraclePass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($OraclePass))
$OracleDB = Read-Host "Enter Oracle DB connection string (e.g., //host:port/sid)"

Check-OracleRoles -OracleUser $OracleUser -OraclePass $OraclePass -OracleDB $OracleDB

Write-OutputWithBar

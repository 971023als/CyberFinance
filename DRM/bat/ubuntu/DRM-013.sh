# Define helper functions
function Write-Bar {
    Write-Output "============================================"
}

function Write-Code {
    param($code)
    Write-Output "CODE [$code]"
}

function Warn {
    param($message)
    Write-Output "WARNING: $message"
}

function OK {
    param($message)
    Write-Output "OK: $message"
}

# Script start
Write-Bar
Write-Code "DBM-013] 원격 접속에 대한 접근 제어 미흡"

# Prompt for database type
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL. 사용 중인 데이터베이스 유형을 입력하세요"

if ($DB_TYPE -eq "MySQL" -or $DB_TYPE -eq "mysql") {
    $MYSQL_USER = Read-Host "Enter MySQL username"
    $MYSQL_PASS = Read-Host "Enter MySQL password" -AsSecureString
    $MYSQL_PASS = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MYSQL_PASS))

    # MySQL command to check remote access users
    $Query = "SELECT host, user FROM mysql.user WHERE host NOT IN ('localhost', '127.0.0.1', '::1');"
    $results = Invoke-MySqlQuery -Query $Query -Username $MYSQL_USER -Password $MYSQL_PASS
    foreach ($row in $results) {
        if ($row.user -ne $null) {
            Warn "원격 호스트($($row.host))에서 접근 가능한 사용자가 있습니다: $($row.user)"
        }
    }
} elseif ($DB_TYPE -eq "PostgreSQL" -or $DB_TYPE -eq "postgresql") {
    $PG_HBA = Read-Host "Enter path to pg_hba.conf"
    if (Test-Path $PG_HBA) {
        $content = Get-Content $PG_HBA
        if ($content -match "host") {
            Warn "pg_hba.conf 파일에 원격 호스트 접근을 허용하는 설정이 있습니다."
        } else {
            OK "pg_hba.conf 파일이 원격 접속을 제한하고 있습니다."
        }
    } else {
        Warn "pg_hba.conf 파일을 찾을 수 없습니다."
    }
} else {
    Write-Output "Unsupported database type."
    exit
}

# PowerShell does not have a direct equivalent of iptables. Network level access controls need to be checked differently, perhaps via Windows Firewall or by inspecting network security group rules in cloud environments.
# This part would need adaptation based on the specific environment and is not directly translatable from iptables.

Write-Bar

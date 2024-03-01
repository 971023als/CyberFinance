# 사용자로부터 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: 1. SQL Server 2. MySQL 3. PostgreSQL. 사용 중인 데이터베이스 유형을 선택하세요 (1-3)"
$DB_ADMIN = Read-Host "데이터베이스 관리자 계정을 입력하세요"
$DB_PASS = Read-Host "데이터베이스 관리자 비밀번호를 입력하세요" -AsSecureString

# 데이터베이스 유형에 따른 명령 실행
switch ($DB_TYPE) {
    "1" {
        # SQL Server
        $QUERY = "SELECT * FROM sys.sql_logins WHERE name = 'sa';"
        # SQLCMD 실행을 위한 PowerShell 명령 준비
        $CMD = "sqlcmd -U $DB_ADMIN -P $($DB_PASS | ConvertFrom-SecureString -AsPlainText) -Q `"$QUERY`""
    }
    "2" {
        # MySQL
        $QUERY = "SELECT User, Host FROM mysql.user WHERE User = 'root';"
        # MySQL 명령 실행
        $CMD = "mysql -u $DB_ADMIN -p$($DB_PASS | ConvertFrom-SecureString -AsPlainText) -e `"$QUERY`""
    }
    "3" {
        # PostgreSQL
        $QUERY = "SELECT rolname FROM pg_roles WHERE rolname = 'postgres';"
        # PSQL 명령 실행
        $CMD = "psql -U $DB_ADMIN -c `"$QUERY`""
    }
    default {
        Write-Host "Unsupported database type."
        exit
    }
}

# 관리자 계정의 보안 설정 확인
try {
    $ADMIN_SECURITY_SETTINGS = Invoke-Expression $CMD
    if ($ADMIN_SECURITY_SETTINGS) {
        Write-Host "관리자 계정의 보안 설정이 적절합니다: $ADMIN_SECURITY_SETTINGS"
    } else {
        Write-Host "관리자 계정의 보안 설정이 미흡합니다."
    }
} catch {
    Write-Host "관리자 계정 보안 설정 검사 중 오류가 발생했습니다."
}

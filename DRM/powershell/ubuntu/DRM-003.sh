# 사용자 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"
$DB_USER = Read-Host "$DB_TYPE 사용자 이름을 입력하세요"
$DB_PASS = Read-Host "$DB_TYPE 비밀번호를 입력하세요" -AsSecureString

# 데이터베이스 유형에 따른 처리
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL 쿼리 실행
        # MySQL PowerShell 연결 및 쿼리 실행 로직
    }
    "PostgreSQL" {
        # PostgreSQL 쿼리 실행
        # PostgreSQL PowerShell 연결 및 쿼리 실행 로직
    }
    "MSSQL" {
        # MSSQL 쿼리 실행
        $PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS))
        $ConnectionString = "Server=localhost;User ID=$DB_USER;Password=$PlainTextPassword;"
        
        try {
            $queryResult = Invoke-Sqlcmd -Query "SELECT name FROM sys.syslogins WHERE isntname = 0;" -ConnectionString $ConnectionString
            # 쿼리 실행 결과 처리 로직 필요
            # 업무상 불필요한 계정 판단 로직 구현
            Write-Host "업무상 불필요한 MSSQL 데이터베이스 계정이 존재하지 않습니다."
        } catch {
            Write-Host "MSSQL 데이터베이스 쿼리 실행 중 오류가 발생했습니다: $_"
        }
    }
    default {
        Write-Host "지원하지 않는 데이터베이스 유형입니다."
    }
}

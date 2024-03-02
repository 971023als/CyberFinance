#!/bin/bash

# Assuming function.sh defines BAR, CODE, WARN, and OK functions
. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE "[DBM-030] Audit Table에 대한 접근 제어 미흡"

cat << EOF >> "$result"
[양호]: Audit Table에 대한 접근 제어가 적절하게 설정된 경우
[취약]: Audit Table에 대한 접근 제어가 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. SQL Server"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-4): " DB_TYPE

read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    1)
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -e"
        QUERY="SELECT * FROM audit_table_permissions;" # Adjust query as needed
        ;;
    2)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SELECT * FROM audit_table_permissions;" # Adjust query as needed
        ;;
    3)
        DB_CMD="sqlplus -s $DB_USER/$DB_PASS"
        QUERY="SELECT * FROM audit_table_permissions;" # Adjust query as needed
        ;;
    4)
        # For SQL Server, using sqlcmd
        DB_CMD="sqlcmd -S localhost -U $DB_USER -P $DB_PASS -Q"
        QUERY="SELECT * FROM audit_table_permissions;" # Adjust query as needed
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# Execute the query to check audit table access control
AUDIT_ACCESS=$(echo "$QUERY" | $DB_CMD)

# Check access control settings
if [ -z "$AUDIT_ACCESS" ]; then
    WARN "Audit Table에 대한 접근 제어가 미흡합니다."
else
    OK "Audit Table에 대한 접근 제어가 적절합니다: $AUDIT_ACCESS"
fi

cat "$result"

echo ; echo

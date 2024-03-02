#!/bin/bash

# Assuming function.sh defines BAR, WARN, OK, and other utility functions
. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

echo "CODE [DBM-005] 데이터베이스 내 중요정보 암호화 미적용"

cat << EOF >> $TMP1
[양호]: 중요 데이터가 암호화되어 있는 경우
[취약]: 중요 데이터가 암호화되어 있지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL, Oracle, MSSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        QUERY="SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != AES_DECRYPT(AES_ENCRYPT(your_field, 'your_key'), 'your_key')"
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL 암호화 확인 로직을 여기에 구현
        ;;
    Oracle|oracle)
        # Oracle 암호화 확인 로직을 여기에 구현
        ;;
    MSSQL|mssql)
        read -p "MSSQL 사용자 이름을 입력하세요: " MSSQL_USER
        read -sp "MSSQL 비밀번호를 입력하세요: " MSSQL_PASS
        echo
        MSSQL_CMD="sqlcmd -S server_name -U $MSSQL_USER -P $MSSQL_PASS -Q"
        QUERY="SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != DECRYPTBYKEY(ENCRYPTBYKEY(Key_GUID('Your_Key_Name'), your_field))"
        # Note: Adjust the SQL query according to your encryption setup in MSSQL
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 암호화 확인 로직 실행
if [ "$DB_TYPE" == "MySQL" ]; then
    ENCRYPTED_COUNT=$($MYSQL_CMD "$QUERY")
    if [ "$ENCRYPTED_COUNT" -gt 0 ]; then
        WARN "미암호화된 중요 데이터가 존재합니다."
    else
        OK "모든 중요 데이터가 암호화되어 있습니다."
    fi
elif [ "$DB_TYPE" == "PostgreSQL" ]; then
    # PostgreSQL 암호화 확인 로직 실행
    echo "PostgreSQL 암호화 확인 로직을 구현하세요."
elif [ "$DB_TYPE" == "Oracle" ]; then
    # Oracle 암호화 확인 로직 실행
    echo "Oracle 암호화 확인 로직을 구현하세요."
elif [ "$DB_TYPE" == "MSSQL" ]; then
    ENCRYPTED_COUNT=$($MSSQL_CMD "$QUERY")
    if [ "$ENCRYPTED_COUNT" -gt 0 ]; then
        WARN "미암호화된 중요 데이터가 존재합니다."
    else
        OK "모든 중요 데이터가 암호화되어 있습니다."
    fi
fi

cat $TMP1

echo ; echo

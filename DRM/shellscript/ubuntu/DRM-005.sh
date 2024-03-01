#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-005] 데이터베이스 내 중요정보 암호화 미적용

cat << EOF >> $result
[양호]: 중요 데이터가 암호화되어 있는 경우
[취약]: 중요 데이터가 암호화되어 있지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL에 대한 접속 정보 입력 요청 및 처리 방법
        # 이 부분은 PostgreSQL 접속 방법에 맞게 수정해야 합니다.
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

# 암호화 확인 로직
# 여기에서는 MySQL을 위한 예시입니다. PostgreSQL 등 다른 데이터베이스의 경우, 해당 데이터베이스의 암호화 함수를 사용해야 합니다.
if [ "$DB_TYPE" = "MySQL" ] || [ "$DB_TYPE" = "mysql" ]; then
    ENCRYPTED_COUNT=$($MYSQL_CMD "SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != AES_DECRYPT(AES_ENCRYPT(your_field, 'your_key'), 'your_key')")
    if [ "$ENCRYPTED_COUNT" -gt 0 ]; then
        WARN "미암호화된 중요 데이터가 존재합니다."
    else
        OK "모든 중요 데이터가 암호화되어 있습니다."
    fi
elif [ "$DB_TYPE" = "PostgreSQL" ] || [ "$DB_TYPE" = "postgresql" ]; then
    # PostgreSQL의 암호화 확인 로직 구현
    # PostgreSQL은 다른 암호화 함수를 사용할 수 있으며, 해당 로직은 PostgreSQL의 문법에 맞게 수정해야 합니다.
fi

cat $result

echo ; echo

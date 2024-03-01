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

# MySQL 명령 실행
MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

# 암호화 확인 로직 (예시)
# 여기에서는 'your_table'과 'your_field'를 암호화해야 하는 필드로 가정
ENCRYPTED_COUNT=$($MYSQL_CMD "SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != AES_DECRYPT(AES_ENCRYPT(your_field, 'your_key'), 'your_key')")

if [ "$ENCRYPTED_COUNT" -gt 0 ]; then
    WARN "미암호화된 중요 데이터가 존재합니다."
else
    OK "모든 중요 데이터가 암호화되어 있습니다."
fi

cat $result

echo ; echo

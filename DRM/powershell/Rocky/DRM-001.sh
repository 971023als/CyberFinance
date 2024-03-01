#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-001] 취약하게 설정된 비밀번호 존재

cat << EOF >> $result
[양호]: 모든 데이터베이스 계정의 비밀번호가 강력한 경우
[취약]: 하나 이상의 데이터베이스 계정에 취약한 비밀번호가 설정된 경우
EOF

BAR

# 사용자에게 MySQL 접속 정보 입력 요청
read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
echo

MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

$MYSQL_CMD "SELECT user, authentication_string FROM mysql.user" | while read user pass; do
    # 비밀번호 길이 및 특정 패턴 검사 (예: 최소 8자, 숫자 및 특수문자 포함)
    if ! [[ ${#pass} -ge 8 && "$pass" =~ [0-9] && "$pass" =~ [^a-zA-Z0-9] ]]; then
        WARN "$user 계정에 취약한 비밀번호가 설정되어 있습니다."
    fi
done

OK "모든 데이터베이스 계정의 비밀번호가 강력합니다."

cat $result

echo ; echo

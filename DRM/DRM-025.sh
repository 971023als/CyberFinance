#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용 확인

cat << EOF >> "$result"
[양호]: 현재 사용 중인 데이터베이스 버전이 지원되는 경우
[취약]: 현재 사용 중인 데이터베이스 버전이 서비스 지원 종료(EoS) 상태인 경우
EOF

BAR

# Example for MySQL
MYSQL_VERSION=$(mysql -u root -p'yourpassword' -e "SELECT VERSION();" | grep -v 'VERSION')

# You would replace this with a check against a known list of EoS versions.
# For example:
if [[ "$MYSQL_VERSION" == "5.6.40" ]]; then
    WARN "MySQL 버전 $MYSQL_VERSION 는 서비스 지원이 종료된 버전입니다."
else
    OK "현재 MySQL 버전은 지원되는 버전입니다."
fi

# Similar checks should be implemented for other database systems like Oracle, PostgreSQL, etc.

cat "$result"

echo ; echo

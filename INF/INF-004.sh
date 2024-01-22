#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-003] 업무상 불필요한 계정 존재

cat << EOF >> $result
[양호]: 업무상 불필요한 데이터베이스 계정이 존재하지 않는 경우
[취약]: 업무상 불필요한 데이터베이스 계정이 존재하는 경우
EOF

BAR

# MySQL 사용자 정보 입력
read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
echo

# MySQL 명령 실행
MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

# 모든 MySQL 사용자 계정 나열
echo "모든 MySQL 사용자 계정:"
$MYSQL_CMD "SELECT user FROM mysql.user"

echo

# 업무상 불필요한 계정 판단 로직 (예시: 마지막 로그인이 오래된 계정)
SIX_MONTHS_AGO=$(date --date='6 months ago' +%Y-%m-%d)
$MYSQL_CMD "SELECT user, MAX(last_login) FROM user_login_history GROUP BY user" | while read user last_login; do
    if [[ "$last_login" < "$SIX_MONTHS_AGO" ]]; then
        WARN "업무상 불필요한 데이터베이스 계정이 존재합니다: $user (마지막 로그인: $last_login)"
    fi
done

OK "업무상 불필요한 데이터베이스 계정이 존재하지 않습니다."

cat $result

echo ; echo

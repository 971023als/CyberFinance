#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-006] 로그인 실패 횟수에 따른 접속 제한 설정 미흡

cat << EOF >> $result
[양호]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있는 경우
[취약]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않은 경우
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
        # MySQL에 대한 로그인 실패 횟수 제한 설정 확인 로직
        FAILURE_LIMIT_SETTING=$($MYSQL_CMD "SHOW VARIABLES LIKE 'login_failure_limit'")
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL에 대한 로그인 실패 횟수 제한 설정 확인 로직
        # PostgreSQL 처리 로직은 여기에 구현
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

if [ -z "$FAILURE_LIMIT_SETTING" ]; then
    WARN "로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않습니다."
else
    OK "로그인 실패 횟수에 따른 접속 제한이 설정되어 있습니다."
fi

cat $result

echo ; echo

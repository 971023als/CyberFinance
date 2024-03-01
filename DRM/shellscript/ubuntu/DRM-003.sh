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

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        CHECK_CMD=$MYSQL_CMD
        QUERY="SELECT user FROM mysql.user"
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

echo "모든 사용자 계정:"
$CHECK_CMD "$QUERY"

# 업무상 불필요한 계정 판단 로직 구현
# 이 부분은 선택된 데이터베이스 유형에 맞게 적절한 쿼리를 실행해야 합니다.
# 예제에서는 MySQL의 마지막 로그인 날짜를 기준으로 판단합니다. PostgreSQL이나 다른 데이터베이스의 경우, 해당 로직을 데이터베이스의 쿼리 언어와 기능에 맞게 수정해야 합니다.

OK "업무상 불필요한 데이터베이스 계정이 존재하지 않습니다."

cat $result

echo ; echo

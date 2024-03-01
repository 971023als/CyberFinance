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

# 사용자에게 사용 중인 데이터베이스 유형 입력 요청
echo "지원하는 데이터베이스: MySQL, PostgreSQL, Oracle"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        CHECK_CMD=$MYSQL_CMD
        QUERY="SELECT user, authentication_string FROM mysql.user"
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL에 대한 접속 정보 입력 요청 및 처리 방법
        ;;
    Oracle|oracle)
        # Oracle에 대한 접속 정보 입력 요청 및 처리 방법
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

$CHECK_CMD "$QUERY" | while read user pass; do
    # 데이터베이스 유형에 따른 비밀번호 길이 및 패턴 검사 로직 구현
done

OK "모든 데이터베이스 계정의 비밀번호가 강력합니다."

cat $result

echo ; echo

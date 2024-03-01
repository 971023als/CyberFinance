#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-007] 비밀번호의 복잡도 정책 설정 미흡

cat << EOF >> $result
[양호]: 모든 사용자의 비밀번호 복잡도 정책이 적절하게 설정되어 있는 경우
[취약]: 하나 이상의 사용자의 비밀번호 복잡도 정책이 설정되어 있지 않은 경우
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
        QUERY="SELECT user, host, authentication_string FROM mysql.user"
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL에 대한 접속 정보 입력 요청 및 처리 방법
        # PostgreSQL의 경우, pg_shadow 또는 비슷한 테이블에서 비밀번호 정보를 검색
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

if [ "$DB_TYPE" = "MySQL" ] || [ "$DB_TYPE" = "mysql" ]; then
    # MySQL에 대한 비밀번호 복잡도 검사 로직
    $MYSQL_CMD "$QUERY" | while read user host authentication_string; do
        if [[ ${#authentication_string} -ge 8 ]] && \
           [[ $authentication_string =~ [A-Z] ]] && \
           [[ $authentication_string =~ [a-z] ]] && \
           [[ $authentication_string =~ [0-9] ]] && \
           [[ $authentication_string =~ [^a-zA-Z0-9] ]]; then
            OK "적절한 비밀번호 복잡도: $user@$host"
        else
            WARN "비밀번호 복잡도 정책이 미흡한 사용자: $user@$host"
        fi
    done
elif [ "$DB_TYPE" = "PostgreSQL" ] || [ "$DB_TYPE" = "postgresql" ]; then
    # PostgreSQL에 대한 비밀번호 복잡도 검사 로직
    # PostgreSQL의 비밀번호 복잡도를 검사하는 구체적인 쿼리와 로직을 여기에 구현해야 합니다.
    echo "PostgreSQL 비밀번호 복잡도 검사 로직 구현 필요"
fi

cat $result

echo ; echo

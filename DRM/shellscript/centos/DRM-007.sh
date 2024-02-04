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

# MySQL 사용자 정보 입력
read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
echo

# MySQL 명령 실행
MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

# 각 사용자의 비밀번호 설정 검사
$MYSQL_CMD "SELECT user, host, authentication_string FROM mysql.user" | while read user host authentication_string; do
    # 비밀번호 길이 및 패턴 검사
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

cat $result

echo ; echo

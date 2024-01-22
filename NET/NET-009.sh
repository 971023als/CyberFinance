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

# MySQL 명령 실행
MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

# 로그인 실패 횟수 제한 설정 확인
# 이 설정은 MySQL 기본 기능으로는 제공되지 않으므로, 보안 플러그인 또는 외부 도구의 설정을 검사해야 할 수 있음
# 예시 코드로, 실제로는 해당 환경에 맞게 수정 필요
FAILURE_LIMIT_SETTING=$($MYSQL_CMD "SHOW VARIABLES LIKE 'login_failure_limit'")

if [ -z "$FAILURE_LIMIT_SETTING" ]; then
    WARN "로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않습니다."
else
    OK "로그인 실패 횟수에 따른 접속 제한이 설정되어 있습니다."
fi

cat $result

echo ; echo

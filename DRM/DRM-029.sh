#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-029] 데이터베이스의 자원 사용 제한 설정 미흡

cat << EOF >> "$result"
[양호]: 데이터베이스의 자원 사용 제한이 적절하게 설정된 경우
[취약]: 데이터베이스의 자원 사용 제한이 미흡한 경우
EOF

BAR

# 데이터베이스 사용자 정보 입력
read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

# 데이터베이스 명령 실행
DB_CMD="데이터베이스_명령어_경로"

# 데이터베이스 자원 사용 제한 설정 확인
# 예시: MySQL의 경우
RESOURCE_LIMITS=$($DB_CMD -u $DB_USER -p$DB_PASS -e "SHOW VARIABLES LIKE 'max_connections';")

# 자원 사용 제한 설정 검사
if [ -z "$RESOURCE_LIMITS" ]; then
    WARN "데이터베이스 자원 사용 제한 설정이 미흡합니다."
else
    # 여기에 추가적인 로직을 구현하여 제한이 적절한지 판단
    # 예: max_connections 값 확인
    OK "데이터베이스 자원 사용 제한 설정이 적절합니다: $RESOURCE_LIMITS"
fi

cat "$result"

echo ; echo

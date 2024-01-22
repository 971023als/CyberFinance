#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-028] 업무상 불필요한 데이터베이스 오브젝트 존재 여부 확인

cat << EOF >> "$result"
[양호]: 불필요한 데이터베이스 오브젝트가 존재하지 않는 경우
[취약]: 불필요한 데이터베이스 오브젝트가 존재하는 경우
EOF

BAR

# 데이터베이스 사용자 정보 입력
read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

# 데이터베이스 명령 실행
DB_CMD="데이터베이스_명령어_경로"

# 데이터베이스 오브젝트 리스트 가져오기
DB_OBJECTS=$($DB_CMD -u $DB_USER -p$DB_PASS -e "데이터베이스 오브젝트 리스트 조회 쿼리")

# 불필요한 오브젝트 확인 로직 구현
# 여기에 코드 추가

cat "$result"

echo ; echo

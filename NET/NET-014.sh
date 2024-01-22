#!/bin/bash

# 함수 파일 source
. function.sh

# 임시 로그 파일 생성
TMP1=$(SCRIPTNAME).log
> $TMP1

# 로그 시작 구분선
BAR

# 주제 코드
CODE [DBM-008] 주기적인 비밀번호 변경 미흡

# 결과 내용을 결과 파일에 추가
cat << EOF >> $result
[양호]: 주기적인 비밀번호 변경 정책이 적절하게 설정되어 있는 경우
[취약]: 주기적인 비밀번호 변경 정책이 설정되어 있지 않은 경우
EOF

# 로그 끝 구분선
BAR

# MySQL 사용자 정보 입력 (이 부분은 사용자에게서 직접 입력받아야 함)
MYSQL_USER="root"
MYSQL_PASS="yourpassword"

# MySQL 명령 실행 변수 설정
MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"

# 주기적인 비밀번호 변경 정책 설정 확인
PASSWORD_CHANGE_POLICY=$($MYSQL_CMD "SELECT user, password_last_changed FROM mysql.user;")

# 비밀번호 변경 정책 확인
if [ -z "$PASSWORD_CHANGE_POLICY" ]; then
    WARN "주기적인 비밀번호 변경 정책이 설정되어 있지 않습니다."
else
    # 이 부분에서 주기적인 변경 정책에 따라 결과를 필터링합니다.
    # 예시로는 마지막 변경일로부터 X일이 지난 계정을 찾습니다.
    MAX_DAYS=90 # 여기서 X일을 정의합니다.
    CURRENT_DATE=$(date +%F)
    while read user last_changed; do
        if [[ $(date -d "$last_changed" +%F) < $(date -d "$CURRENT_DATE - $MAX_DAYS days" +%F) ]]; then
            WARN "주기적으로 비밀번호가 변경되지 않은 계정이 존재합니다: $user (마지막 변경: $last_changed)"
        fi
    done <<< "$PASSWORD_CHANGE_POLICY"
fi

# 결과 파일 출력
cat $result

# 종료 줄바꿈
echo ; echo

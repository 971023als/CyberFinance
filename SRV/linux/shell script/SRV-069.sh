#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-069] 비밀번호 관리정책 설정 미비

cat << EOF >> $result
[양호]: 서버의 비밀번호 관리정책이 적절하게 설정된 경우
[취약]: 서버의 비밀번호 관리정책이 미비하게 설정된 경우
EOF

BAR

# 비밀번호 정책 파일 경로
PASSWORD_POLICY_FILE="/etc/login.defs"

# 비밀번호 관리정책 확인
if [ -f "$PASSWORD_POLICY_FILE" ]; then
    # 최소 길이, 최대 사용 기간, 최소 사용 기간 등을 확인
    min_len=$(grep -E "^PASS_MIN_LEN" "$PASSWORD_POLICY_FILE" | awk '{print $2}')
    max_days=$(grep -E "^PASS_MAX_DAYS" "$PASSWORD_POLICY_FILE" | awk '{print $2}')
    min_days=$(grep -E "^PASS_MIN_DAYS" "$PASSWORD_POLICY_FILE" | awk '{print $2}')

    if [ "$min_len" -ge 8 ] && [ "$max_days" -le 90 ] && [ "$min_days" -ge 1 ]; then
        OK "비밀번호 관리정책이 적절하게 설정되었습니다. (최소 길이: $min_len, 최대 사용 기간: $max_days, 최소 사용 기간: $min_days)"
    else
        WARN "비밀번호 관리정책 설정이 미비합니다."
    fi
else
    WARN "비밀번호 정책 파일($PASSWORD_POLICY_FILE)이 존재하지 않습니다."
fi

cat $result

echo ; echo

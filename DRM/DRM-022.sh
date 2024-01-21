#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-022] 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡

cat << EOF >> $result
[양호]: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없는 경우
[취약]: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는 경우
EOF

BAR

# /etc/shadow 파일을 확인하여 빈 비밀번호가 설정된 계정을 찾습니다.
while IFS=: read -r user enc_passwd rest; do
    if [[ "$enc_passwd" == "" ]]; then
        WARN "비밀번호가 설정되지 않은 계정: $user"
    elif [[ "$enc_passwd" == "!" || "$enc_passwd" == "*" ]]; then
        OK "비밀번호가 잠긴 계정: $user"
    else
        OK "비밀번호가 설정된 계정: $user"
    fi
done < /etc/shadow

cat $result

echo ; echo

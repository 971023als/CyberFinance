#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-028] 원격 터미널 접속 타임아웃 미설정

cat << EOF >> $result
[양호]: SSH 원격 터미널 접속 타임아웃이 적절하게 설정된 경우
[취약]: SSH 원격 터미널 접속 타임아웃이 설정되지 않은 경우
EOF

BAR

# SSH 설정 파일을 확인합니다.
SSH_CONFIG_FILE="/etc/ssh/sshd_config"

# ClientAliveInterval과 ClientAliveCountMax를 확인합니다.
# 이 값들은 무활동 상태의 SSH 세션을 얼마나 오랫동안 유지할지 결정합니다.
if grep -q "^ClientAliveInterval" "$SSH_CONFIG_FILE" && grep -q "^ClientAliveCountMax" "$SSH_CONFIG_FILE"; then
    OK "SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다."
else
    WARN "SSH 원격 터미널 타임아웃 설정이 미비합니다."
fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-060] 웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경

cat << EOF >> $result
[양호]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경된 경우
[취약]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않은 경우
EOF

BAR

# 웹 서비스의 기본 계정 설정 파일 예시 (실제 환경에 맞게 조정)
CONFIG_FILE="/etc/web_service/config"

# 기본 계정 설정 확인 (예시: 'admin' 또는 'password')
if grep -qE "username=admin|password=password" "$CONFIG_FILE"; then
    WARN "웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않았습니다: $CONFIG_FILE"
else
    OK "웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되었습니다: $CONFIG_FILE"
fi

cat $result

echo ; echo

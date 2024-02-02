#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-152] 원격터미널 접속 가능한 사용자 그룹 제한 미비

cat << EOF >> $result
[양호]: SSH 접속이 특정 그룹에게만 제한된 경우
[취약]: SSH 접속이 특정 그룹에게만 제한되지 않은 경우
EOF

BAR

# SSH 설정 파일에서 접근 가능한 사용자 그룹 확인
ssh_config="/etc/ssh/sshd_config"
if [ -f "$ssh_config" ]; then
    if grep -q "^AllowGroups" "$ssh_config"; then
        groups=$(grep "^AllowGroups" "$ssh_config" | cut -d ' ' -f2-)
        OK "SSH 접속이 다음 그룹에게만 제한됩니다: $groups"
    else
        WARN "SSH 접속이 특정 그룹에게만 제한되지 않습니다."
    fi
else
    INFO "SSH 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

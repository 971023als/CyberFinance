#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-158] 불필요한 Telnet 서비스 실행

cat << EOF >> $result
[양호]: Telnet 서비스가 비활성화되어 있는 경우
[취약]: Telnet 서비스가 활성화되어 있는 경우
EOF

BAR

# Telnet 서비스의 상태를 확인합니다
telnet_status=$(service telnet status 2>&1)

if [[ $telnet_status == *"active (running)"* ]]; then
    WARN "Telnet 서비스가 실행 중입니다."
else
    OK "Telnet 서비스가 실행되고 있지 않습니다."
fi

cat $result

echo ; echo

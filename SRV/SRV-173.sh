#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-173] DNS 서비스의 취약한 동적 업데이트 설정

cat << EOF >> $result
[양호]: DNS 동적 업데이트가 안전하게 구성된 경우
[취약]: DNS 동적 업데이트가 취약하게 구성된 경우
EOF

BAR

# DNS 설정 파일 경로
dns_config="/etc/bind/named.conf"

# 동적 업데이트 설정 확인
if [ -f "$dns_config" ]; then
    dynamic_updates=$(grep "allow-update" "$dns_config")
    if [ -z "$dynamic_updates" ]; then
        OK "DNS 동적 업데이트가 안전하게 구성되어 있습니다."
    else
        WARN "DNS 동적 업데이트 설정이 취약합니다: $dynamic_updates"
    fi
else
    INFO "DNS 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

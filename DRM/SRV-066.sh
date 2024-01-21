#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-066] DNS Zone Transfer 설정 미흡

cat << EOF >> $result
[양호]: DNS Zone Transfer가 안전하게 제한되어 있는 경우
[취약]: DNS Zone Transfer가 적절하게 제한되지 않은 경우
EOF

BAR

# DNS 설정 파일 경로
DNS_CONFIG_FILE="/etc/bind/named.conf.options" # BIND 예시, 실제 파일 경로는 다를 수 있음

# Zone Transfer 설정 확인
if grep -E "allow-transfer" "$DNS_CONFIG_FILE"; then
    transfer_setting=$(grep "allow-transfer" "$DNS_CONFIG_FILE")
    if echo "$transfer_setting" | grep -q "{ none; };" || echo "$transfer_setting" | grep -q "{ localhost; };" || echo "$transfer_setting" | grep -q "{ localnets; };"; then
        OK "DNS Zone Transfer가 안전하게 제한됨: $transfer_setting"
    else
        WARN "DNS Zone Transfer가 적절하게 제한되지 않음: $transfer_setting"
    fi
else
    OK "DNS Zone Transfer가 명시적으로 허용되지 않음"
fi

cat $result

echo ; echo

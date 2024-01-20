#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-063] DNS Recursive Query 설정 미흡

cat << EOF >> $result
[양호]: DNS 서버에서 재귀적 쿼리가 제한적으로 설정된 경우
[취약]: DNS 서버에서 재귀적 쿼리가 적절하게 제한되지 않은 경우
EOF

BAR

# DNS 설정 파일 경로
DNS_CONFIG_FILE="/etc/bind/named.conf.options" # BIND 예시, 실제 파일 경로는 다를 수 있음

# 재귀 쿼리 설정 확인
if grep -E "allow-recursion" "$DNS_CONFIG_FILE"; then
    recursion_setting=$(grep "allow-recursion" "$DNS_CONFIG_FILE")
    if echo "$recursion_setting" | grep -q "{ localhost; };" || echo "$recursion_setting" | grep -q "{ localnets; };"; then
        OK "DNS 서버에서 재귀적 쿼리가 안전하게 제한됨: $recursion_setting"
    else
        WARN "DNS 서버에서 재귀적 쿼리 제한이 미흡함: $recursion_setting"
    fi
else
    OK "DNS 서버에서 재귀적 쿼리가 기본적으로 제한됨"
fi

cat $result

echo ; echo

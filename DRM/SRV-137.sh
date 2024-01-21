#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-137] 네트워크 서비스의 접근 제한 설정 미흡

cat << EOF >> $result
[양호]: 네트워크 서비스의 접근 제한이 적절히 설정된 경우
[취약]: 네트워크 서비스의 접근 제한이 설정되지 않은 경우
EOF

BAR

# iptables 또는 nftables로 네트워크 접근 제한 설정 확인
if iptables -L | grep -q REJECT; then
  OK "iptables를 통한 네트워크 접근 제한이 설정되어 있습니다."
elif nft list ruleset | grep -q reject; then
  OK "nftables를 통한 네트워크 접근 제한이 설정되어 있습니다."
else
  WARN "네트워크 접근 제한이 설정되어 있지 않습니다."
fi

cat $result

echo ; echo

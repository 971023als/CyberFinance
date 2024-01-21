#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-035] 취약한 서비스 활성화

cat << EOF >> $result
[양호]: 취약한 서비스가 비활성화된 경우
[취약]: 취약한 서비스가 활성화된 경우
EOF

BAR

# 취약한 서비스 목록
VULNERABLE_SERVICES=("telnet" "ftp" "rsh" "rpcbind" "tftp" "snmpd")

for service in "${VULNERABLE_SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    WARN "$service 서비스가 활성화되어 있습니다."
  else
    OK "$service 서비스가 비활성화되어 있습니다."
  fi
done

cat $result

echo ; echo

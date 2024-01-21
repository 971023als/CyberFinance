#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-147] 불필요한 SNMP 서비스 실행

cat << EOF >> $result
[양호]: SNMP 서비스가 비활성화되어 있는 경우
[취약]: SNMP 서비스가 활성화되어 있는 경우
EOF

BAR

# SNMP 서비스 상태 확인
if systemctl is-active --quiet snmpd; then
    WARN "SNMP 서비스가 활성화되어 있습니다."
else
    OK "SNMP 서비스가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

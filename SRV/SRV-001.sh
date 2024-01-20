#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log

> $TMP1

BAR

CODE [SRV-001] SNMP Community 스트링 설정 미흡

cat << EOF >> $result

[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우

[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우

EOF

BAR

# SNMP 구성 파일에서 Community 스트링을 확인합니다
if grep -q "public" /etc/snmp/snmpd.conf; then
    WARN "기본 SNMP Community 스트링이 사용됨"
else
    OK "기본 SNMP Community 스트링이 사용되지 않음"
fi

cat $result

echo ; echo


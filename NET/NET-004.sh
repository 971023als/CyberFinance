#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-005] SNMP 접근통제(ACL) 설정

cat << EOF >> "$result"
[양호]: SNMP 접근통제(ACL)이 적절하게 설정된 경우
[취약]: SNMP 접근통제(ACL) 설정이 미흡한 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# SNMP ACL 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 SNMP ACL 확인
    SNMP_ACL=$(ssh $device "show snmp access-list") # 실제 명령어로 변경

    # ACL 검사 로직
    if [[ $(check_acl "$SNMP_ACL") == "OK" ]]; then
        OK "$device 의 SNMP ACL이 적절합니다."
    else
        WARN "$device 의 SNMP ACL이 미흡합니다."
    fi
done

cat "$result"

echo ; echo

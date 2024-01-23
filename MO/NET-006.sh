#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-006] 외부인터페이스 SNMP 접근 차단

cat << EOF >> "$result"
[양호]: 외부 인터페이스에서 SNMP 접근이 차단된 경우
[취약]: 외부 인터페이스에서 SNMP 접근이 차단되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 외부 인터페이스에서의 SNMP 접근 차단 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 외부 인터페이스의 SNMP 접근 설정 확인
    SNMP_ACCESS=$(ssh $device "show snmp interface external") # 실제 명령어로 변경

    # SNMP 접근 차단 확인 로직
    if [[ $(check_snmp_access "$SNMP_ACCESS") == "blocked" ]]; then
        OK "$device 의 외부 인터페이스에서 SNMP 접근이 차단됩니다."
    else
        WARN "$device 의 외부 인터페이스에서 SNMP 접근이 차단되지 않습니다."
    fi
done

cat "$result"

echo ; echo

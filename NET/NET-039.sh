#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-039] 외부 인터페이스에 egress 필터 설정

cat << EOF >> "$result"
[양호]: 외부 인터페이스에 적절한 egress 필터가 설정된 경우
[취약]: 외부 인터페이스에 egress 필터가 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 외부 인터페이스 egress 필터 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 외부 인터페이스의 egress 필터 설정 확인
    EGRESS_FILTER=$(ssh $device "show running-config | include egress-filter") # 실제 장비의 egress 필터 확인 명령어로 변경 필요

    # egress 필터 설정 상태 확인
    if [[ $EGRESS_FILTER ]]; then
        OK "$device 에서 외부 인터페이스에 적절한 egress 필터가 설정되었습니다."
    else
        WARN "$device 에서 외부 인터페이스에 egress 필터가 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

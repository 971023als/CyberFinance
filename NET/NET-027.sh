#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-027] IP Directed Broadcast 차단 점검 - IOS 11

cat << EOF >> "$result"
[양호]: IP Directed Broadcast가 차단된 경우
[취약]: IP Directed Broadcast가 차단되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 IP Directed Broadcast 차단 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 IP Directed Broadcast 차단 설정 확인
    IP_DIRECTED_BROADCAST_STATUS=$(ssh $device "show ip directed-broadcast") # 실제 장비의 IP Directed Broadcast 상태 확인 명령어로 변경 필요

    # IP Directed Broadcast 차단 설정 확인
    if [[ "$IP_DIRECTED_BROADCAST_STATUS" == *"No IP directed-broadcast"* ]]; then
        OK "$device 에서 IP Directed Broadcast가 차단되었습니다."
    else
        WARN "$device 에서 IP Directed Broadcast가 차단되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

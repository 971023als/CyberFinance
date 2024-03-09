#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-022] 불필요한 Source 라우팅 차단 설정 여부

cat << EOF >> "$result"
[양호]: 불필요한 Source 라우팅이 모두 차단된 경우
[취약]: 불필요한 Source 라우팅이 차단되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 Source 라우팅 차단 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 Source 라우팅 차단 설정 확인
    SOURCE_ROUTING_STATUS=$(ssh $device "show source-routing status") # 실제 장비의 Source 라우팅 상태 확인 명령어로 변경 필요

    # Source 라우팅 차단 설정 확인
    if [[ "$SOURCE_ROUTING_STATUS" == *"blocked"* || "$SOURCE_ROUTING_STATUS" == *"disabled"* ]]; then
        OK "$device 에서 불필요한 Source 라우팅이 차단되었습니다."
    else
        WARN "$device 에서 불필요한 Source 라우팅이 차단되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

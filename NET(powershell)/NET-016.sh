#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-016] 불필요한 보조 입출력 포트(AUX) 차단 여부

cat << EOF >> "$result"
[양호]: 모든 불필요한 보조 입출력 포트(AUX)가 차단된 경우
[취약]: 하나 이상의 불필요한 보조 입출력 포트(AUX)가 차단되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 AUX 포트 차단 상태 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 AUX 포트 설정 확인
    AUX_STATUS=$(ssh $device "show aux port status") # 실제 장비의 AUX 포트 상태 확인 명령어로 변경 필요

    # AUX 포트 차단 상태 확인
    if [[ "$AUX_STATUS" == *"blocked"* || "$AUX_STATUS" == *"disabled"* ]]; then
        OK "$device 에서 모든 보조 입출력 포트(AUX)가 차단되었습니다."
    else
        WARN "$device 에서 불필요한 보조 입출력 포트(AUX)가 차단되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

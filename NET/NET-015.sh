#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-015] VTY 접속 시 안전하지 않은 프로토콜 사용

cat << EOF >> "$result"
[양호]: VTY 접속에 안전한 프로토콜만 사용되는 경우
[취약]: VTY 접속에 안전하지 않은 프로토콜(TELNET 등)이 사용되는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 VTY 접속 프로토콜 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 VTY 프로토콜 설정 확인
    VTY_PROTOCOL=$(ssh $device "show vty protocol settings") # 실제 장비의 VTY 프로토콜 확인 명령어로 변경 필요

    # 안전하지 않은 프로토콜(예: TELNET) 사용 여부 확인
    if [[ "$VTY_PROTOCOL" == *"TELNET"* ]]; then
        WARN "$device 에서 안전하지 않은 VTY 프로토콜(TELNET 등)이 사용되고 있습니다."
    else
        OK "$device 에서 안전한 VTY 프로토콜만 사용되고 있습니다."
    fi
done

cat "$result"

echo ; echo

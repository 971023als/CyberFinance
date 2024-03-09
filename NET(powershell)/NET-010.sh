#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-010] enable secret 설정 여부

cat << EOF >> "$result"
[양호]: 'enable secret'가 설정된 경우
[취약]: 'enable secret'가 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에 대한 'enable secret' 설정 검사
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 'enable secret' 설정 확인
    ENABLE_SECRET=$(ssh $device "show running-config | include enable secret") 

    # 'enable secret' 설정 여부 확인 로직
    if [ -z "$ENABLE_SECRET" ]; then
        WARN "$device 에서 'enable secret'가 설정되지 않았습니다."
    else
        OK "$device 에서 'enable secret'가 설정되어 있습니다."
    fi
done

cat "$result"

echo ; echo

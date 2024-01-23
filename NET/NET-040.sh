#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-040] 스푸핑방지 필터 설정

cat << EOF >> "$result"
[양호]: 네트워크 장비에 스푸핑방지 필터가 적절하게 설정된 경우
[취약]: 네트워크 장비에 스푸핑방지 필터가 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 스푸핑방지 필터 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 스푸핑방지 필터 설정 확인
    SPOOFING_FILTER=$(ssh $device "show running-config | include spoofing-filter") # 실제 장비의 스푸핑방지 필터 확인 명령어로 변경 필요

    # 스푸핑방지 필터 설정 상태 확인
    if [[ $SPOOFING_FILTER ]]; then
        OK "$device 에서 스푸핑방지 필터가 적절하게 설정되었습니다."
    else
        WARN "$device 에서 스푸핑방지 필터가 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

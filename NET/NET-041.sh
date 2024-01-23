#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-041] IP 멀티캐스트 차단 설정

cat << EOF >> "$result"
[양호]: 네트워크 장비에 IP 멀티캐스트 차단이 적절하게 설정된 경우
[취약]: 네트워크 장비에 IP 멀티캐스트 차단이 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 IP 멀티캐스트 차단 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 IP 멀티캐스트 차단 설정 확인
    MULTICAST_BLOCKING=$(ssh $device "show running-config | include multicast-blocking") # 실제 장비의 IP 멀티캐스트 차단 확인 명령어로 변경 필요

    # IP 멀티캐스트 차단 설정 상태 확인
    if [[ $MULTICAST_BLOCKING ]]; then
        OK "$device 에서 IP 멀티캐스트 차단이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 IP 멀티캐스트 차단이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

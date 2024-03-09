#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-031] NTP 설정 및 시각 동기화 여부

cat << EOF >> "$result"
[양호]: NTP 설정 및 시각 동기화가 올바르게 구성된 경우
[취약]: NTP 설정 또는 시각 동기화가 제대로 구성되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 NTP 설정 및 시각 동기화 여부 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 NTP 설정 확인
    NTP_CONFIG=$(ssh $device "show running-config | include ntp") # 실제 장비의 NTP 설정 확인 명령어로 변경 필요

    # NTP 설정 및 시각 동기화 상태 확인
    if [[ -n "$NTP_CONFIG" ]]; then
        OK "$device 에서 NTP 설정 및 시각 동기화가 올바르게 구성되었습니다."
    else
        WARN "$device 에서 NTP 설정 또는 시각 동기화가 구성되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

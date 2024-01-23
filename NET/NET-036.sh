#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-036] 원격 로그서버 연동 설정

cat << EOF >> "$result"
[양호]: 원격 로그서버와의 연동이 적절하게 설정된 경우
[취약]: 원격 로그서버와의 연동이 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 원격 로그서버 연동 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 원격 로그서버 설정 확인
    REMOTE_LOGGING=$(ssh $device "show running-config | include logging host") # 실제 장비의 원격 로그서버 설정 확인 명령어로 변경 필요

    # 원격 로그서버 설정 상태 확인
    if [[ $REMOTE_LOGGING ]]; then
        OK "$device 에서 원격 로그서버와의 연동이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 원격 로그서버와의 연동이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

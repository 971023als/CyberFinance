#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-037] 콘솔로깅 레벨 설정

cat << EOF >> "$result"
[양호]: 콘솔로깅 레벨이 적절하게 설정된 경우
[취약]: 콘솔로깅 레벨이 적절하지 않게 설정된 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 콘솔로깅 레벨 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 콘솔로깅 레벨 확인
    CONSOLE_LOG_LEVEL=$(ssh $device "show running-config | include logging console") # 실제 장비의 콘솔로깅 레벨 확인 명령어로 변경 필요

    # 콘솔로깅 레벨 상태 확인
    if [[ $CONSOLE_LOG_LEVEL ]]; then
        OK "$device 에서 콘솔로깅 레벨이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 콘솔로깅 레벨이 적절하지 않게 설정되었습니다."
    fi
done

cat "$result"

echo ; echo

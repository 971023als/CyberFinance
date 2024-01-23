#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-035] 로깅 버퍼 사이즈 설정 여부

cat << EOF >> "$result"
[양호]: 로깅 버퍼 사이즈가 적절하게 설정된 경우
[취약]: 로깅 버퍼 사이즈가 설정되지 않거나 너무 작은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 로깅 버퍼 사이즈 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 로깅 버퍼 사이즈 확인
    LOGGING_BUFFER_SIZE=$(ssh $device "show logging | include buffer") # 실제 장비의 로깅 버퍼 사이즈 확인 명령어로 변경 필요

    # 로깅 버퍼 사이즈 설정 상태 확인
    if [[ $LOGGING_BUFFER_SIZE == *"configured size"* ]]; then
        OK "$device 에서 로깅 버퍼 사이즈가 적절하게 설정되었습니다."
    else
        WARN "$device 에서 로깅 버퍼 사이즈가 설정되지 않았거나 너무 작습니다."
    fi
done

cat "$result"

echo ; echo

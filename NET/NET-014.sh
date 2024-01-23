#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-014] 세션 타임아웃 설정 여부

cat << EOF >> "$result"
[양호]: 세션 타임아웃이 적절히 설정된 경우
[취약]: 세션 타임아웃 설정이 미흡한 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 세션 타임아웃 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 세션 타임아웃 설정 확인
    SESSION_TIMEOUT=$(ssh $device "show session timeout settings") # 실제 장비의 세션 타임아웃 확인 명령어로 변경 필요

    # 세션 타임아웃 설정 확인 로직
    if [[ "$SESSION_TIMEOUT" -ge "desired_timeout_value" ]]; then
        OK "$device 에서 세션 타임아웃이 적절히 설정되어 있습니다."
    else
        WARN "$device 에서 세션 타임아웃 설정이 미흡합니다."
    fi
done

cat "$result"

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-013] 원격 관리 접근 통제

cat << EOF >> "$result"
[양호]: 원격 관리 접근 통제가 적절히 설정된 경우
[취약]: 원격 관리 접근 통제가 부적절하게 설정된 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 원격 관리 접근 통제 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 원격 관리 접근 통제 설정 확인
    REMOTE_ACCESS_CONTROL=$(ssh $device "show remote-access control settings") # 실제 장비의 원격 접근 통제 확인 명령어로 변경 필요

    # 원격 관리 접근 통제 설정 확인 로직
    if [[ "$REMOTE_ACCESS_CONTROL" == *"desired access control conditions"* ]]; then
        OK "$device 에서 원격 관리 접근 통제가 적절히 설정되어 있습니다."
    else
        WARN "$device 에서 원격 관리 접근 통제 설정이 부적절합니다."
    fi
done

cat "$result"

echo ; echo

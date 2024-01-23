#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-030] 불필요한 서비스 구동 여부

cat << EOF >> "$result"
[양호]: 불필요한 서비스가 구동되지 않은 경우
[취약]: 불필요한 서비스가 구동되는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 불필요한 서비스 구동 여부 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 불필요한 서비스 확인
    UNNECESSARY_SERVICES=$(ssh $device "show running-config | include [service_condition]") # 실제 장비의 불필요한 서비스 확인 명령어로 변경 필요

    # 불필요한 서비스 구동 여부 확인
    if [[ -n "$UNNECESSARY_SERVICES" ]]; then
        WARN "$device 에서 다음과 같은 불필요한 서비스가 구동 중입니다: $UNNECESSARY_SERVICES"
    else
        OK "$device 에서 불필요한 서비스가 구동되지 않고 있습니다."
    fi
done

cat "$result"

echo ; echo

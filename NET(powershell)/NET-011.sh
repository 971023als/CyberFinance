#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-011] 안전한 암호화 알고리즘 설정 여부

cat << EOF >> "$result"
[양호]: 안전한 암호화 알고리즘을 사용하는 경우
[취약]: 불안전한 알고리즘을 사용하거나 암호화가 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 암호화 알고리즘 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 암호화 설정 확인
    ENCRYPTION_CONFIG=$(ssh $device "show encryption status") # 실제 장비의 암호화 상태 확인 명령어로 변경 필요

    # 안전한 암호화 알고리즘 사용 여부 확인 로직
    # 예를 들어, AES 알고리즘 사용 여부 확인
    if [[ "$ENCRYPTION_CONFIG" == *"AES"* ]]; then
        OK "$device 에서 안전한 암호화 알고리즘(AES)을 사용하고 있습니다."
    else
        WARN "$device 에서 안전한 암호화 알고리즘을 사용하지 않고 있습니다."
    fi
done

cat "$result"

echo ; echo

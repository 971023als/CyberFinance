#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-012] 비밀번호 복잡도 설정

cat << EOF >> "$result"
[양호]: 비밀번호 복잡도 설정이 적절한 경우
[취약]: 비밀번호 복잡도 설정이 부적절한 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 비밀번호 복잡도 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 비밀번호 정책 확인
    PASSWORD_POLICY=$(ssh $device "show password-policy") # 실제 장비의 비밀번호 정책 확인 명령어로 변경 필요

    # 비밀번호 복잡도 설정 확인 로직
    if [[ "$PASSWORD_POLICY" == *"desired complexity conditions"* ]]; then
        OK "$device 에서 비밀번호 복잡도 설정이 적절합니다."
    else
        WARN "$device 에서 비밀번호 복잡도 설정이 부적절합니다."
    fi
done

cat "$result"

echo ; echo

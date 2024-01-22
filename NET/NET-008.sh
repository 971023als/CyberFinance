#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-008] 강화된 인증기능(AAA) 사용 여부

cat << EOF >> "$result"
[양호]: 강화된 인증기능(AAA)이 사용되는 경우
[취약]: 강화된 인증기능(AAA)이 사용되지 않는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# AAA 설정 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 AAA 설정 정보 확인
    AAA_CONFIG=$(ssh $device "show aaa") # 실제 장비의 AAA 설정 확인 명령어로 변경

    # AAA 설정 검사 로직
    if [[ $AAA_CONFIG == *"expected AAA configuration"* ]]; then
        OK "$device 에서 AAA 기능이 활성화되어 있습니다."
    else
        WARN "$device 에서 AAA 기능이 활성화되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

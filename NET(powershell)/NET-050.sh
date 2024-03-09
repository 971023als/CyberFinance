#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-050] 로그온 시 경고메시지 미설정

cat << EOF >> "$result"
[양호]: 로그온 시 경고메시지가 설정된 경우
[취약]: 로그온 시 경고메시지가 설정되지 않은 경우
EOF

BAR

# 점검할 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 로그온 경고메시지 설정 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 로그온 경고메시지 설정 확인
    LOGIN_BANNER=$(ssh $device "show running-config | include banner login") # 실제 장비의 확인 명령어로 변경

    # 로그온 경고메시지가 설정되어 있는지 확인
    if [[ $LOGIN_BANNER ]]; then
        OK "$device 에서 로그온 시 경고메시지가 설정되었습니다."
    else
        WARN "$device 에서 로그온 시 경고메시지가 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

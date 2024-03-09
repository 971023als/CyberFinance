#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-007] Local 사용자 생성 및 권한관리 여부

cat << EOF >> "$result"
[양호]: Local 사용자가 올바르게 생성되고 권한이 관리되는 경우
[취약]: Local 사용자 생성 및 권한관리가 적절하지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# Local 사용자 생성 및 권한관리 검사
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 사용자 계정 설정 정보 확인
    USER_CONFIG=$(ssh $device "show users") # 실제 명령어로 변경

    # 사용자 계정 및 권한 검사 로직
    if [[ $(check_user_permissions "$USER_CONFIG") == "ok" ]]; then
        OK "$device 에서 Local 사용자 생성 및 권한이 올바르게 관리됩니다."
    else
        WARN "$device 에서 Local 사용자 생성 및 권한관리가 적절하지 않습니다."
    fi
done

cat "$result"

echo ; echo

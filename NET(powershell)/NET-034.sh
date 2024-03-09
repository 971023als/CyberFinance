#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-034] 로깅 메시지 시간 설정 여부

cat << EOF >> "$result"
[양호]: 네트워크 장비에서 로깅 메시지에 시간이 설정된 경우
[취약]: 네트워크 장비에서 로깅 메시지에 시간이 설정되지 않은 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비에서 로깅 메시지 시간 설정 여부 확인
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 로깅 메시지 설정 확인
    LOGGING_TIME_STATUS=$(ssh $device "show logging | include timestamp") # 실제 장비의 로깅 설정 확인 명령어로 변경 필요

    # 로깅 메시지 시간 설정 상태 확인
    if [[ $LOGGING_TIME_STATUS == *"timestamp enabled"* ]]; then
        OK "$device 에서 로깅 메시지에 시간이 설정되었습니다."
    else
        WARN "$device 에서 로깅 메시지에 시간이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

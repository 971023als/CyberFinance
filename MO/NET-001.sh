#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-001] 네트워크 장비 설정 백업 여부

cat << EOF >> "$result"
[양호]: 네트워크 장비의 설정이 정기적으로 백업되는 경우
[취약]: 네트워크 장비의 설정이 백업되지 않는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 이 부분을 실제 장비 목록으로 교체

# 백업 상태 확인
for device in "${DEVICES[@]}"; do
    # 여기에 장비별 설정 백업 확인 명령어 입력
    # 예: ssh $device "check_backup_command"
    BACKUP_STATUS=$(ssh $device "check_backup_command") # 실제 확인 명령어로 변경

    if [ "$BACKUP_STATUS" == "OK" ]; then
        OK "$device 설정이 백업되었습니다."
    else
        WARN "$device 설정이 백업되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

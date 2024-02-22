#!/bin/bash

# function.sh 파일을 소스로 가져옴
. function.sh

# 임시 파일 생성 및 결과 파일 정의
TMP1=$(mktemp)
result="backup_result.txt"
> "$result"

# 상단 및 하단 바 출력 함수 호출
BAR

# 결과 파일에 헤더 추가
cat << EOF >> "$result"
[양호]: 네트워크 장비의 설정이 정기적으로 백업되는 경우
[취약]: 네트워크 장비의 설정이 백업되지 않는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 이 부분을 실제 장비 목록으로 교체

# 백업 상태 확인
for device in "${DEVICES[@]}"; do
    # 장비별 설정 백업 확인 명령어. 실제 확인 명령어로 교체 필요
    BACKUP_STATUS=$(ssh $device "check_backup_command") 

    if [ "$BACKUP_STATUS" == "OK" ]; then
        # 백업 상태가 양호한 경우
        echo "$device 설정이 백업되었습니다." >> "$result"
        OK "$device 설정이 백업되었습니다."
    else
        # 백업이 되지 않은 경우
        echo "$device 설정이 백업되지 않았습니다." >> "$result"
        WARN "$device 설정이 백업되지 않았습니다."
    fi
done

# 결과 파일 출력
cat "$result"
echo ; echo

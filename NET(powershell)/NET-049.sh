#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-049] 명령어 실행 권한 제한 여부

cat << EOF >> "$result"
[양호]: 필요한 명령어에 대한 실행 권한이 적절하게 제한된 경우
[취약]: 필요한 명령어에 대한 실행 권한이 제한되지 않은 경우
EOF

BAR

# 점검할 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 명령어 실행 권한 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 사용자 권한 설정 확인
    USER_PERMISSIONS=$(ssh $device "show users | include permissions") # 실제 장비의 확인 명령어로 변경

    # 필요한 명령어에 대한 실행 권한이 적절하게 제한되었는지 확인
    if [[ $USER_PERMISSIONS == *"[적절한 권한 제한 조건]"* ]]; then
        OK "$device 에서 명령어 실행 권한이 적절하게 제한되었습니다."
    else
        WARN "$device 에서 명령어 실행 권한이 적절하게 제한되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

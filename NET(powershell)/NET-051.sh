#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-051] TCP keepalives 사용 설정 여부

cat << EOF >> "$result"
[양호]: TCP keepalives가 활성화된 경우
[취약]: TCP keepalives가 활성화되지 않은 경우
EOF

BAR

# 점검할 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 TCP keepalives 설정 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 TCP keepalives 설정 확인
    KEEPALIVE_CONFIG=$(ssh $device "show running-config | include keepalive") # 실제 장비의 확인 명령어로 변경

    # TCP keepalives가 활성화되어 있는지 확인
    if [[ $KEEPALIVE_CONFIG ]]; then
        OK "$device 에서 TCP keepalives가 활성화되었습니다."
    else
        WARN "$device 에서 TCP keepalives가 활성화되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-048] 최신/긴급 보안 패치 및 업데이트 적용 여부

cat << EOF >> "$result"
[양호]: 최신 보안 패치 및 업데이트가 적용된 경우
[취약]: 최신 보안 패치 및 업데이트가 적용되지 않은 경우
EOF

BAR

# 최신 보안 패치 버전 (예시)
LATEST_PATCH_VERSION="1.2.3"

# 점검할 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 보안 패치 버전 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 현재 소프트웨어 버전 확인
    CURRENT_VERSION=$(ssh $device "show version | grep Software") # 실제 장비의 확인 명령어로 변경

    # 현재 버전과 최신 보안 패치 버전 비교
    if [[ $CURRENT_VERSION == *"$LATEST_PATCH_VERSION"* ]]; then
        OK "$device 에서 최신 보안 패치가 적용되었습니다."
    else
        WARN "$device 에서 최신 보안 패치가 적용되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

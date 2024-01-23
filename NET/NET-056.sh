#!/bin/bash

# 함수 라이브러리 포함
. function.sh

# 임시 로그 파일 생성
TMP1=$(mktemp)
> "$TMP1"

# 로그 시작과 끝 구분선
BAR

# 점검 코드
CODE [NET-056] 비밀번호의 주기적인 변경관리 여부

cat << EOF >> "$result"
[양호]: 비밀번호 변경 정책이 적절하게 설정된 경우
[취약]: 비밀번호 변경 정책이 설정되지 않았거나 불충분한 경우
EOF

BAR

# 점검할 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 각 장비의 비밀번호 변경 정책 점검
for device in "${DEVICES[@]}"; do
    # 각 장비에 SSH 접속하여 비밀번호 정책 확인
    PASSWORD_POLICY=$(ssh $device "show password-policy") # 실제 장비의 확인 명령어로 변경

    # 비밀번호 정책이 설정되어 있는지 확인
    if [[ $PASSWORD_POLICY ]]; then
        OK "$device 에서 비밀번호 변경 정책이 적절하게 설정되었습니다."
    else
        WARN "$device 에서 비밀번호 변경 정책이 설정되지 않았습니다."
    fi
done

cat "$result"

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [NET-009] 취약한 비밀번호 중복 사용

cat << EOF >> "$result"
[양호]: 취약하거나 중복된 비밀번호가 사용되지 않는 경우
[취약]: 취약하거나 중복된 비밀번호가 사용되는 경우
EOF

BAR

# 네트워크 장비 목록
DEVICES=("Device1" "Device2" "Device3") # 실제 장비 목록으로 교체 필요

# 알려진 취약한 비밀번호 목록
KNOWN_WEAK_PASSWORDS=("password123" "admin" "default") # 실제 취약한 비밀번호 목록으로 교체 필요

# 각 장비에 대한 비밀번호 중복 및 취약성 검사
for device in "${DEVICES[@]}"; do
    # 장비에 접속하여 사용자 계정과 비밀번호 정보 확인
    PASSWORDS=$(ssh $device "show user accounts") # 실제 장비의 사용자 계정 확인 명령어로 변경

    # 비밀번호 중복 및 취약성 검사 로직
    for password in $PASSWORDS; do
        # 길이 검사
        if [ ${#password} -lt 8 ]; then
            WARN "$device 에서 길이가 짧은 비밀번호가 사용되고 있습니다: $password"
            continue
        fi

        # 패턴 검사
        if [[ $password =~ [0-9] ]] && [[ $password =~ [a-zA-Z] ]]; then
            # 패턴 충족
            :
        else
            WARN "$device 에서 강력하지 않은 패턴의 비밀번호가 사용되고 있습니다: $password"
            continue
        fi

        # 알려진 취약한 비밀번호 목록과 대조
        for weak_pass in "${KNOWN_WEAK_PASSWORDS[@]}"; do
            if [ "$password" == "$weak_pass" ]; then
                WARN "$device 에서 알려진 취약한 비밀번호가 사용되고 있습니다: $password"
                break
            fi
        done
    done
done

cat "$result"

echo ; echo

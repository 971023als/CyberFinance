#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-092] 사용자 홈 디렉터리 설정 미흡

cat << EOF >> $result
[양호]: 모든 사용자의 홈 디렉터리가 적절히 설정되어 있는 경우
[취약]: 하나 이상의 사용자의 홈 디렉터리가 적절히 설정되지 않은 경우
EOF

BAR

# /etc/passwd에서 사용자 홈 디렉터리 정보 추출 및 확인
while IFS=: read -r user _ _ _ _ home_dir _; do
    if [ ! -d "$home_dir" ] || [ ! -n "$home_dir" ]; then
        WARN "사용자 $user 에 대한 홈 디렉터리($home_dir)가 잘못 설정되었습니다."
    else
        OK "사용자 $user 의 홈 디렉터리($home_dir)가 적절히 설정되었습니다."
    fi
done < /etc/passwd

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-074] 불필요하거나 관리되지 않는 계정 존재

cat << EOF >> $result
[양호]: 불필요하거나 관리되지 않는 계정이 존재하지 않는 경우
[취약]: 불필요하거나 관리되지 않는 계정이 존재하는 경우
EOF

BAR

# 마지막 로그인이 1년 이상된 계정 확인
year_ago=$(date --date="1 year ago" +%s)

while IFS=: read -r user _ _ _ _ dir _; do
    if [ ! -d "$dir" ]; then
        continue
    fi

    last_login=$(stat -c %Y "$dir")
    if [ "$last_login" -lt "$year_ago" ]; then
        WARN "계정 '$user'는 1년 이상 사용되지 않았습니다."
    else
        OK "계정 '$user'는 활발하게 사용 중입니다."
    fi
done < /etc/passwd

cat $result

echo ; echo

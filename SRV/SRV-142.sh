#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-142] 중복 UID가 부여된 계정 존재

cat << EOF >> $result
[양호]: 중복 UID가 부여된 계정이 존재하지 않는 경우
[취약]: 중복 UID가 부여된 계정이 존재하는 경우
EOF

BAR

# /etc/passwd 파일에서 UID를 추출하고 중복 검사를 실시
awk -F: '{print $3}' /etc/passwd | sort | uniq -d | while read uid
do
    if [ -n "$uid" ]; then
        WARN "중복 UID ($uid) 가 존재합니다."
    fi
done

# 중복이 없는 경우
if [ -z "$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)" ]; then
    OK "중복 UID가 부여된 계정이 존재하지 않습니다."
fi

cat $result

echo ; echo

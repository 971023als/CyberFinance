#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-163] 시스템 사용 주의사항 미출력

cat << EOF >> $result
[양호]: 시스템 로그온 시 사용 주의사항이 출력되는 경우
[취약]: 시스템 로그온 시 사용 주의사항이 출력되지 않는 경우
EOF

BAR

# /etc/motd 파일과 /etc/issue 파일 확인
motd_file="/etc/motd"
issue_file="/etc/issue"

if [ -f "$motd_file" ] && [ -s "$motd_file" ]; then
    OK "/etc/motd 파일이 존재하며 내용이 있습니다."
else
    WARN "/etc/motd 파일이 존재하지 않거나 비어 있습니다."
fi

if [ -f "$issue_file" ] && [ -s "$issue_file" ]; then
    OK "/etc/issue 파일이 존재하며 내용이 있습니다."
else
    WARN "/etc/issue 파일이 존재하지 않거나 비어 있습니다."
fi

cat $result

echo ; echo

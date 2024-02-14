#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-080] 일반 사용자의 프린터 드라이버 설치 제한 미비

cat << EOF >> $result
[양호]: 일반 사용자에 의한 프린터 드라이버 설치가 제한된 경우
[취약]: 일반 사용자에 의한 프린터 드라이버 설치에 제한이 없는 경우
EOF

BAR

# CUPS 설정 파일 경로
CUPS_CONFIG_FILE="/etc/cups/cupsd.conf"

# 설정 파일에서 'SystemGroup' 설정 확인
if [ -f "$CUPS_CONFIG_FILE" ]; then
    system_group=$(grep -E "^SystemGroup" "$CUPS_CONFIG_FILE")

    if [ -n "$system_group" ]; then
        OK "CUPS 설정에서 시스템 그룹이 지정됨: $system_group"
    else
        WARN "CUPS 설정에서 시스템 그룹이 지정되지 않음"
    fi
else
    WARN "CUPS 설정 파일($CUPS_CONFIG_FILE)이 존재하지 않습니다."
fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-140] 이동식 미디어 포맷 및 꺼내기 허용 정책 설정 미흡

cat << EOF >> $result
[양호]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 적절하게 설정되어 있는 경우
[취약]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 설정되어 있지 않은 경우
EOF

BAR

# dconf를 사용하여 GNOME 환경 설정 확인
if command -v dconf >/dev/null; then
    media_automount=$(dconf read /org/gnome/desktop/media-handling/automount)
    media_automount_open=$(dconf read /org/gnome/desktop/media-handling/automount-open)
    
    if [[ "$media_automount" == "false" && "$media_automount_open" == "false" ]]; then
        OK "이동식 미디어의 자동 마운트 및 열기가 비활성화되어 있습니다."
    else
        WARN "이동식 미디어의 자동 마운트 또는 열기가 활성화되어 있습니다."
    fi
else
    INFO "dconf 도구가 설치되어 있지 않거나 GNOME 환경이 아닙니다."
fi

cat $result

echo ; echo

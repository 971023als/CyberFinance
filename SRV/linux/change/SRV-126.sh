#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-126] 자동 로그온 방지 설정 미흡

cat << EOF >> $result
[양호]: 자동 로그온이 비활성화된 경우
[취약]: 자동 로그온이 활성화된 경우
EOF

BAR

# GDM (GNOME Display Manager) 설정 확인
if [ -f /etc/gdm3/custom.conf ]; then
    if grep -q "AutomaticLoginEnable=false" /etc/gdm3/custom.conf; then
        OK "GDM에서 자동 로그온이 비활성화되어 있습니다."
    else
        WARN "GDM에서 자동 로그온이 활성화되어 있습니다."
    fi
else
    INFO "GDM 설정 파일이 존재하지 않습니다."
fi

# LightDM 설정 확인
if [ -f /etc/lightdm/lightdm.conf ]; then
    if grep -q "autologin-user=" /etc/lightdm/lightdm.conf; then
        WARN "LightDM에서 자동 로그온이 설정되어 있습니다."
    else
        OK "LightDM에서 자동 로그온이 비활성화되어 있습니다."
    fi
else
    INFO "LightDM 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

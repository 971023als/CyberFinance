#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-125] 화면보호기 미설정

cat << EOF >> $result
[양호]: 화면보호기가 설정되어 있는 경우
[취약]: 화면보호기가 설정되어 있지 않은 경우
EOF

BAR

# GNOME 데스크톱 환경에서 화면보호기 설정 확인
if gsettings get org.gnome.desktop.screensaver lock-enabled | grep -q 'true'; then
  OK "화면보호기가 설정되어 있습니다."
else
  WARN "화면보호기가 설정되어 있지 않습니다."
fi

# KDE Plasma
if qdbus org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.GetActive; then
  OK "KDE에서 화면보호기가 설정되어 있습니다."
else
  WARN "KDE에서 화면보호기가 설정되어 있지 않습니다."
fi

# Xfce
if xfconf-query -c xfce4-screensaver -p /saver/enabled; then
  OK "Xfce에서 화면보호기가 설정되어 있습니다."
else
  WARN "Xfce에서 화면보호기가 설정되어 있지 않습니다."
fi

# Cinnamon
if gsettings get org.cinnamon.desktop.screensaver lock-enabled | grep -q 'true'; then
  OK "Cinnamon에서 화면보호기가 설정되어 있습니다."
else
  WARN "Cinnamon에서 화면보호기가 설정되어 있지 않습니다."
fi


cat $result

echo ; echo

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

# GNOME 데스크톱 환경
if command -v gsettings > /dev/null; then
  if gsettings get org.gnome.desktop.screensaver lock-enabled | grep -q 'true'; then
    OK "GNOME에서 화면보호기가 설정되어 있습니다."
  else
    WARN "GNOME에서 화면보호기가 설정되어 있지 않습니다."
  fi
else
  INFO "GNOME 화면보호기 도구가 설치되어 있지 않습니다."
fi

# KDE Plasma
if command -v qdbus > /dev/null; then
  if qdbus org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.GetActive; then
    OK "KDE에서 화면보호기가 설정되어 있습니다."
  else
    WARN "KDE에서 화면보호기가 설정되어 있지 않습니다."
  fi
else
  INFO "KDE 화면보호기 도구가 설치되어 있지 않습니다."
fi

# Xfce
if command -v xfconf-query > /dev/null; then
  if xfconf-query -c xfce4-screensaver -p /saver/enabled; then
    OK "Xfce에서 화면보호기가 설정되어 있습니다."
  else
    WARN "Xfce에서 화면보호기가 설정되어 있지 않습니다."
  fi
else
  INFO "Xfce 화면보호기 도구가 설치되어 있지 않습니다."
fi

# Cinnamon
if command -v gsettings > /dev/null; then
  if gsettings get org.cinnamon.desktop.screensaver lock-enabled | grep -q 'true'; then
    OK "Cinnamon에서 화면보호기가 설정되어 있습니다."
  else
    WARN "Cinnamon에서 화면보호기가 설정되어 있지 않습니다."
  fi
else
  INFO "Cinnamon 화면보호기 도구가 설치되어 있지 않습니다."
fi

cat $result

echo ; echo

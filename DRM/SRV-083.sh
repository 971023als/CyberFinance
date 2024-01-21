#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-083] 시스템 스타트업 스크립트 권한 설정 미흡

cat << EOF >> $result
[양호]: 시스템 스타트업 스크립트의 권한이 적절히 설정된 경우
[취약]: 시스템 스타트업 스크립트의 권한이 적절히 설정되지 않은 경우
EOF

BAR

# 시스템 스타트업 스크립트 디렉터리 목록
STARTUP_DIRS=("/etc/init.d" "/etc/rc.d" "/etc/systemd" "/usr/lib/systemd")

# 각 스타트업 스크립트의 권한 확인
for dir in "${STARTUP_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    scripts=$(find "$dir" -type f -name "*.sh" -o -name "*.service")
    for script in $scripts; do
      permissions=$(stat -c "%a" "$script")
      if [ "$permissions" -le "755" ]; then
        OK "$script 스크립트의 권한이 적절합니다. (권한: $permissions)"
      else
        WARN "$script 스크립트의 권한이 적절하지 않습니다. (권한: $permissions)"
      fi
    done
  else
    INFO "$dir 디렉터리가 존재하지 않습니다."
  fi
done

cat $result

echo ; echo

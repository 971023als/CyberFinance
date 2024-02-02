#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-082] 시스템 주요 디렉터리 권한 설정 미흡

cat << EOF >> $result
[양호]: 시스템 주요 디렉터리의 권한이 적절히 설정된 경우
[취약]: 시스템 주요 디렉터리의 권한이 적절히 설정되지 않은 경우
EOF

BAR

# 주요 시스템 디렉터리 목록
KEY_DIRS=("/etc" "/var" "/home" "/usr" "/bin" "/sbin")

# 각 디렉토리의 권한 확인
for dir in "${KEY_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    permissions=$(stat -c "%a" "$dir")
    if [ "$permissions" -le "755" ]; then
      OK "$dir 디렉터리의 권한이 적절합니다. (권한: $permissions)"
    else
      WARN "$dir 디렉터리의 권한이 적절하지 않습니다. (권한: $permissions)"
    fi
  else
    INFO "$dir 디렉터리가 존재하지 않습니다."
  fi
done

cat $result

echo ; echo

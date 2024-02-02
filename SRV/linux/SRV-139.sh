#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡

cat << EOF >> $result
[양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우
[취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우
EOF

BAR

# 중요 시스템 파일 및 디렉토리 목록
critical_files=("/etc/passwd" "/etc/shadow" "/etc/group" "/etc/gshadow")

for file in "${critical_files[@]}"; do
  if [ -e "$file" ]; then
    owner=$(stat -c %U "$file")
    # 중요 시스템 파일의 소유자가 root인지 확인
    if [ "$owner" != "root" ]; then
      WARN "$file의 소유자가 root가 아닙니다: 현재 소유자는 $owner입니다"
    else
      OK "$file의 소유자는 적절히 root로 설정되어 있습니다"
    fi
  else
    INFO "$file 파일이 존재하지 않습니다"
  fi
done

cat $result

echo ; echo

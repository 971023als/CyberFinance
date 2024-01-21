#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-095] 존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재

cat << EOF >> $result
[양호]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 없는 경우
[취약]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 있는 경우
EOF

BAR

# 모든 파일과 디렉터리를 검사하여 존재하지 않는 소유자나 그룹을 찾습니다
invalid_files=$(find / -nouser -o -nogroup 2>/dev/null)

if [ -z "$invalid_files" ]; then
  OK "존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 없습니다."
else
  WARN "다음은 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리입니다:"
  INFO "$invalid_files"
fi

cat $result

echo ; echo

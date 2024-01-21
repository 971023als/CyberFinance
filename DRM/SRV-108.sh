#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-108] 로그에 대한 접근통제 및 관리 미흡

cat << EOF >> $result
[양호]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있는 경우
[취약]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있지 않은 경우
EOF

BAR

# 로그 파일 목록
log_files=("/var/log/messages" "/var/log/secure" "/var/log/maillog" "/var/log/cron")

# 각 로그 파일의 소유자 및 권한을 확인합니다.
for file in "${log_files[@]}"; do
  if [ -f "$file" ]; then
    owner=$(stat -c '%U' "$file")
    permissions=$(stat -c '%a' "$file")

    if [ "$owner" != "root" ]; then
      WARN "$file 파일의 소유자가 root가 아닙니다."
    else
      OK "$file 파일의 소유자가 root입니다."
    fi

    if [ "$permissions" -gt 640 ]; then
      WARN "$file 파일의 권한이 640보다 큽니다."
    else
      OK "$file 파일의 권한이 640 이하입니다."
    fi
  else
    WARN "$file 파일이 존재하지 않습니다."
  fi
done

cat $result

echo ; echo

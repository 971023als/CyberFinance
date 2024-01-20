#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-081] Crontab 설정파일 권한 설정 미흡

cat << EOF >> $result
[양호]: Crontab 설정파일의 권한이 적절히 설정된 경우
[취약]: Crontab 설정파일의 권한이 적절히 설정되지 않은 경우
EOF

BAR

# Crontab 파일 및 디렉토리 경로
CRON_FILES=("/etc/crontab" "/etc/cron.hourly" "/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.monthly" "/var/spool/cron")

# 각 파일 및 디렉토리의 권한 확인
for file in "${CRON_FILES[@]}"; do
  if [ -e "$file" ]; then
    permissions=$(stat -c "%a" "$file")
    if [[ "$permissions" == "600" || "$permissions" == "700" ]]; then
      OK "$file의 권한이 적절히 설정되었습니다. (권한: $permissions)"
    else
      WARN "$file의 권한이 적절하지 않습니다. (권한: $permissions)"
    fi
  else
    INFO "$file 파일이 존재하지 않습니다."
  fi
done

cat $result

echo ; echo

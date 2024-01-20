#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-101] 불필요한 예약된 작업 존재

cat << EOF >> $result
[양호]: 불필요한 cron 작업이 존재하지 않는 경우
[취약]: 불필요한 cron 작업이 존재하는 경우
EOF

BAR

# 시스템의 모든 cron 작업을 검사합니다
for user in $(cut -f1 -d: /etc/passwd); do
  crontab -l -u $user 2>/dev/null | grep -v '^#' | while read -r cron_job; do
    if [ -n "$cron_job" ]; then
      WARN "불필요한 cron 작업이 존재할 수 있습니다: $cron_job (사용자: $user)"
    fi
  done
done

OK "불필요한 cron 작업이 존재하지 않습니다."

cat $result

echo ; echo

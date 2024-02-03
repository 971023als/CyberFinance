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

filename="/etc/rsyslog.conf"

if [ ! -e "$filename" ]; then
  WARN "$filename 가 존재하지 않습니다"
fi

expected_content=(
  "*.info;mail.none;authpriv.none;cron.none /var/log/messages"
  "authpriv.* /var/log/secure"
  "mail.* /var/log/maillog"
  "cron.* /var/log/cron"
  "*.alert /dev/console"
  "*.emerg *"
)

match=0
for content in "${expected_content[@]}"; do
  if grep -q "$content" "$filename"; then
    match=$((match + 1))
  fi
done

if [ "$match" -eq "${#expected_content[@]}" ]; then
  OK "$filename의 내용이 정확합니다."
else
  WARN "$filename의 내용이 잘못되었습니다."
fi

cat $result

echo ; echo

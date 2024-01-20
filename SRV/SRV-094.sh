#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-094] crontab 참조파일 권한 설정 미흡

cat << EOF >> $result
[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우
[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우
EOF

BAR

# /etc/rsyslog.conf 파일의 존재 여부 및 내용을 확인합니다
filename="/etc/rsyslog.conf"
if [ ! -e "$filename" ]; then
  WARN "$filename 가 존재하지 않습니다"
else
  # 필요한 로그 설정 내용을 배열로 정의합니다
  expected_content=(
    "*.info;mail.none;authpriv.none;cron.none /var/log/messages"
    "authpriv.* /var/log/secure"
    "mail.* /var/log/maillog"
    "cron.* /var/log/cron"
    "*.alert /dev/console"
    "*.emerg *"
  )

  # 파일 내에서 각 설정이 존재하는지 확인합니다
  match=0
  for content in "${expected_content[@]}"; do
    if grep -q "$content" "$filename"; then
      match=$((match + 1))
    fi
  done

  # 모든 필요한 설정이 존재하는지 결과를 출력합니다
  if [ "$match" -eq "${#expected_content[@]}" ]; then
    OK "$filename의 내용이 정확합니다."
  else
    WARN "$filename의 내용에 일부 설정이 누락되었습니다."
  fi
fi

cat $result

echo ; echo

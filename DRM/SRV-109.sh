#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-109] 시스템 주요 이벤트 로그 설정 미흡

cat << EOF >> $result
[양호]: 주요 이벤트 로그 설정이 적절하게 구성되어 있는 경우
[취약]: 주요 이벤트 로그 설정이 적절하게 구성되어 있지 않은 경우
EOF

BAR

# 이벤트 로그 파일 및 설정 확인
log_files=("/var/log/messages" "/var/log/secure" "/var/log/maillog" "/var/log/cron")

for file in "${log_files[@]}"; do
  if [ ! -f "$file" ]; then
    WARN "$file 파일이 존재하지 않습니다."
  else
    OK "$file 파일이 존재합니다."
  fi
done

# rsyslog.conf 설정 확인
rsyslog_conf="/etc/rsyslog.conf"
if [ ! -f "$rsyslog_conf" ]; then
  WARN "rsyslog.conf 파일이 존재하지 않습니다."
else
  if grep -q "authpriv.*" "$rsyslog_conf" && grep -q "cron.*" "$rsyslog_conf" && grep -q "*.emerg" "$rsyslog_conf"; then
    OK "rsyslog.conf 설정이 적절합니다."
  else
    WARN "rsyslog.conf 설정이 적절하지 않습니다."
  fi
fi

cat $result

echo ; echo

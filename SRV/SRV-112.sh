#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-112] Cron 서비스 로깅 미설정

cat << EOF >> $result
[양호]: Cron 서비스 로깅이 적절하게 설정되어 있는 경우
[취약]: Cron 서비스 로깅이 적절하게 설정되어 있지 않은 경우
EOF

BAR

# rsyslog.conf 파일에서 Cron 로깅 설정 확인
rsyslog_conf="/etc/rsyslog.conf"
if [ ! -f "$rsyslog_conf" ]; then
  WARN "rsyslog.conf 파일이 존재하지 않습니다."
else
  if grep -q "cron.*" "$rsyslog_conf"; then
    OK "Cron 로깅이 rsyslog.conf에서 설정되었습니다."
  else
    WARN "Cron 로깅이 rsyslog.conf에서 설정되지 않았습니다."
  fi
fi

# Cron 로그 파일 존재 여부 확인
cron_log="/var/log/cron"
if [ ! -f "$cron_log" ]; then
  WARN "Cron 로그 파일이 존재하지 않습니다."
else
  OK "Cron 로그 파일이 존재합니다."
fi

cat $result

echo ; echo

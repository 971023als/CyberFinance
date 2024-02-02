#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-133] Cron 서비스 사용 계정 제한 미비

cat << EOF >> $result
[양호]: Cron 서비스 사용이 특정 계정으로 제한되어 있는 경우
[취약]: Cron 서비스 사용이 제한되지 않은 경우
EOF

BAR

# Cron 서비스 사용 계정 제한 확인
cron_allow="/etc/cron.allow"
cron_deny="/etc/cron.deny"

if [ -f "$cron_allow" ]; then
  INFO "cron.allow 파일이 존재합니다."
  if [ ! -s "$cron_allow" ]; then
    WARN "cron.allow 파일이 비어 있습니다."
  else
    OK "cron.allow 파일에 특정 계정이 명시되어 있습니다."
  fi
elif [ -f "$cron_deny" ]; then
  INFO "cron.deny 파일이 존재합니다."
  if [ ! -s "$cron_deny" ]; then
    WARN "cron.deny 파일이 비어 있습니다."
  else
    OK "cron.deny 파일에 특정 계정이 명시되어 있습니다."
  fi
else
  WARN "cron.allow 또는 cron.deny 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

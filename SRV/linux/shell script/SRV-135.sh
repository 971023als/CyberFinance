#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-135] TCP 보안 설정 미비

cat << EOF >> $result
[양호]: 필수 TCP 보안 설정이 적절히 구성된 경우
[취약]: 필수 TCP 보안 설정이 구성되지 않은 경우
EOF

BAR

# TCP 보안 관련 설정 확인
tcp_settings=(
  "net.ipv4.tcp_syncookies"
  "net.ipv4.tcp_max_syn_backlog"
  "net.ipv4.tcp_synack_retries"
  "net.ipv4.tcp_syn_retries"
)

for setting in "${tcp_settings[@]}"; do
  value=$(sysctl $setting)
  if [ -z "$value" ]; then
    WARN "$setting 설정이 없습니다."
  else
    OK "$setting 설정이 존재합니다: $value"
  fi
done

cat $result

echo ; echo

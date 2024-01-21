#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-008] SMTP 서비스의 DoS 방지 기능 미설정

cat << EOF >> $result
[양호]: SMTP 서비스에 DoS 방지 설정이 적용된 경우
[취약]: SMTP 서비스에 DoS 방지 설정이 적용되지 않은 경우
EOF

BAR

# Postfix 설정에서 DoS 방지 관련 설정을 확인합니다.
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
DOS_SETTINGS=("smtpd_client_connection_rate_limit" "anvil_rate_time_unit")

for setting in "${DOS_SETTINGS[@]}"; do
  if grep -q "^$setting" "$POSTFIX_MAIN_CF"; then
    OK "DoS 방지 설정 $setting 이 적용되어 있습니다."
  else
    WARN "DoS 방지 설정 $setting 이 적용되어 있지 않습니다."
  fi
done

cat $result

echo ; echo

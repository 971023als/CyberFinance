#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-004] 불필요한 SMTP 서비스 실행

cat << EOF >> $result
[양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우
[취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우
EOF

BAR

# SMTP 서비스 (예: postfix, sendmail 등)가 실행 중인지 확인합니다.
SMTP_SERVICES=("sendmail" "postfix" "exim")

for service in "${SMTP_SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    WARN "$service 서비스가 실행 중입니다."
  else
    OK "$service 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
  fi
done

cat $result

echo ; echo


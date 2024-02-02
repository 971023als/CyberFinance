#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-048] 불필요한 웹 서비스 실행

cat << EOF >> $result
[양호]: 불필요한 웹 서비스가 실행되지 않고 있는 경우
[취약]: 불필요한 웹 서비스가 실행되고 있는 경우
EOF

BAR

# 웹 서비스 목록
WEB_SERVICES=("apache2" "nginx" "httpd" "lighttpd")

for service in "${WEB_SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    WARN "$service 웹 서비스가 실행 중입니다."
  else
    OK "$service 웹 서비스가 실행되지 않고 있습니다."
  fi
done

cat $result

echo ; echo

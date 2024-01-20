#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-045] 웹 서비스 프로세스 권한 제한 미비

cat << EOF >> $result
[양호]: 웹 서비스 프로세스가 root 권한으로 실행되지 않는 경우
[취약]: 웹 서비스 프로세스가 root 권한으로 실행되는 경우
EOF

BAR

# Apache 또는 Nginx 프로세스의 사용자 권한 확인
# 예시로 Apache(httpd)와 Nginx(nginx) 서비스의 사용자 권한을 확인합니다.
# 실제 환경에 따라 서비스 이름을 조정하세요.

for service in "apache2" "nginx"; do
  if pgrep -u root -x "$service" > /dev/null; then
    WARN "$service 서비스가 root 권한으로 실행되고 있습니다."
  else
    OK "$service 서비스가 root 권한으로 실행되지 않습니다."
  fi
done

cat $result

echo ; echo

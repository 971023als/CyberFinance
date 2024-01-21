#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-055] 웹 서비스 설정 파일 노출

cat << EOF >> $result
[양호]: 웹 서비스 설정 파일이 외부에서 접근 불가능한 경우
[취약]: 웹 서비스 설정 파일이 외부에서 접근 가능한 경우
EOF

BAR

# 웹 서비스 설정 파일의 예시 경로
APACHE_CONFIG="/etc/apache2/apache2.conf"
NGINX_CONFIG="/etc/nginx/nginx.conf"

# Apache 설정 파일의 접근 권한 확인
if [ -f "$APACHE_CONFIG" ]; then
  if ls -l "$APACHE_CONFIG" | grep -qE "^-rw-------"; then
    OK "Apache 설정 파일($APACHE_CONFIG)이 외부 접근으로부터 보호됩니다."
  else
    WARN "Apache 설정 파일($APACHE_CONFIG)의 접근 권한이 취약합니다."
  fi
else
  INFO "Apache 설정 파일($APACHE_CONFIG)이 존재하지 않습니다."
fi

# Nginx 설정 파일의 접근 권한 확인
if [ -f "$NGINX_CONFIG" ]; then
  if ls -l "$NGINX_CONFIG" | grep -qE "^-rw-------"; then
    OK "Nginx 설정 파일($NGINX_CONFIG)이 외부 접근으로부터 보호됩니다."
  else
    WARN "Nginx 설정 파일($NGINX_CONFIG)의 접근 권한이 취약합니다."
  fi
else
  INFO "Nginx 설정 파일($NGINX_CONFIG)이 존재하지 않습니다."
fi

cat $result

echo ; echo

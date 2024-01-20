#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-046] 웹 서비스 경로 설정 미흡

cat << EOF >> $result
[양호]: 웹 서비스의 경로 설정이 안전하게 구성된 경우
[취약]: 웹 서비스의 경로 설정이 취약하게 구성된 경우
EOF

BAR

# Apache 또는 Nginx 웹 서비스의 경로 설정 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"
NGINX_CONFIG_FILE="/etc/nginx/nginx.conf"

# Apache 설정 확인
if [ -f "$APACHE_CONFIG_FILE" ]; then
    if grep -qE "^[ \t]*<Directory" "$APACHE_CONFIG_FILE" && grep -qE "Options -Indexes" "$APACHE_CONFIG_FILE"; then
        OK "Apache 설정에서 적절한 경로 설정이 확인됨: $APACHE_CONFIG_FILE"
    else
        WARN "Apache 설정에서 취약한 경로 설정이 확인됨: $APACHE_CONFIG_FILE"
    fi
else
    INFO "Apache 설정 파일이 존재하지 않습니다: $APACHE_CONFIG_FILE"
fi

# Nginx 설정 확인
if [ -f "$NGINX_CONFIG_FILE" ]; then
    if grep -qE "^[ \t]*location" "$NGINX_CONFIG_FILE"; then
        OK "Nginx 설정에서 적절한 경로 설정이 확인됨: $NGINX_CONFIG_FILE"
    else
        WARN "Nginx 설정에서 취약한 경로 설정이 확인됨: $NGINX_CONFIG_FILE"
   

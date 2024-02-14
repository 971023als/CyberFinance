#!/bin/bash

. function.sh

BAR

CODE [SRV-058] 웹 서비스의 불필요한 스크립트 매핑 존재

cat << EOF >> $result
[양호]: 웹 서비스에서 불필요한 스크립트 매핑이 존재하지 않는 경우
[취약]: 웹 서비스에서 불필요한 스크립트 매핑이 존재하는 경우
EOF

BAR

# Apache 또는 Nginx 웹 서비스의 스크립트 매핑 설정 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"
NGINX_CONFIG_FILE="/etc/nginx/nginx.conf"

# Apache에서 스크립트 매핑 설정 확인
if grep -E "AddHandler|AddType" "$APACHE_CONFIG_FILE"; then
    WARN "Apache에서 불필요한 스크립트 매핑이 발견됨: $APACHE_CONFIG_FILE"
else
    OK "Apache에서 불필요한 스크립트 매핑이 발견되지 않음: $APACHE_CONFIG_FILE"
fi

# Nginx에서 스크립트 매핑 설정 확인
if grep -E "location ~ \.php$" "$NGINX_CONFIG_FILE"; then
    WARN "Nginx에서 불필요한 PHP 스크립트 매핑이 발견됨: $NGINX_CONFIG_FILE"
else
    OK "Nginx에서 불필요한 PHP 스크립트 매핑이 발견되지 않음: $NGINX_CONFIG_FILE"
fi

cat $result

echo ; echo

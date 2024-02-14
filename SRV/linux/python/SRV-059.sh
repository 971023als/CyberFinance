#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-059] 웹 서비스 서버 명령 실행 기능 제한 설정 미흡

cat << EOF >> $result
[양호]: 웹 서비스에서 서버 명령 실행 기능이 적절하게 제한된 경우
[취약]: 웹 서비스에서 서버 명령 실행 기능의 제한이 미흡한 경우
EOF

BAR

# Apache 또는 Nginx 웹 서비스의 서버 명령 실행 제한 설정 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"
NGINX_CONFIG_FILE="/etc/nginx/nginx.conf"

# Apache에서 서버 명령 실행 제한 확인
if grep -E "^[ \t]*ScriptAlias" "$APACHE_CONFIG_FILE"; then
    WARN "Apache에서 서버 명령 실행이 허용될 수 있습니다: $APACHE_CONFIG_FILE"
else
    OK "Apache에서 서버 명령 실행 기능이 적절하게 제한됩니다: $APACHE_CONFIG_FILE"
fi

# Nginx에서 FastCGI 스크립트 실행 제한 확인
if grep -E "fastcgi_pass" "$NGINX_CONFIG_FILE"; then
    WARN "Nginx에서 FastCGI를 통한 서버 명령 실행이 허용될 수 있습니다: $NGINX_CONFIG_FILE"
else
    OK "Nginx에서 FastCGI를 통한 서버 명령 실행 기능이 적절하게 제한됩니다: $NGINX_CONFIG_FILE"
fi

cat $result

echo ; echo

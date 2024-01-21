#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-172] 불필요한 시스템 자원 공유 존재

cat << EOF >> $result
[양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우
[취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우
EOF

BAR

# Apache 서버에서 ServerTokens 및 ServerSignature 설정 확인
apache_config="/etc/apache2/apache2.conf"
if [ -f "$apache_config" ]; then
    server_tokens=$(grep -i 'ServerTokens Prod' "$apache_config")
    server_signature=$(grep -i 'ServerSignature Off' "$apache_config")

    if [[ "$server_tokens" == "ServerTokens Prod" ]] && [[ "$server_signature" == "ServerSignature Off" ]]; then
        OK "Apache 서버에서 버전 정보 및 운영체제 정보 노출이 제한됩니다."
    else
        WARN "Apache 서버에서 버전 정보 및 운영체제 정보가 노출됩니다."
    fi
else
    INFO "Apache 서버 설정 파일이 존재하지 않습니다."
fi

# Nginx 서버에서 버전 정보 노출 설정 확인
nginx_config="/etc/nginx/nginx.conf"
if [ -f "$nginx_config" ]; then
    if grep -q 'server_tokens off;' "$nginx_config"; then
        OK "Nginx 서버에서 버전 정보 노출이 제한됩니다."
    else
        WARN "Nginx 서버에서 버전 정보가 노출됩니다."
    fi
else
    INFO "Nginx 서버 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

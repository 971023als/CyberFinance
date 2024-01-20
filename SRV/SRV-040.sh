#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-040] 웹 서비스 디렉터리 리스팅 방지 설정 미흡

cat << EOF >> $result
[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우
[취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우
EOF

BAR

# Apache 설정 파일 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"

# 디렉터리 리스팅 방지 설정 확인
# 예: 'Options -Indexes' 설정을 찾습니다
if grep -qE "^[ \t]*<Directory /var/www/>" "$APACHE_CONFIG_FILE"; then
    if grep -qE "^[ \t]*Options.*-Indexes" "$APACHE_CONFIG_FILE"; then
        OK "웹 서비스에서 디렉터리 리스팅이 방지되고 있습니다."
    else
        WARN "웹 서비스에서 디렉터리 리스팅 방지 설정이 미흡합니다."
    fi
else
    WARN "웹 서비스의 주요 디렉터리 설정을 찾을 수 없습니다."
fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡

cat << EOF >> $result
[양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우
[취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우
EOF

BAR

# 확인할 Apache2 Document Root 디렉토리 설정
APACHE_SITES_AVAILABLE="/etc/apache2/sites-available/*.conf"

# DocumentRoot 설정을 확인합니다.
if grep -q -E "^DocumentRoot /var/www/html" $APACHE_SITES_AVAILABLE; then
    WARN "일부 사이트에서 DocumentRoot가 기본 경로(/var/www/html)로 설정되어 있습니다."
else
    OK "DocumentRoot가 기본 경로로 설정되지 않았습니다."
fi

cat $result

echo ; echo

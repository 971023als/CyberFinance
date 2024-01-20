#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-044] 웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정

cat << EOF >> $result
[양호]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 적절하게 제한된 경우
[취약]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 제한되지 않은 경우
EOF

BAR

# Apache 설정 파일 확인
APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"

# 파일 업로드 및 다운로드 제한 설정 확인
# 예: 'LimitRequestBody' 지시어를 확인
if grep -qE "^LimitRequestBody" "$APACHE_CONFIG_FILE"; then
    upload_limit=$(grep "^LimitRequestBody" "$APACHE_CONFIG_FILE" | awk '{print $NF}')
    if [ "$upload_limit" -gt 0 ]; then
        OK "Apache에서 파일 업로드 용량이 제한됩니다: $upload_limit Bytes"
    else
        WARN "Apache에서 파일 업로드 용량 제한이 설정되지 않았습니다."
    fi
else
    WARN "Apache 설정 파일에서 'LimitRequestBody' 지시어가 누락되었습니다."
fi

cat $result

echo ; echo

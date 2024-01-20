#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재

cat << EOF >> $result
[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하는 경우
EOF

BAR

# 웹 서비스 경로 설정
WEB_SERVICE_PATH="/var/www/html" # 실제 경로에 맞게 조정하세요.

# 웹 서비스 경로 내에서 심볼릭 링크 찾기
found_links=$(find "$WEB_SERVICE_PATH" -type l)

if [ -n "$found_links" ]; then
    WARN "웹 서비스 경로 내에 불필요한 심볼릭 링크가 존재합니다: $found_links"
else
    OK "웹 서비스 경로 내에 불필요한 심볼릭 링크가 존재하지 않습니다."
fi

cat $result

echo ; echo

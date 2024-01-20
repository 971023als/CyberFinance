#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-057] 웹 서비스 경로 내 파일의 접근 통제 미흡

cat << EOF >> $result
[양호]: 웹 서비스 경로 내 파일의 접근 권한이 적절하게 설정된 경우
[취약]: 웹 서비스 경로 내 파일의 접근 권한이 적절하게 설정되지 않은 경우
EOF

BAR

# 웹 서비스 경로 설정
WEB_SERVICE_PATH="/var/www/html" # 실제 경로에 맞게 조정하세요.

# 웹 서비스 경로 내 파일 접근 권한 확인
# 예: 파일 권한이 755 이상으로 설정되어 있는지 확인
incorrect_permissions=$(find "$WEB_SERVICE_PATH" -type f ! -perm -755)

if [ -n "$incorrect_permissions" ]; then
    WARN "웹 서비스 경로 내에 부적절한 파일 권한이 있습니다."
else
    OK "웹 서비스 경로 내의 모든 파일의 권한이 적절하게 설정되어 있습니다."
fi

cat $result

echo ; echo

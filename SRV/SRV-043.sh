#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-043] 웹 서비스 경로 내 불필요한 파일 존재

cat << EOF >> $result
[양호]: 웹 서비스 경로에 불필요한 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로에 불필요한 파일이 존재하는 경우
EOF

BAR

# 웹 서비스 경로 설정
WEB_SERVICE_PATH="/var/www/html" # 예시 경로입니다. 실제 환경에 맞게 조정하세요.

# 불필요하거나 위험한 파일 형식을 정의합니다.
# 예시: .bak, .tmp, .old 파일
UNNECESSARY_FILES=("*.bak" "*.tmp" "*.old")

# 웹 서비스 경로에서 불필요한 파일 찾기
for file_type in "${UNNECESSARY_FILES[@]}"; do
  if find "$WEB_SERVICE_PATH" -name "$file_type"; then
    WARN "$WEB_SERVICE_PATH 경로에 불필요한 파일이 있습니다: $file_type"
  else
    OK "$WEB_SERVICE_PATH 경로에 불필요한 파일이 없습니다: $file_type"
  fi
done

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-007] 취약한 버전의 SMTP 서비스 사용

cat << EOF >> $result
[양호]: 최신 버전의 SMTP 서비스를 사용하는 경우
[취약]: 구버전 또는 취약한 버전의 SMTP 서비스를 사용하는 경우
EOF

BAR

# Postfix 버전 확인
POSTFIX_VERSION=$(postconf mail_version 2>/dev/null | grep -oP 'mail_version = \K.*')

# 여기서 'safe_versions'는 안전하다고 알려진 버전의 목록입니다.
# 이 리스트는 실제 환경에 따라 업데이트 되어야 합니다.
safe_versions=('3.5.8' '3.4.14' '3.3.20' '3.2.36' '3.1.15' '2.11.13')

if [[ " ${safe_versions[@]} " =~ " ${POSTFIX_VERSION} " ]]; then
  OK "안전한 버전의 Postfix를 사용 중입니다: ${POSTFIX_VERSION}"
else
  WARN "취약할 수 있는 버전의 Postfix를 사용 중입니다: ${POSTFIX_VERSION}"
fi

cat $result

echo ; echo

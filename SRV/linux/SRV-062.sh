#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-062] DNS 서비스 정보 노출

cat << EOF >> $result
[양호]: DNS 서비스 정보가 안전하게 보호되고 있는 경우
[취약]: DNS 서비스 정보가 노출되고 있는 경우
EOF

BAR

# DNS 설정 파일 경로
DNS_CONFIG_FILE="/etc/bind/named.conf"  # BIND 사용 예시, 실제 환경에 따라 달라질 수 있음

# 버전 정보 숨김 옵션 확인
if grep -qE "version \"none\"" "$DNS_CONFIG_FILE"; then
    OK "DNS 서비스에서 버전 정보가 숨겨져 있습니다."
else
    WARN "DNS 서비스에서 버전 정보가 노출될 수 있습니다."
fi

# 불필요한 전송 허용 확인
if grep -qE "allow-transfer" "$DNS_CONFIG_FILE"; then
    WARN "DNS 서비스에서 불필요한 Zone Transfer가 허용될 수 있습니다."
else
    OK "DNS 서비스에서 불필요한 Zone Transfer가 제한됩니다."
fi

cat $result

echo ; echo

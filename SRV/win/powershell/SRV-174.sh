#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-174] 불필요한 DNS 서비스 실행

cat << EOF >> $result
[양호]: DNS 서비스가 비활성화되어 있는 경우
[취약]: DNS 서비스가 활성화되어 있는 경우
EOF

BAR

# DNS 서비스 상태 확인 (named 서비스 예시)
dns_service_status=$(systemctl is-active named)

if [ "$dns_service_status" == "active" ]; then
    WARN "DNS 서비스(named)가 활성화되어 있습니다."
else
    OK "DNS 서비스(named)가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

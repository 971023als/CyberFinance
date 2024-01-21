#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-064] 취약한 버전의 DNS 서비스 사용

cat << EOF >> $result
[양호]: DNS 서비스가 최신 버전으로 업데이트되어 있는 경우
[취약]: DNS 서비스가 최신 버전으로 업데이트되어 있지 않은 경우
EOF

BAR

# DNS 서버 소프트웨어 확인 (예: BIND)
dns_server="bind9"

# DNS 서버 버전 확인
dns_version=$(named -v | grep BIND)

# 최신 버전 정보 확인을 위한 로직이 필요 (여기서는 예시만 제공)
# 실제로는 DNS 서버의 최신 버전 정보를 얻기 위한 외부 API 또는 데이터베이스 확인이 필요할 수 있음
latest_version="BIND 9.16.1" # 최신 버전 정보 예시

if [[ "$dns_version" == *"$latest_version"* ]]; then
    OK "DNS 서버가 최신 버전입니다: $dns_version"
else
    WARN "DNS 서버가 최신 버전이 아닐 수 있습니다: $dns_version"
fi

cat $result

echo ; echo

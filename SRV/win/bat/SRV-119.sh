#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-119] 백신 프로그램 업데이트 미흡

cat << EOF >> $result
[양호]: 백신 프로그램이 최신 버전으로 업데이트 되어 있는 경우
[취약]: 백신 프로그램이 최신 버전으로 업데이트 되어 있지 않은 경우
EOF

BAR

# 백신 프로그램의 업데이트 상태를 확인합니다 (예시: ClamAV)
clamav_version=$(clamscan --version)
latest_clamav_version=$(curl -s https://www.clamav.net/downloads | grep -oP 'ClamAV \K[0-9.]+')

if [ "$clamav_version" == "$latest_clamav_version" ]; then
  OK "ClamAV가 최신 버전입니다: $clamav_version"
else
  WARN "ClamAV가 최신 버전이 아닙니다. 현재 버전: $clamav_version, 최신 버전: $latest_clamav_version"
fi

cat $result

echo ; echo

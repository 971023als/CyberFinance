#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-090] 불필요한 원격 레지스트리 서비스 활성화

cat << EOF >> $result
[양호]: 원격 레지스트리 서비스가 비활성화되어 있는 경우
[취약]: 원격 레지스트리 서비스가 활성화되어 있는 경우
EOF

BAR

# 원격 레지스트리 서비스 상태 확인
if systemctl is-active --quiet remote-registry; then
    WARN "원격 레지스트리 서비스가 활성화되어 있습니다."
else
    OK "원격 레지스트리 서비스가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

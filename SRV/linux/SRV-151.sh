#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-151] 익명 SID/이름 변환 허용

cat << EOF >> $result
[양호]: 익명 SID/이름 변환을 허용하지 않는 경우
[취약]: 익명 SID/이름 변환을 허용하는 경우
EOF

BAR

# 익명 SID/이름 변환 정책 확인
if secpol.exe /export /cfg secpol.cfg; then
    if grep -q "SeDenyNetworkLogonRight = *S-1-1-0" secpol.cfg; then
        OK "익명 SID/이름 변환을 허용하지 않습니다."
    else
        WARN "익명 SID/이름 변환을 허용합니다."
    fi
    rm secpol.cfg
else
    WARN "보안 정책 파일을 추출할 수 없습니다."
fi

cat $result

echo ; echo

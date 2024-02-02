#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-127] 계정 잠금 임계값 설정 미비

cat << EOF >> $result
[양호]: 계정 잠금 임계값이 적절하게 설정된 경우
[취약]: 계정 잠금 임계값이 적절하게 설정되지 않은 경우
EOF

BAR

# PAM 설정 확인
pam_file="/etc/pam.d/common-auth"
if [ -e "$pam_file" ]; then
    if grep -q "deny=[1-9]" "$pam_file"; then
        OK "계정 잠금 임계값이 적절하게 설정되어 있습니다."
    else
        WARN "계정 잠금 임계값이 설정되어 있지 않거나 너무 높습니다."
    fi
else
    WARN "PAM 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

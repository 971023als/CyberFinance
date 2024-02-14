#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-070] 취약한 패스워드 저장 방식 사용

cat << EOF >> $result
[양호]: 패스워드 저장에 강력한 해싱 알고리즘을 사용하는 경우
[취약]: 패스워드 저장에 취약한 해싱 알고리즘을 사용하는 경우
EOF

BAR

# 패스워드 해싱 알고리즘 확인
PAM_FILE="/etc/pam.d/common-password"

# MD5, DES와 같이 취약한 알고리즘을 확인합니다
if grep -Eq "md5|des" "$PAM_FILE"; then
    WARN "취약한 패스워드 해싱 알고리즘이 사용 중입니다: $PAM_FILE"
else
    OK "강력한 패스워드 해싱 알고리즘이 사용 중입니다: $PAM_FILE"
fi

cat $result

echo ; echo

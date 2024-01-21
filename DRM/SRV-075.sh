#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-075] 유추 가능한 계정 비밀번호 존재

cat << EOF >> $result
[양호]: 암호 정책이 강력하게 설정되어 있는 경우
[취약]: 암호 정책이 약하게 설정되어 있는 경우
EOF

BAR

# PAM 암호 정책 파일 경로
PAM_PWQUALITY_CONF="/etc/security/pwquality.conf"

# PAM 암호 정책 확인
if [ -f "$PAM_PWQUALITY_CONF" ]; then
    min_len=$(grep -E "^minlen" "$PAM_PWQUALITY_CONF" | awk '{print $3}')
    min_class=$(grep -E "^minclass" "$PAM_PWQUALITY_CONF" | awk '{print $3}')

    if [ "$min_len" -ge 8 ] && [ "$min_class" -ge 3 ]; then
        OK "암호 정책이 강력합니다. (최소 길이: $min_len, 최소 종류: $min_class)"
    else
        WARN "암호 정책이 약합니다."
    fi
else
    WARN "PAM 암호 정책 파일($PAM_PWQUALITY_CONF)이 존재하지 않습니다."
fi

cat $result

echo ; echo

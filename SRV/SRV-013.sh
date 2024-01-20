#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비

cat << EOF >> $result
[양호]: Anonymous 계정의 FTP 접속이 적절하게 제한되어 있는 경우
[취약]: Anonymous 계정의 FTP 접속 제한이 미비한 경우
EOF

BAR

# FTP 서비스 구성 파일에서 익명 사용자 접속을 확인합니다.
FTP_CONFIG_FILE="/etc/vsftpd.conf" # vsFTPd 예시입니다. 실제 환경에 맞게 조정해야 합니다.

# 익명 사용자 접속을 제한하는 설정 확인
if grep -q "^anonymous_enable=NO" "$FTP_CONFIG_FILE"; then
    OK "Anonymous 계정의 FTP 접속이 제한됩니다."
else
    WARN "Anonymous 계정의 FTP 접속이 적절하게 제한되지 않습니다."
fi

cat $result

echo ; echo

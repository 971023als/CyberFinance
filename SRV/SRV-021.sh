#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-021] FTP 서비스 접근 제어 설정 미비

cat << EOF >> $result
[양호]: Anonymous FTP (익명 ftp) 접속이 차단된 경우
[취약]: Anonymous FTP (익명 ftp) 접속이 차단되지 않은 경우
EOF

BAR

# FTP 서비스 구성 파일에서 익명 사용자 접속을 확인합니다.
FTP_CONFIG_FILE="/etc/vsftpd.conf" # vsFTPd 예시입니다. 실제 환경에 맞게 조정해야 합니다.

# 익명 사용자 접속을 제한하는 설정 확인
if grep -q "^anonymous_enable=NO" "$FTP_CONFIG_FILE"; then
    OK "Anonymous FTP 접속이 차단됩니다."
else
    WARN "Anonymous FTP 접속이 허용됩니다."
fi

cat $result

echo ; echo

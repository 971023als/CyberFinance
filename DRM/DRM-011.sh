#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비

cat << EOF >> $result
[양호]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되는 경우
[취약]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되지 않는 경우
EOF

BAR

# FTP 구성 파일에서 루트 사용자의 접근을 제한하는 설정 확인
FTP_CONFIG_FILE="/etc/ftpusers"

# 'root' 계정의 FTP 접근이 제한되는지 확인합니다.
if grep -q "^root" "$FTP_CONFIG_FILE"; then
    OK "FTP 서비스에서 root 계정의 접근이 제한됩니다."
else
    WARN "FTP 서비스에서 root 계정의 접근이 제한되지 않습니다."
fi

cat $result

echo ; echo

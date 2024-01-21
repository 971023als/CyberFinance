#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-171] FTP 서비스 정보 노출

cat << EOF >> $result
[양호]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우
[취약]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되는 경우
EOF

BAR

# FTP 서버 설정 확인 (예: vsftpd, proftpd 등)
# vsftpd 예시
vsftpd_config="/etc/vsftpd.conf"
if [ -f "$vsftpd_config" ]; then
    if grep -q 'ftpd_banner=' "$vsftpd_config"; then
        OK "vsftpd에서 버전 정보 노출이 제한됩니다."
    else
        WARN "vsftpd에서 버전 정보가 노출됩니다."
    fi
else
    INFO "vsftpd 설정 파일이 존재하지 않습니다."
fi

# ProFTPD 예시
proftpd_config="/etc/proftpd/proftpd.conf"
if [ -f "$proftpd_config" ]; then
    if grep -q 'ServerIdent on "FTP Server ready."' "$proftpd_config"; then
        OK "ProFTPD에서 버전 정보 노출이 제한됩니다."
    else
        WARN "ProFTPD에서 버전 정보가 노출됩니다."
    fi
else
    INFO "ProFTPD 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-037] 취약한 FTP 서비스 실행

cat << EOF >> $result
[양호]: 안전한 FTP 서비스가 활성화되어 있거나 FTP 서비스가 비활성화된 경우
[취약]: 취약한 FTP 서비스가 활성화되어 있는 경우
EOF

BAR

# FTP 서비스의 상태를 확인합니다.
# vsftpd를 예로 들었으나 실제 서비스에 따라 다를 수 있습니다.
FTP_SERVICE="vsftpd"

if systemctl is-active --quiet $FTP_SERVICE; then
    # FTP 서비스의 설정 파일을 추가로 확인할 수 있습니다.
    # 예: /etc/vsftpd.conf 파일에서 anonymous_enable, local_enable 설정 확인
    WARN "$FTP_SERVICE 서비스가 활성화되어 있습니다."
else
    OK "$FTP_SERVICE 서비스가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

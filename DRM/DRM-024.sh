#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-024] 취약한 Telnet 인증 방식 사용

cat << EOF >> $result
[양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우
[취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우
EOF

BAR

# Telnet 서비스 상태를 확인합니다.
if systemctl is-active --quiet telnet.socket; then
    # Telnet 서비스의 보안 설정을 추가로 확인할 수 있습니다.
    # 예: /etc/securetty 파일에서 'pts/' 항목을 확인하는 등
    WARN "Telnet 서비스가 활성화되어 있습니다."
else
    OK "Telnet 서비스가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

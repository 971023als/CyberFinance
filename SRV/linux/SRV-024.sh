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
    # Telnet 서비스가 활성화된 경우, 추가적인 설정 확인이 필요할 수 있음
    # Linux 시스템에서 NTLM 인증 설정을 직접 확인하는 방법은 제한적임
    # 해당 확인은 Windows 환경에 더 적합함
    WARN "Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다."
else
    OK "Telnet 서비스가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

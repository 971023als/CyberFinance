#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-078] 불필요한 Guest 계정 활성화

cat << EOF >> $result
[양호]: 불필요한 Guest 계정이 비활성화 되어 있는 경우
[취약]: 불필요한 Guest 계정이 활성화 되어 있는 경우
EOF

BAR

# Guest 계정 존재 여부 확인
if grep -qi "^guest:" /etc/passwd; then
    guest_shell=$(grep "^guest:" /etc/passwd | cut -d: -f7)

    if [ "$guest_shell" == "/bin/false" ] || [ "$guest_shell" == "/sbin/nologin" ]; then
        OK "Guest 계정이 비활성화 되어 있습니다."
    else
        WARN "Guest 계정이 활성화 되어 있습니다."
    fi
else
    OK "Guest 계정이 존재하지 않습니다."
fi

cat $result

echo ; echo

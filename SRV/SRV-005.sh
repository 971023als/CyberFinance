#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비

cat << EOF >> $result
[양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우
[취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우
EOF

BAR

# Postfix의 경우 main.cf 파일을 검사합니다.
POSTFIX_MAIN_CF="/etc/postfix/main.cf"

# Expn과 Vrfy를 제한하는 설정이 있는지 확인합니다.
if grep -E "^(disable_vrfy_command|disable_expn_command) *= *yes" $POSTFIX_MAIN_CF; then
    OK "SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있습니다."
else
    WARN "SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않습니다."
fi

cat $result

echo ; echo

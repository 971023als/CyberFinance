#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR 

CODE [SRV-009] SMTP 서비스 스팸 메일 릴레이 제한 미설정

cat << EOF >> $result
[양호]: SMTP 서비스에서 스팸 메일 릴레이를 제한하는 설정이 구성된 경우
[취약]: SMTP 서비스에서 스팸 메일 릴레이를 제한하는 설정이 구성되지 않은 경우
EOF

BAR

# Postfix의 main.cf 설정 파일을 확인합니다.
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
RELAY_RESTRICTION_SETTING="mynetworks"

# 릴레이 제한 설정을 확인합니다.
if grep -qE "^$RELAY_RESTRICTION_SETTING\s*=" "$POSTFIX_MAIN_CF"; then
    networks=$(grep -E "^$RELAY_RESTRICTION_SETTING\s*=" "$POSTFIX_MAIN_CF" | cut -d'=' -f2)
    OK "릴레이 제한이 설정되어 있습니다: $networks"
else
    WARN "릴레이 제한 설정이 '$POSTFIX_MAIN_CF' 파일에 구성되어 있지 않습니다."
fi

cat $result

echo ; echo

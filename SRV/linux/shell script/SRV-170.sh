#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-170] SMTP 서비스 정보 노출

cat << EOF >> $result
[양호]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우
[취약]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되는 경우
EOF

BAR

# SMTP 서버 설정 확인 (예: Postfix, Sendmail 등)
# Postfix 예시
postfix_config="/etc/postfix/main.cf"
if [ -f "$postfix_config" ]; then
    if grep -q '^smtpd_banner = $myhostname' "$postfix_config"; then
        OK "Postfix에서 버전 정보 노출이 제한됩니다."
    else
        WARN "Postfix에서 버전 정보가 노출됩니다."
    fi
else
    INFO "Postfix 서버 설정 파일이 존재하지 않습니다."
fi

# Sendmail 예시
sendmail_config="/etc/mail/sendmail.cf"
if [ -f "$sendmail_config" ]; then
    if grep -q 'O SmtpGreetingMessage=$j' "$sendmail_config"; then
        OK "Sendmail에서 버전 정보 노출이 제한됩니다."
    else
        WARN "Sendmail에서 버전 정보가 노출됩니다."
    fi
else
    INFO "Sendmail 서버 설정 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

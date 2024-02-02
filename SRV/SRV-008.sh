#!/bin/bash

. function.sh

TMP1=$(basename "$0").log
> $TMP1

BAR

CODE [SRV-008] SMTP 서비스의 DoS 방지 기능 미설정

cat << EOF >> $TMP1
[양호]: SMTP 서비스에 DoS 방지 설정이 적용된 경우
[취약]: SMTP 서비스에 DoS 방지 설정이 적용되지 않은 경우
EOF

BAR

"[SRV-008] SMTP 서비스의 DoS 방지 기능 미설정" >> $TMP1

# Sendmail configuration check
SENDMAIL_CF="/etc/mail/sendmail.cf"
SENDMAIL_SETTINGS=("MaxDaemonChildren" "ConnectionRateThrottle" "MinFreeBlocks" "MaxHeadersLength" "MaxMessageSize")

echo "Checking Sendmail DoS prevention settings..." >> $TMP1
if [ -f "$SENDMAIL_CF" ]; then
    for setting in "${SENDMAIL_SETTINGS[@]}"; do
        if grep -E -q "^O\s*$setting=" "$SENDMAIL_CF"; then
            echo "OK: $setting is configured." >> $TMP1
        else
            echo "WARN: $setting is not configured." >> $TMP1
        fi
    done
else
    echo "INFO: Sendmail configuration file does not exist." >> $TMP1
fi

# Postfix configuration check
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_SETTINGS=("message_size_limit" "header_size_limit" "default_process_limit" "local_destination_concurrency_limit" "smtpd_recipient_limit")

echo "Checking Postfix DoS prevention settings..." >> $TMP1
if [ -f "$POSTFIX_MAIN_CF" ]; then
    for setting in "${POSTFIX_SETTINGS[@]}"; do
        if grep -q "^$setting" "$POSTFIX_MAIN_CF"; then
            echo "OK: $setting is configured." >> $TMP1
        else
            echo "WARN: $setting is not explicitly configured (may use default values)." >> $TMP1
        fi
    done
else
    echo "INFO: Postfix configuration file does not exist." >> $TMP1
fi

cat $TMP1
echo ; echo

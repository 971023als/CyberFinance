#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡

cat << EOF >> $result
[양호]: SMTP 서비스의 메일 queue 디렉터리가 적절한 권한으로 설정된 경우
[취약]: SMTP 서비스의 메일 queue 디렉터리 권한이 미흡한 경우
EOF

BAR

# Postfix 메일 queue 디렉터리의 권한 확인
MAIL_QUEUE_DIR="/var/spool/postfix"
EXPECTED_PERMISSIONS="700"

directory_permissions=$(stat -c "%a" "$MAIL_QUEUE_DIR")

if [ "$directory_permissions" -eq "$EXPECTED_PERMISSIONS" ]; then
    OK "SMTP 메일 queue 디렉터리 '$MAIL_QUEUE_DIR'의 권한이 적절합니다: $directory_permissions"
else
    WARN "SMTP 메일 queue 디렉터리 '$MAIL_QUEUE_DIR'의 권한이 미흡합니다: $directory_permissions (기대 권한: $EXPECTED_PERMISSIONS)"
fi

cat $result

echo ; echo

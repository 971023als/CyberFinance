#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-116] “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡

cat << EOF >> $result
[양호]: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정된 경우
[취약]: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정된 경우
EOF

BAR

# 보안 감사 실패 시 시스템 종료 기능 설정 확인
audit_setting=$(grep -i "space_left_action" /etc/audit/auditd.conf)
action_setting=$(grep -i "action_mail_acct" /etc/audit/auditd.conf)
admin_mail=$(grep -i "admin_space_left_action" /etc/audit/auditd.conf)

if [[ "$audit_setting" == *"email"* ]]; then
  if [[ "$action_setting" == *"root"* ]] && [[ "$admin_mail" == *"halt"* ]]; then
    OK "보안 감사 실패 시 시스템이 즉시 종료되도록 설정됨"
  else
    WARN "보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정됨"
  fi
else
  WARN "보안 감사 실패 시 이메일 알림이 설정되지 않음"
fi

cat $result

echo ; echo

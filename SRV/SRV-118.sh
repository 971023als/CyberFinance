#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-118] 주기적인 보안패치 및 벤더 권고사항 미적용

cat << EOF >> $result
[양호]: 최신 보안패치 및 업데이트가 적용된 경우
[취약]: 최신 보안패치 및 업데이트가 적용되지 않은 경우
EOF

BAR

# 시스템 업데이트 상태 확인
update_status=$(apt-get -s upgrade | grep "upgraded,")
if [[ $update_status == *"0 upgraded"* ]]; then
  OK "모든 패키지가 최신 상태입니다."
else
  WARN "일부 패키지가 업데이트되지 않았습니다: $update_status"
fi

# 보안 권고사항 적용 여부 확인
# (예시: /etc/security/policies.conf 파일 존재 여부 및 내용 확인)
if [ -e "/etc/security/policies.conf" ]; then
  policy_content=$(grep "important_security_policy" /etc/security/policies.conf)
  if [ -z "$policy_content" ]; then
    WARN "중요 보안 정책이 /etc/security/policies.conf에 설정되지 않음"
  else
    OK "중요 보안 정책이 설정됨: $policy_content"
  fi
else
  WARN "/etc/security/policies.conf 파일이 존재하지 않음"
fi

cat $result

echo ; echo

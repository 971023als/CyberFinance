#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-073] 관리자 그룹에 불필요한 사용자 존재

cat << EOF >> $result
[양호]: 관리자 그룹에 불필요한 사용자가 없는 경우
[취약]: 관리자 그룹에 불필요한 사용자가 존재하는 경우
EOF

BAR

# 관리자 그룹 이름을 정의합니다 (예: sudo, wheel)
admin_group="sudo"

# 관리자 그룹의 멤버 확인
admin_members=$(getent group "$admin_group" | cut -d: -f4)

# 예상되지 않은 사용자가 관리자 그룹에 있는지 확인
# 여기서는 예시로 'testuser'를 사용하지만, 실제 환경에 맞게 수정 필요
if [[ $admin_members == *'testuser'* ]]; then
  WARN "관리자 그룹($admin_group)에 불필요한 사용자(testuser)가 포함되어 있습니다."
else
  OK "관리자 그룹($admin_group)에 불필요한 사용자가 없습니다."
fi

cat $result

echo ; echo

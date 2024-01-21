#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비

cat << EOF >> $result
[양호]: SU 명령을 특정 그룹에만 허용한 경우
[취약]: SU 명령을 모든 사용자가 사용할 수 있는 경우
EOF

BAR

# /etc/pam.d/su 파일에서 su 명령에 대한 그룹 제한 설정을 확인합니다
if grep -q "auth required pam_wheel.so use_uid" /etc/pam.d/su; then
  # wheel 그룹에 속한 사용자만 su 명령 사용 가능
  if grep -q "^wheel:" /etc/group; then
    OK "SU 명령은 특정 그룹에 제한됩니다."
  else
    WARN "Wheel 그룹이 /etc/group에 존재하지 않습니다."
  fi
else
  WARN "모든 사용자가 SU 명령을 사용할 수 있습니다."
fi

cat $result

echo ; echo

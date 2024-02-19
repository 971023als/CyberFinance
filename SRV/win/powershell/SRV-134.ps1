#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-134] 스택 영역 실행 방지 미설정

cat << EOF >> $result
[양호]: 스택 영역 실행 방지가 활성화된 경우
[취약]: 스택 영역 실행 방지가 비활성화된 경우
EOF

BAR

# 스택 영역 실행 방지 설정 확인
if grep -q "kernel.randomize_va_space=2" /etc/sysctl.conf; then
  OK "스택 영역 실행 방지가 활성화되어 있습니다."
else
  WARN "스택 영역 실행 방지가 비활성화되어 있습니다."
fi

cat $result

echo ; echo

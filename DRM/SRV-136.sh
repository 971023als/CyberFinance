#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-136] 시스템 종료 권한 설정 미흡

cat << EOF >> $result
[양호]: 시스템 종료 권한이 적절히 제한된 경우
[취약]: 시스템 종료 권한이 제한되지 않은 경우
EOF

BAR

# 시스템 종료 권한 관련 설정 확인
shutdown_command="/sbin/shutdown"

if [ ! -x "$shutdown_command" ]; then
  WARN "shutdown 명령이 실행 가능하지 않습니다."
else
  OK "shutdown 명령이 실행 가능합니다."
fi

# shutdown 명령에 대한 권한 확인
permissions=$(stat -c %A "$shutdown_command")
if [[ "$permissions" != *x* ]]; then
  WARN "shutdown 명령에 실행 권한이 없습니다."
else
  OK "shutdown 명령에 실행 권한이 있습니다."
fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-105] 불필요한 시작프로그램 존재

cat << EOF >> $result
[양호]: 불필요한 시작 프로그램이 존재하지 않는 경우
[취약]: 불필요한 시작 프로그램이 존재하는 경우
EOF

BAR

# 시스템 시작 시 실행되는 프로그램 목록 확인
startup_programs=$(systemctl list-unit-files --type=service --state=enabled)

# 불필요하거나 의심스러운 서비스를 확인
for service in $startup_programs; do
  if [ -z "$(grep -E 'known_safe_service' <<< "$service")" ]; then
    WARN "의심스러운 시작 프로그램: $service"
  fi
done

OK "시스템에 불필요한 시작 프로그램이 없습니다."

cat $result

echo ; echo

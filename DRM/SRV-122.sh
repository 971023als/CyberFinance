#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-122] UMASK 설정 미흡

cat << EOF >> $result
[양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우
[취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우
EOF

BAR

# /etc/profile과 /etc/bashrc에서 UMASK 설정 확인
profile_umask=$(grep umask /etc/profile)
bashrc_umask=$(grep umask /etc/bash.bashrc)

if [[ "$profile_umask" == *"umask 022"* ]] && [[ "$bashrc_umask" == *"umask 022"* ]]; then
  OK "UMASK 설정이 022로 엄격하게 설정됨"
else
  WARN "UMASK 설정이 022보다 덜 엄격하게 설정됨"
fi

cat $result

echo ; echo

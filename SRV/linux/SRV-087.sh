#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-087] C 컴파일러 존재 및 권한 설정 미흡

cat << EOF >> $result
[양호]: C 컴파일러가 존재하지 않거나, 적절한 권한으로 설정된 경우
[취약]: C 컴파일러가 존재하며 권한 설정이 미흡한 경우
EOF

BAR

# C 컴파일러 위치 확인
COMPILER_PATH=$(which gcc)

# 컴파일러 존재 여부 및 권한 확인
if [ -z "$COMPILER_PATH" ]; then
  OK "C 컴파일러(gcc)가 시스템에 설치되어 있지 않습니다."
else
  # 권한 확인
  COMPILER_PERMS=$(stat -c "%a" "$COMPILER_PATH")
  if [ "$COMPILER_PERMS" -le "755" ]; then
    OK "C 컴파일러(gcc)의 권한이 적절합니다. 권한: $COMPILER_PERMS"
  else
    WARN "C 컴파일러(gcc)의 권한이 부적절합니다. 권한: $COMPILER_PERMS"
  fi
fi

cat $result

echo ; echo

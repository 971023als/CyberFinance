#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-121] root 계정의 PATH 환경변수 설정 미흡

cat << EOF >> $result
[양호]: root 계정의 PATH 환경변수가 안전하게 설정되어 있는 경우
[취약]: root 계정의 PATH 환경변수에 안전하지 않은 경로가 포함된 경우
EOF

BAR

# root 계정의 PATH 환경변수 확인
root_path=$(sudo -Hiu root env | grep ^PATH)

# 안전하지 않은 경로가 포함되어 있는지 확인
if [[ "$root_path" == *".:"* || "$root_path" == *":."* ]]; then
  WARN "root 계정의 PATH 환경변수에 안전하지 않은 경로가 포함됨: $root_path"
else
  OK "root 계정의 PATH 환경변수가 안전하게 설정됨: $root_path"
fi

cat $result

echo ; echo

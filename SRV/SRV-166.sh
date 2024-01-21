#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-166] 불필요한 숨김 파일 또는 디렉터리 존재

cat << EOF >> $result
[양호]: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않는 경우
[취약]: 불필요한 숨김 파일 또는 디렉터리가 존재하는 경우
EOF

BAR

# 시스템에서 숨김 파일 및 디렉터리 검색
hidden_files=$(find / -name ".*" -type f)
hidden_dirs=$(find / -name ".*" -type d)

if [ -z "$hidden_files" ] && [ -z "$hidden_dirs" ]; then
    OK "불필요한 숨김 파일 또는 디렉터리가 존재하지 않습니다."
else
    WARN "다음의 불필요한 숨김 파일 또는 디렉터리가 존재합니다: $hidden_files $hidden_dirs"
fi

cat $result

echo ; echo

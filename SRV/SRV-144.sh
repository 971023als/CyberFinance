#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-144] /dev 경로에 불필요한 파일 존재

cat << EOF >> $result
[양호]: /dev 경로에 불필요한 파일이 존재하지 않는 경우
[취약]: /dev 경로에 불필요한 파일이 존재하는 경우
EOF

BAR

# /dev 경로에서 불필요한 파일 확인
unnecessary_files=$(find /dev -type f)

if [ -z "$unnecessary_files" ]; then
    OK "/dev 경로에 불필요한 파일이 존재하지 않습니다."
else
    WARN "/dev 경로에 다음의 불필요한 파일이 존재합니다: $unnecessary_files"
fi

cat $result

echo ; echo

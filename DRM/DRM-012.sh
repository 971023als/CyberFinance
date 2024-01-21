#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-012] .netrc 파일 내 중요 정보 노출

cat << EOF >> $result
[양호]: 시스템 전체에서 .netrc 파일이 존재하지 않는 경우
[취약]: 시스템 전체에서 .netrc 파일이 존재하는 경우
EOF

BAR

# 시스템 전체에서 .netrc 파일 찾기
netrc_files=$(find / -name ".netrc" 2>/dev/null)

if [ -z "$netrc_files" ]; then
    OK "시스템에 .netrc 파일이 존재하지 않습니다."
else
    WARN "다음 위치에 .netrc 파일이 존재합니다: $netrc_files"
fi

cat $result

echo ; echo

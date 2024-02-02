#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-093] 불필요한 world writable 파일 존재

cat << EOF >> $result
[양호]: 시스템에 불필요한 world writable 파일이 존재하지 않는 경우
[취약]: 시스템에 불필요한 world writable 파일이 존재하는 경우
EOF

BAR

# 시스템에서 world writable 파일 찾기
world_writable_files=$(find / -type f -perm -o+w -exec ls -ld {} \; 2>/dev/null)

# world writable 파일 확인
if [ -z "$world_writable_files" ]; then
    OK "불필요한 world writable 파일이 존재하지 않습니다."
else
    WARN "다음 world writable 파일이 발견되었습니다: $world_writable_files"
fi

cat $result

echo ; echo

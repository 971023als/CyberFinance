#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-079] 익명 사용자에게 부적절한 권한(Everyone) 적용

cat << EOF >> $result
[양호]: 익명 사용자에게 부적절한 권한이 적용되지 않은 경우
[취약]: 익명 사용자에게 부적절한 권한이 적용된 경우
EOF

BAR

# 시스템 전체에서 world-writable 파일 확인
world_writable_files=$(find / -xdev -type f -perm -0002 -print 2>/dev/null)

# 파일이 존재하는지 확인
if [ -z "$world_writable_files" ]; then
    OK "익명 사용자에게 부적절한 권한이 적용된 파일이 없습니다."
else
    WARN "다음 파일들이 익명 사용자에게 쓰기 권한이 부여되어 있습니다:"
    echo "$world_writable_files"
fi

cat $result

echo ; echo

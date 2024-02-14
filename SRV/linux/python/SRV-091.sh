#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [U-91] 불필요하게 SUID, SGID bit가 설정된 파일 존재

cat << EOF >> $result
[양호]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정되지 않은 경우
[취약]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정된 경우
EOF

BAR

# SUID 또는 SGID 비트가 설정된 파일 검색
suid_files=$(find / -perm /4000 -type f 2>/dev/null)
sgid_files=$(find / -perm /2000 -type f 2>/dev/null)

# SUID 파일 확인
if [ -z "$suid_files" ]; then
    OK "SUID 비트가 설정된 불필요한 파일이 없습니다."
else
    WARN "SUID 비트가 설정된 불필요한 파일이 있습니다: $suid_files"
fi

# SGID 파일 확인
if [ -z "$sgid_files" ]; then
    OK "SGID 비트가 설정된 불필요한 파일이 없습니다."
else
    WARN "SGID 비트가 설정된 불필요한 파일이 있습니다: $sgid_files"
fi

cat $result

echo ; echo

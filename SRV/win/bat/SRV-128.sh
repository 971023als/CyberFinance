#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-128] NTFS 파일 시스템 미사용

cat << EOF >> $result
[양호]: NTFS 파일 시스템이 사용되지 않는 경우
[취약]: NTFS 파일 시스템이 사용되는 경우
EOF

BAR

# NTFS 파일 시스템 사용 여부 확인
ntfs_check=$(mount | grep 'type ntfs')

if [ -z "$ntfs_check" ]; then
  OK "NTFS 파일 시스템이 사용되지 않습니다."
else
  WARN "NTFS 파일 시스템이 사용되고 있습니다: $ntfs_check"
fi

cat $result

echo ; echo

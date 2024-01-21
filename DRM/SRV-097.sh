#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡

cat << EOF >> $result
[양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우
[취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우
EOF

BAR

# FTP 서비스 디렉터리 설정
ftp_dir="/var/ftp"

# FTP 디렉터리의 권한 확인
if [ -d "$ftp_dir" ]; then
  permission=$(stat -c '%a' "$ftp_dir")
  if [ "$permission" -eq 755 ] || [ "$permission" -eq 750 ]; then
    OK "FTP 디렉터리의 접근 권한이 적절하게 설정되었습니다. ($permission)"
  else
    WARN "FTP 디렉터리의 접근 권한이 적절하지 않습니다. ($permission)"
  fi
else
  INFO "FTP 서비스 디렉터리($ftp_dir)가 존재하지 않습니다."
fi

cat $result

echo ; echo

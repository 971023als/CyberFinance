#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-161] ftpusers 파일의 소유자 및 권한 설정 미흡

cat << EOF >> $result
[양호]: ftpusers 파일의 소유자가 root이고, 권한이 644 이하인 경우
[취약]: ftpusers 파일의 소유자가 root가 아니거나, 권한이 644 이상인 경우
EOF

BAR

ftpusers_file="/etc/ftpusers"

# ftpusers 파일의 소유자 및 권한 확인
if [ -f "$ftpusers_file" ]; then
    file_owner=$(stat -c "%U" "$ftpusers_file")
    file_permissions=$(stat -c "%a" "$ftpusers_file")

    if [ "$file_owner" != "root" ]; then
        WARN "ftpusers 파일의 소유자가 root가 아닙니다."
    elif [ "$file_permissions" -gt 644 ]; then
        WARN "ftpusers 파일의 권한이 644 이상입니다."
    else
        OK "ftpusers 파일의 소유자 및 권한이 적절합니다."
    fi
else
    INFO "ftpusers 파일이 존재하지 않습니다."
fi

cat $result

echo ; echo

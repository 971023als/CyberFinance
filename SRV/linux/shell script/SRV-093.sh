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

if [ `find / -type f -perm -2 2>/dev/null | wc -l` -gt 0 ]; then
		WARN " world writable 설정이 되어있는 파일이 있습니다." >> $TMP1
		return 0
else
		OK "※ U-15 결과 : 양호(Good)" >> $TMP1
		return 0
fi

cat $result

echo ; echo

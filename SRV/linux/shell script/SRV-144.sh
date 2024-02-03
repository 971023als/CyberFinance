#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-144] /dev 경로에 불필요한 파일 존재

cat << EOF >> $TMP1
[양호]: /dev 경로에 불필요한 파일이 존재하지 않는 경우
[취약]: /dev 경로에 불필요한 파일이 존재하는 경우
EOF

BAR

if [ `find /dev -type f 2>/dev/null | wc -l` -gt 0 ]; then
		WARN " /dev 디렉터리에 존재하지 않는 device 파일이 존재합니다." >> $TMP1
		return 0
	else
		OK "※ U-16 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

cat $TMP1

echo ; echo

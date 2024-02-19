#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-142] 중복 UID가 부여된 계정 존재

cat << EOF >> $TMP1
[양호]: 중복 UID가 부여된 계정이 존재하지 않는 경우
[취약]: 중복 UID가 부여된 계정이 존재하는 경우
EOF

BAR

if [ -f /etc/passwd ]; then
		if [ `awk -F : '{print $3}' /etc/passwd | sort | uniq -d | wc -l` -gt 0 ]; then
			WARN " 동일한 UID로 설정된 사용자 계정이 존재합니다." >> $TMP1
			return 0
		fi
	fi
	OK "※ U-52 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

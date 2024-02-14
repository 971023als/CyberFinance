#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재

cat << EOF >> $TMP1
[양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우
[취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우
EOF

BAR

if [ -f /etc/passwd ]; then
		# !!! 불필요한 계정에 대한 변경은 하단의 grep 명령어를 수정하세요.
		if [ `grep -E '^(daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|gopher|games|ftp|apache|httpd|www-data|mysql|mariadb|postgres|mail|postfix|news|lp|uucp|nuucp):' /etc/passwd | awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" {print}' | wc -l` -gt 0 ]; then
			WARN " 로그인이 필요하지 않은 불필요한 계정에 /bin/false 또는 /sbin/nologin 쉘이 부여되지 않았습니다." >> $TMP1
			return 0
		fi
	fi
	OK "※ U-53 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

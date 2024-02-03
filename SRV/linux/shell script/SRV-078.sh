#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-078] 불필요한 Guest 계정 활성화

cat << EOF >> $result
[양호]: 불필요한 Guest 계정이 비활성화 되어 있는 경우
[취약]: 불필요한 Guest 계정이 활성화 되어 있는 경우
EOF

BAR

if [ -f /etc/passwd ]; then
		# !!! 불필요한 계정을 변경할 경우 하단의 grep 명령어를 수정하세요.
		if [ `awk -F : '{print $1}' /etc/passwd | grep -wE 'daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|gopher|games|ftp|apache|httpd|www-data|mysql|mariadb|postgres|mail|postfix|news|lp|uucp|nuucp' | wc -l` -gt 0 ]; then
			WARN " 불필요한 계정이 존재합니다." >> $TMP1
			return 0
		fi
	fi
	OK "※ U-49 결과 : 양호(Good)" >> $TMP1

if [ -f /etc/group ]; then
		# !!! 불필요한 계정에 대한 변경은 하단의 grep 명령어를 수정하세요.
		if [ `awk -F : '$1=="root" {gsub(" ", "", $0); print $4}' /etc/group | awk '{gsub(",","\n",$0); print}' | grep -wE 'daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|gopher|games|ftp|apache|httpd|www-data|mysql|mariadb|postgres|mail|postfix|news|lp|uucp|nuucp' | wc -l` -gt 0 ]; then
			WARN " 관리자 그룹(root)에 불필요한 계정이 등록되어 있습니다." >> $TMP1
			return 0
		fi
	fi
	OK "※ U-50 결과 : 양호(Good)" >> $TMP1

cat $result

echo ; echo

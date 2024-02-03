#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-095] 존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재

cat << EOF >> $result
[양호]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 없는 경우
[취약]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 있는 경우
EOF

BAR

if [ `find / \( -nouser -or -nogroup \) 2>/dev/null | wc -l` -gt 0 ]; then
		WARN " 소유자가 존재하지 않는 파일 및 디렉터리가 존재합니다." >> $TMP1
		return 0
	else
		OK "※ U-06 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

if [ `find /dev -type f 2>/dev/null | wc -l` -gt 0 ]; then
		WARN " /dev 디렉터리에 존재하지 않는 device 파일이 존재합니다." >> $TMP1
		return 0
	else
		OK "※ U-16 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

homedirectory_null_count=`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6==null' /etc/passwd | wc -l`
	if [ $homedirectory_null_count -gt 0 ]; then
		WARN " 홈 디렉터리가 존재하지 않는 계정이 있습니다." >> $TMP1
		return 0
	else
		homedirectory_slash_count=`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $1!="root" && $6=="/"' /etc/passwd | wc -l`
		if [ $homedirectory_slash_count -gt 0 ]; then
			WARN " 관리자 계정(root)이 아닌데 홈 디렉터리가 '/'로 설정된 계정이 있습니다." >> $TMP1
			return 0
		else
			OK "※ U-58 결과 : 양호(Good)" >> $TMP1
			return 0
		fi
	fi

cat $result

echo ; echo

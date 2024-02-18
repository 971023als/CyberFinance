#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-164] 구성원이 존재하지 않는 GID 존재

cat << EOF >> $TMP1
[양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우
[취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우
EOF

BAR

unnecessary_groups=(`grep -vE '^#|^\s#' /etc/group | awk -F : '$3>=500 && $4==null {print $3}' | uniq`)
	for ((i=0; i<${#unnecessary_groups[@]}; i++))
	do
		if [ `awk -F : '{print $4}' /etc/passwd | uniq | grep ${unnecessary_groups[$i]} | wc -l` -eq 0 ]; then
			WARN " 불필요한 그룹이 존재합니다." >> $TMP1
			return 0
		fi
	done
	OK "※ U-51 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

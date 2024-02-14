#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-045] 웹 서비스 프로세스 권한 제한 미비

cat << EOF >> $TMP1
[양호]: 웹 서비스 프로세스가 root 권한으로 실행되지 않는 경우
[취약]: 웹 서비스 프로세스가 root 권한으로 실행되는 경우
EOF

BAR

webconf_files=(".htaccess" "httpd.conf" "apache2.conf")
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				webconf_file_group_root_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -B 1 '^\s*Group' | grep 'root' | wc -l`
				if [ $webconf_file_group_root_count -gt 0 ]; then
					WARN " Apache 데몬이 root 권한으로 구동되도록 설정되어 있습니다." >> $TMP1
					return 0
				else
					webconf_file_group_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep '^\s*Group' | awk '{print $2}' | sed 's/{//' | sed 's/}//' | wc -l`
					if [ $webconf_file_group_count -gt 0 ]; then
						webconf_file_group=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep '^\s*Group' | awk '{print $2}' | sed 's/{//' | sed 's/}//'`
						webconf_file_group_root_count=`eval echo $webconf_file_group | grep 'root' | wc -l`
						if [ $webconf_file_group_root_count -gt 0 ]; then
							WARN " Apache 데몬이 root 권한으로 구동되도록 설정되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				fi
			done
		fi
	done
	OK "※ 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

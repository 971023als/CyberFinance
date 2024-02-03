#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재

cat << EOF >> $TMP1
[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하는 경우
EOF

BAR

webconf_files=(".htaccess" "httpd.conf" "apache2.conf" "userdir.conf")
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				if [[ ${find_webconf_files[$j]} =~ userdir.conf ]]; then
					userdirconf_disabled_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'userdir' | grep -i 'disabled' | wc -l`
					if [ $userdirconf_disabled_count -eq 0 ]; then
						userdirconf_followsymlinks_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'Options' | grep -iv '\-FollowSymLinks' | grep -i 'FollowSymLinks' | wc -l`
						if [ $userdirconf_followsymlinks_count -gt 0 ]; then
							WARN " Apache 설정 파일에 심볼릭 링크 사용을 제한하도록 설정하지 않습니다." >> $TMP1
							return 0
						fi
					fi
				else
					webconf_file_followSymlinks_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'Options' | grep -iv '\-FollowSymLinks' | grep -i 'FollowSymLinks' | wc -l`
					if [ $webconf_file_followSymlinks_count -gt 0 ]; then
						WARN " Apache 설정 파일에 심볼릭 링크 사용을 제한하도록 설정하지 않습니다." >> $TMP1
						return 0
					fi
				fi
			done
		fi
	done
	OK "※ U-39 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

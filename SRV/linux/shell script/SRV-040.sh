#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-040] 웹 서비스 디렉터리 리스팅 방지 설정 미흡

cat << EOF >> $TMP1
[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우
[취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우
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
					userdirconf_disabled_count=`grep -vE '^#|^\s#'  ${find_webconf_files[$j]} | grep -i 'userdir' | grep -i 'disabled' | wc -l`
					if [ $userdirconf_disabled_count -eq 0 ]; then
						userdirconf_indexes_count=`grep -vE '^#|^\s#'  ${find_webconf_files[$j]} | grep -i 'Options' | grep -iv '\-indexes' | grep -i 'indexes' | wc -l`
						if [ $userdirconf_indexes_count -gt 0 ]; then
							WARN " Apache 설정 파일에 디렉터리 검색 기능을 사용하도록 설정되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				else
					webconf_file_indexes_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'Options' | grep -iv '\-indexes' | grep -i 'indexes' | wc -l`
					if [ $webconf_file_indexes_count -gt 0 ]; then
						WARN " Apache 설정 파일에 디렉터리 검색 기능을 사용하도록 설정되어 있습니다." >> $TMP1
						return 0
					fi
				fi
			done
		fi
	done
	OK "※ U-35 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

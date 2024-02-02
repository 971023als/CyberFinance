#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-044] 웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정

cat << EOF >> $TMP1
[양호]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 적절하게 제한된 경우
[취약]: 웹 서비스에서 파일 업로드 및 다운로드 용량이 제한되지 않은 경우
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
						userdirconf_limitrequestbody_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'LimitRequestBody' | wc -l`
						if [ $userdirconf_limitrequestbody_count -eq 0 ]; then
							WARN " Apache 설정 파일에 파일 업로드 및 다운로드를 제한하도록 설정하지 않았습니다." >> $TMP1
							return 0
						fi
					fi
				else
					webconf_limitrequestbody_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'LimitRequestBody' | wc -l`
					if [ $webconf_limitrequestbody_count -eq 0 ]; then
						WARN " Apache 설정 파일에 파일 업로드 및 다운로드를 제한하도록 설정하지 않았습니다." >> $TMP1
						return 0
					fi
				fi
			done
		fi
	done
	OK "※ U-40 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

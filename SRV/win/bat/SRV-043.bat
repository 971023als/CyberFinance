#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-043] 웹 서비스 경로 내 불필요한 파일 존재

cat << EOF >> $result
[양호]: 웹 서비스 경로에 불필요한 파일이 존재하지 않는 경우
[취약]: 웹 서비스 경로에 불필요한 파일이 존재하는 경우
EOF

BAR

webconf_files=(".htaccess" "httpd.conf" "apache2.conf")
	file_exists_count=0
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			((file_exists_count++))
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				webconf_file_documentroot_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'DocumentRoot' | grep '/' | wc -l`
				if [ $webconf_file_documentroot_count -gt 0 ]; then
					webconf_file_documentroot_basic_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'DocumentRoot' | grep '/' | awk '{gsub(/"/, "", $0); print $2}' | grep -E '/usr/local/apache/htdocs|/usr/local/apache2/htdocs|/var/www/html' | wc -l`
					if [ $webconf_file_documentroot_basic_count -gt 0 ]; then 
						WARN " Apache DocumentRoot를 기본 디렉터리로 설정했습니다." >> $TMP1
						return 0
					fi
				else
					WARN " Apache DocumentRoot를 설정하지 않았습니다." >> $TMP1
					return 0
				fi
			done
		fi
	done
	ps_apache_count=`ps -ef | grep -iE 'httpd|apache2' | grep -v 'grep' | wc -l`
	if [ $ps_apache_count -gt 0 ] && [ $file_exists_count -eq 0 ]; then
		WARN " Apache 서비스를 사용하고, DocumentRoot를 설정하는 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "양호(Good)" >> $TMP1
		return 0
	fi

cat $result

echo ; echo
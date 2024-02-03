#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-048] 불필요한 웹 서비스 실행

cat << EOF >> $result
[양호]: 불필요한 웹 서비스가 실행되지 않고 있는 경우
[취약]: 불필요한 웹 서비스가 실행되고 있는 경우
EOF

BAR

# 웹 서비스 목록
serverroot_directory=()
	webconf_files=(".htaccess" "httpd.conf" "apache2.conf")
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				webconf_serverroot_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep 'ServerRoot' | grep '/' | wc -l`
				if [ $webconf_serverroot_count -gt 0 ]; then
					serverroot_directory[${#serverroot_directory[@]}]=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep 'ServerRoot' | grep '/' | awk '{gsub(/"/, "", $0); print $2}'`
				fi
			done
		fi
	done
	apache2_serverroot_count=`apache2 -V 2>/dev/ull | grep -i 'root' | awk -F '"' '{gsub(" ", "", $0); print $2}' | wc -l`
	if [ $apache2_serverroot_count -gt 0 ];then
		serverroot_directory[${#serverroot_directory[@]}]=`apache2 -V 2>/dev/ull | grep -i 'root' | awk -F '"' '{gsub(" ", "", $0); print $2}'`
	fi
	httpd_serverroot_count=`httpd -V 2>/dev/ull | grep -i 'root' | awk -F '"' '{gsub(" ", "", $0); print $2}' | wc -l`
	if [ $httpd_serverroot_count -gt 0 ]; thend
		serverroot_directory[${#serverroot_directory[@]}]=`httpd -V 2>/dev/ull | grep -i 'root' | awk -F '"' '{gsub(" ", "", $0); print $2}'`
	fi
	for ((i=0; i<${#serverroot_directory[@]}; i++))
	do
		manual_file_exists_count=`find ${serverroot_directory[$i]} -name 'manual' -type f 2>/dev/null | wc -l`
		if [ $manual_file_exists_count -gt 0 ]; then
			WARN " Apache 홈 디렉터리 내 기본으로 생성되는 불필요한 파일 및 디렉터리가 제거되어 있지 않습니다." >> $TMP1
			return 0
		fi
	done
	OK "결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

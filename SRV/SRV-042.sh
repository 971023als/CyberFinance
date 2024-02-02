#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡

cat << EOF >> $TMP1
[양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우
[취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우
EOF

BAR

webconf_files=(".htaccess" "httpd.conf" "apache2.conf" "userdir.conf")
	file_exists_count=0
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			((file_exists_count++))
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				if [[ ${find_webconf_files[$j]} =~ userdir.conf ]]; then
					userdirconf_disabled_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'userdir' | grep -i 'disabled' | wc -l`
					if [ $userdirconf_disabled_count -eq 0 ]; then
						userdirconf_allowoverride_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'AllowOverride' | wc -l`
						if [ $userdirconf_allowoverride_count -gt 0 ]; then
							userdirconf_allowoverride_none_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'AllowOverride' | grep -i 'None' | wc -l`
							if [ $userdirconf_allowoverride_none_count -gt 0 ]; then
								WARN " 웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다." >> $TMP1
								return 0
							fi
						else
							WARN " 웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다." >> $TMP1
							return 0
						fi
					fi
				else
					webconf_file_allowoverride_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'AllowOverride' | wc -l`
					if [ $webconf_file_allowoverride_count -gt 0 ]; then
						webconf_file_allowoverride_none_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'AllowOverride' | grep -i 'None' | wc -l`
						if [ $webconf_file_allowoverride_none_count -gt 0 ]; then
							WARN " 웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다." >> $TMP1
							return 0
						fi
					else
						WARN " 웹 서비스 상위 디렉터리에 이동 제한을 설정하지 않았습니다." >> $TMP1
						return 0
					fi
				fi
			done
		fi
	done
	ps_apache_count=`ps -ef | grep -iE 'httpd|apache2' | grep -v 'grep' | wc -l`
	if [ $ps_apache_count -gt 0 ] && [ $file_exists_count -eq 0 ]; then
		WARN " Apache 서비스를 사용하고, 웹 서비스 상위 디렉터리에 이동 제한을 설정하는 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "※ U-37 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

cat $TMP1

echo ; echo

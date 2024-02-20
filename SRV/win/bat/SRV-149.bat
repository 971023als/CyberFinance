#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-148] 웹 서비스 정보 노출

cat << EOF >> $TMP1
[양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우
[취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우
EOF

BAR

webconf_file_exists_count=0
	webconf_files=(".htaccess" "httpd.conf" "apache2.conf")
	for ((i=0; i<${#webconf_files[@]}; i++))
	do
		find_webconf_file_count=`find / -name ${webconf_files[$i]} -type f 2>/dev/null | wc -l`
		if [ $find_webconf_file_count -gt 0 ]; then
			((webconf_file_exists_count++))
			find_webconf_files=(`find / -name ${webconf_files[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#find_webconf_files[@]}; j++))
			do
				webconf_servertokens_prod_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'ServerTokens' | grep -i 'Prod' | wc -l`
				if [ $webconf_servertokens_prod_count -gt 0 ]; then
					webconf_serversignature_off_count=`grep -vE '^#|^\s#' ${find_webconf_files[$j]} | grep -i 'ServerSignature' | grep -i 'Off' | wc -l`
					if [ $webconf_serversignature_off_count -eq 0 ]; then
						WARN " ${find_webconf_files[$j]} 파일에 ServerSignature off 설정이 없습니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${find_webconf_files[$j]} 파일에 ServerTokens Prod 설정이 없습니다." >> $TMP1
					return 0
				fi
			done
		fi
	done
	ps_apache_count=`ps -ef | grep -iE 'httpd|apache2' | grep -v 'grep' | wc -l`
	if [ $ps_apache_count -gt 0 ] && [ $webconf_file_exists_count -eq 0 ]; then
		WARN " Apache 서비스를 사용하고, ServerTokens Prod, ServerSignature Off를 설정하는 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "※ U-71 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

cat $TMP1

echo ; echo

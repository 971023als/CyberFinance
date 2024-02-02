#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-035] 취약한 서비스 활성화

cat << EOF >> $result
[양호]: 취약한 서비스가 비활성화된 경우
[취약]: 취약한 서비스가 활성화된 경우
EOF

BAR

services=("echo" "discard" "daytime" "chargen")
	if [ -d /etc/xinetd.d ]; then
		for ((i=0; i<${#services[@]}; i++))
		do
			if [ -f /etc/xinetd.d/${services[$i]} ]; then
				etc_xinetdd_service_disable_yes_count=`grep -vE '^#|^\s#' /etc/xinetd.d/${services[$i]} | grep -i 'disable' | grep -i 'yes' | wc -l`
				if [ $service_disable_yes_count -eq 0 ]; then
					WARN " ${services[$i]} 서비스가 /etc/xinetd.d 디렉터리 내 서비스 파일에서 실행 중입니다." >> $TMP1
					return 0
				fi
			fi
		done
	fi
	if [ -f /etc/inetd.conf ]; then
		for ((i=0; i<${#services[@]}; i++))
		do
			etc_inetdconf_enable_count=`grep -vE '^#|^\s#' /etc/inetd.conf | grep  ${services[$i]} | wc -l`
			if [ $etc_inetdconf_enable_count -gt 0 ]; then
				WARN " ${services[$i]} 서비스가 /etc/inetd.conf 파일에서 실행 중입니다." >> $TMP1
				return 0
			fi
		done
	fi
	OK "※ U-23 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

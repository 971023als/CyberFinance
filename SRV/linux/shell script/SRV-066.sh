#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-066] DNS Zone Transfer 설정 미흡

cat << EOF >> $TMP1
[양호]: DNS Zone Transfer가 안전하게 제한되어 있는 경우
[취약]: DNS Zone Transfer가 적절하게 제한되지 않은 경우
EOF

BAR

ps_dns_count=`ps -ef | grep -i 'named' | grep -v 'grep' | wc -l`
	if [ $ps_dns_count -gt 0 ]; then
		if [ -f /etc/named.conf ]; then
			etc_namedconf_allowtransfer_count=`grep -vE '^#|^\s#' /etc/named.conf | grep -i 'allow-transfer' | grep -i 'any' | wc -l`
			if [ $etc_namedconf_allowtransfer_count -gt 0 ]; then
				WARN " /etc/named.conf 파일에 allow-transfer { any; } 설정이 있습니다." >> $TMP1
				return 0
			fi
		fi
	fi
	OK "※ U-34 결과 : 양호(Good)" >> $TMP1
	return 0

cat $TMP1

echo ; echo

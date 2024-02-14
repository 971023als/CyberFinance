#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-027] 서비스 접근 IP 및 포트 제한 미비

cat << EOF >> $result
[양호]: 서비스에 대한 IP 및 포트 접근 제한이 적절하게 설정된 경우
[취약]: 서비스에 대한 IP 및 포트 접근 제한이 설정되지 않은 경우
EOF

BAR

if [ -f /etc/hosts.deny ]; then
		etc_hostsdeny_allall_count=`grep -vE '^#|^\s#' /etc/hosts.deny | awk '{gsub(" ", "", $0); print}' | grep -i 'all:all' | wc -l`
		if [ $etc_hostsdeny_allall_count -gt 0 ]; then
			if [ -f /etc/hosts.allow ]; then
				etc_hostsallow_allall_count=`grep -vE '^#|^\s#' /etc/hosts.allow | awk '{gsub(" ", "", $0); print}' | grep -i 'all:all' | wc -l`
				if [ $etc_hostsallow_allall_count -gt 0 ]; then
					WARN " /etc/hosts.allow 파일에 'ALL : ALL' 설정이 있습니다." >> $TMP1
					return 0
				else
					OK "※ U-18 결과 : 양호(Good)" >> $TMP1
					return 0
				fi
			else
				OK "※ U-18 결과 : 양호(Good)" >> $TMP1
				return 0
			fi
		else
			WARN " /etc/hosts.deny 파일에 'ALL : ALL' 설정이 없습니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/hosts.deny 파일이 없습니다." >> $TMP1
		return 0
	fi

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-037] 취약한 FTP 서비스 실행

cat << EOF >> $TMP1
[양호]: FTP 서비스가 비활성화 되어 있는 경우
[취약]: FTP 서비스가 활성화 되어 있는 경우
EOF

BAR

if [ -f /etc/services ]; then
		ftp_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ftp_port_count -gt 0 ]; then
			ftp_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ftp_port[@]}; i++))
			do
				netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$i]} " | wc -l`
				if [ $netstat_ftp_count -gt 0 ]; then
					WARN " ftp 서비스가 실행 중입니다." >> $TMP1
					return 0
				fi
			done
		fi
	fi
	find_vsftpdconf_count=`find / -name 'vsftpd.conf' -type f 2>/dev/null | wc -l`
	if [ $find_vsftpdconf_count -gt 0 ]; then
		vsftpdconf_files=(`find / -name 'vsftpd.conf' -type f 2>/dev/null`)
		for ((i=0; i<${#vsftpdconf_files[@]}; i++))
		do
			if [ -f ${vsftpdconf_files[$i]} ]; then
				vsftpdconf_file_port_count=`grep -vE '^#|^\s#' ${vsftpdconf_files[$i]} | grep 'listen_port' | awk -F = '{gsub(" ", "", $0); print $2}' | wc -l`
				if [ $vsftpdconf_file_port_count -gt 0 ]; then
					ftp_port=(`grep -vE '^#|^\s#' ${vsftpdconf_files[$i]} | grep 'listen_port' | awk -F = '{gsub(" ", "", $0); print $2}'`)
					for ((j=0; j<${#ftp_port[@]}; j++))
					do
						netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$j]} " | wc -l`
						if [ $netstat_ftp_count -gt 0 ]; then
							WARN " ftp 서비스가 실행 중입니다." >> $TMP1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	find_proftpdconf_count=`find / -name 'proftpd.conf' -type f 2>/dev/null | wc -l`
	if [ $find_proftpdconf_count -gt 0 ]; then
		proftpdconf_files=(`find / -name 'proftpd.conf' -type f 2>/dev/null`)
		for ((i=0; i<${#proftpdconf_files[@]}; i++))
		do
			if [ -f ${proftpdconf_files[$i]} ]; then
				proftpdconf_file_port_count=`grep -vE '^#|^\s#' ${proftpdconf_files[$i]} | grep 'Port' | awk '{print $2}' | wc -l`
				if [ $proftpdconf_file_port_count -gt 0 ]; then
					ftp_port=(`grep -vE '^#|^\s#' ${proftpdconf_files[$i]} | grep 'Port' | awk '{print $2}'`)
					for ((j=0; j<${#ftp_port[@]}; j++))
					do
						netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$j]} " | wc -l`
						if [ $netstat_ftp_count -gt 0 ]; then
							WARN " ftp 서비스가 실행 중입니다." >> $TMP1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	ps_ftp_count=`ps -ef | grep -iE 'ftp|vsftpd|proftp' | grep -v 'grep' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		WARN " ftp 서비스가 실행 중입니다." >> $TMP1
		return 0
	else
		OK "※ U-61 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

cat $TMP1

echo ; echo

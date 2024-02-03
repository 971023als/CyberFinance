#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡

cat << EOF >> $result
[양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우
[취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우
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
					telent_port=(`grep -vE '^#|^\s#' ${vsftpdconf_files[$i]} | grep 'listen_port' | awk -F = '{gsub(" ", "", $0); print $2}'`)
					for ((j=0; j<${#telent_port[@]}; j++))
					do
						if [ `netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${telent_port[$j]} " | wc -l` -gt 0 ]; then
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
				if [ `grep -vE '^#|^\s#' ${proftpdconf_files[$i]} | grep 'Port' | awk '{print $2}' | wc -l` -gt 0 ]; then
					telent_port=(`grep -vE '^#|^\s#' ${proftpdconf_files[$i]} | grep 'Port' | awk '{print $2}'`)
					for ((j=0; j<${#telent_port[@]}; j++))
					do
						if [ `netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${telent_port[$j]} " | wc -l` -gt 0 ]; then
							WARN " ftp 서비스가 실행 중입니다." >> $TMP1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	ps_ftp_count=`ps -ef | grep -i 'ftp' | grep -v 'grep' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		WARN " ftp 서비스가 실행 중입니다." >> $TMP1
		return 0
	fi
	find_sshdconfig_count=`find / -name 'sshd_config' -type f 2>/dev/null | wc -l`
	if [ $find_sshdconfig_count -gt 0 ]; then
		sshdconfig_files=(`find / -name 'sshd_config' -type f 2>/dev/null`)
		for ((i=0; i<${#sshdconfig_files[@]}; i++))
		do
		done
	fi

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

file_exists_count=0
	ftpusers_files=("/etc/ftpusers" "/etc/pure-ftpd/ftpusers" "/etc/wu-ftpd/ftpusers" "/etc/vsftpd/ftpusers" "/etc/proftpd/ftpusers" "/etc/ftpd/ftpusers" "/etc/vsftpd.ftpusers" "/etc/vsftpd.user_list" "/etc/vsftpd/user_list")
	for ((i=0; i<${#ftpusers_files[@]}; i++))
	do
		if [ -f ${ftpusers_files[$i]} ]; then
			((file_exists_count++))
			ftpusers_file_owner_name=`ls -l ${ftpusers_files[$i]} | awk '{print $3}'`
			if [[ $ftpusers_file_owner_name =~ root ]]; then
				ftpusers_file_permission=`stat ${ftpusers_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
				if [ $ftpusers_file_permission -le 640 ]; then
					ftpusers_file_owner_permission=`stat ${ftpusers_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
					if [ $ftpusers_file_owner_permission -eq 6 ] || [ $ftpusers_file_owner_permission -eq 4 ] || [ $ftpusers_file_owner_permission -eq 2 ] || [ $ftpusers_file_owner_permission -eq 0 ]; then
						ftpusers_file_group_permission=`stat ${ftpusers_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
						if [ $ftpusers_file_group_permission -eq 4 ] || [ $ftpusers_file_group_permission -eq 0 ]; then
							ftpusers_file_other_permission=`stat ${ftpusers_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
							if [ $ftpusers_file_other_permission -ne 0 ]; then
								WARN " ${ftpusers_files[$i]} 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
								return 0
							fi
						else
							WARN " ${ftpusers_files[$i]} 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " ${ftpusers_files[$i]} 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${ftpusers_files[$i]} 파일의 권한이 640보다 큽니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${ftpusers_files[$i]} 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
				return 0
			fi
		fi
	done
	if [ $file_exists_count -eq 0 ]; then
		WARN " ftp 접근제어 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "※ U-63 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

ftpusers_files=("/etc/ftpusers" "/etc/ftpd/ftpusers" "/etc/proftpd.conf" "/etc/vsftp/ftpusers" "/etc/vsftp/user_list" "/etc/vsftpd.ftpusers" "/etc/vsftpd.user_list")
	ftp_running_count=0 # ftp 서비스 실행 중일 때 카운트
	ftpusers_file_exists_count=0 # ftpusers 파일 존재 시 카운트
	if [ -f /etc/services ]; then
		ftp_port_count=`grep -vE '^#|^\s#' /etc/services | awk -F " " 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ftp_port_count -gt 0 ]; then
			ftp_port=(`grep -vE '^#|^\s#' /etc/services | awk -F " " 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ftp_port[@]}; i++))
			do
				netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$i]} " | wc -l`
				if [ $netstat_ftp_count -gt 0 ]; then
					((ftp_running_count++))
					for ((j=0; j<${#ftpusers_files[@]}; j++))
					do
						if [ -f ${ftpusers_files[$j]} ]; then
							((ftpusers_file_exists_count++))
							if [[ ${ftpusers_files[$j]} =~ /etc/proftpd.conf ]]; then
								etc_proftpdconf_rootlogin_on_count=`grep -vE '^#|^\s#' ${ftpusers_files[$j]} | grep -i 'RootLogin' | grep -i 'on' | wc -l`
								if [ $etc_proftpdconf_rootlogin_on_count -gt 0 ]; then
									WARN " ${ftpusers_files[$j]} 파일에 'RootLogin on' 설정이 있습니다." >> $TMP1
									return 0
								fi
							else
								ftp_root_count=`grep -vE '^#|^\s#' ${ftpusers_files[$j]} | grep -w 'root' | wc -l`
								if [ $ftp_root_count -eq 0 ]; then
									WARN " ${ftpusers_files[$j]} 파일에 'root' 계정이 없습니다." >> $TMP1
									return 0
								fi
							fi
						fi
					done
				fi
			done
		fi
	fi
	if [ $ftp_running_count -gt 0 ] && [ $ftpusers_file_exists_count -eq 0 ]; then
		WARN " ftp 서비스를 사용하고, 'root' 계정의 접근을 제한할 파일이 없습니다." >> $TMP1
		return 0
	fi
	ftp_running_count=0 # ftp 서비스 실행 중일 때 카운트
	ftpusers_file_exists_count=0 # ftpusers 파일 존재 시 카운트
	ps_ftp_count=`ps -ef | grep -iE 'ftp|vsftpd|proftp' | grep -v 'grep' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		((ftp_running_count++))
		for ((i=0; i<${#ftpusers_files[@]}; i++))
		do
			if [ -f ${ftpusers_files[$i]} ]; then
				((ftpusers_file_exists_count++))
				if [[ ${ftpusers_files[$i]} =~ /etc/proftpd.conf ]]; then
					etc_proftpdconf_rootlogin_on_count=`grep -vE '^#|^\s#' ${ftpusers_files[$i]} | grep -i 'RootLogin' | grep -i 'on' | wc -l`
					if [ $etc_proftpdconf_rootlogin_on_count -gt 0 ]; then
						WARN " ${ftpusers_files[$i]} 파일에 'RootLogin on' 설정이 있습니다." >> $TMP1
						return 0
					fi
				else
					ftp_root_count=`grep -vE '^#|^\s#' ${ftpusers_files[$i]} | grep -w 'root' | wc -l`
					if [ $ftp_root_count -eq 0 ]; then
						WARN " ${ftpusers_files[$i]} 파일에 'root' 계정이 없습니다." >> $TMP1
						return 0
					fi
				fi
			fi
		done
	fi
	if [ $ftp_running_count -gt 0 ] && [ $ftpusers_file_exists_count -eq 0 ]; then
		WARN " ftp 서비스를 사용하고, 'root' 계정의 접근을 제한할 파일이 없습니다." >> $TMP1
		return 0
	fi
	OK "※ U-64 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

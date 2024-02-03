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
		telent_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $telent_port_count -gt 0 ]; then
			telent_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#telent_port[@]}; i++))
			do
				netstat_telnet_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${telent_port[$i]} " | wc -l`
				if [ $netstat_telnet_count -gt 0 ]; then
					echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
					echo " Telnet 서비스가 실행 중입니다." >> $resultfile 2>&1
					return 0
				fi
			done
		fi
		ftp_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ftp_port_count -gt 0 ]; then
			ftp_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ftp_port[@]}; i++))
			do
				netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$i]} " | wc -l`
				if [ $netstat_ftp_count -gt 0 ]; then
					echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
					echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
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
							echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
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
							echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	ps_telnet_count=`ps -ef | grep -i 'telnet' | grep -v 'grep' | wc -l`
	if [ $ps_telnet_count -gt 0 ]; then
		echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " Telnet 서비스가 실행 중입니다." >> $resultfile 2>&1
		return 0
	fi
	ps_ftp_count=`ps -ef | grep -i 'ftp' | grep -v 'grep' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
		return 0
	fi
	find_sshdconfig_count=`find / -name 'sshd_config' -type f 2>/dev/null | wc -l`
	if [ $find_sshdconfig_count -gt 0 ]; then
		sshdconfig_files=(`find / -name 'sshd_config' -type f 2>/dev/null`)
		for ((i=0; i<${#sshdconfig_files[@]}; i++))
		do
			if [ -f ${sshdconfig_files[$i]} ]; then
				if [ `grep -vE '^#|^\s#' ${sshdconfig_files[$i]} | grep -i 'Port' | awk '{print $2}' | wc -l` -gt 0 ]; then
					ssh_port=(`grep -vE '^#|^\s#' ${sshdconfig_files[$i]} | grep -i 'Port' | awk '{print $2}'`)
					for ((j=0; j<${#ssh_port[@]}; j++))
					do
						netstat_ssh_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ssh_port[$j]} " | wc -l`
						if [ $netstat_ssh_count -eq 0 ]; then
							echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " SSH 서비스가 비활성화 상태입니다." >> $resultfile 2>&1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	ps_ssh_count=`ps -ef | grep -i 'sshd' | grep -v 'grep' | wc -l`
	if [ $ps_ssh_count -eq 0 ]; then
		echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " SSH 서비스가 비활성화 상태입니다." >> $resultfile 2>&1
		return 0
	fi
	rpm_ssh_count=`rpm -qa 2>/dev/null | grep '^openssh' | wc -l`
	dnf_ssh_count=`dnf list installed 2>/dev/null | grep -i '^openssh' | wc -l`
	rpm_telnet_count=`rpm -qa 2>/dev/null | grep '^telnet' | wc -l`
	dnf_telnet_count=`dnf list installed 2>/dev/null | grep -i '^telnet' | wc -l`
	if [ $rpm_ssh_count -gt 0 ] && [ $dnf_ssh_count -gt 0 ] && [ $rpm_telnet_count -gt 0 ] && [ $dnf_telnet_count -gt 0 ]; then
		echo "※ U-60 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " SSH 서비스와 Telnet 서비스가 동시에 설치되어 있습니다." >> $resultfile 2>&1
		return 0
	else
		echo "※ U-60 결과 : 양호(Good)" >> $resultfile 2>&1
		return 0
	fi

if [ -f /etc/services ]; then
		ftp_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ftp_port_count -gt 0 ]; then
			ftp_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ftp_port[@]}; i++))
			do
				netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$i]} " | wc -l`
				if [ $netstat_ftp_count -gt 0 ]; then
					echo "※ U-61 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
					echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
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
							echo "※ U-61 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
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
							echo "※ U-61 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
							return 0
						fi
					done
				fi
			fi
		done
	fi
	ps_ftp_count=`ps -ef | grep -iE 'ftp|vsftpd|proftp' | grep -v 'grep' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		echo "※ U-61 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " ftp 서비스가 실행 중입니다." >> $resultfile 2>&1
		return 0
	else
		echo "※ U-61 결과 : 양호(Good)" >> $resultfile 2>&1
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
								echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
								echo " ${ftpusers_files[$i]} 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $resultfile 2>&1
								return 0
							fi
						else
							echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ${ftpusers_files[$i]} 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $resultfile 2>&1
							return 0
						fi
					else
						echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " ${ftpusers_files[$i]} 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $resultfile 2>&1
						return 0
					fi
				else
					echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
					echo " ${ftpusers_files[$i]} 파일의 권한이 640보다 큽니다." >> $resultfile 2>&1
					return 0
				fi
			else
				echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
				echo " ${ftpusers_files[$i]} 파일의 소유자(owner)가 root가 아닙니다." >> $resultfile 2>&1
				return 0
			fi
		fi
	done
	if [ $file_exists_count -eq 0 ]; then
		echo "※ U-63 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " ftp 접근제어 파일이 없습니다." >> $resultfile 2>&1
		return 0
	else
		echo "※ U-63 결과 : 양호(Good)" >> $resultfile 2>&1
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
									echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
									echo " ${ftpusers_files[$j]} 파일에 'RootLogin on' 설정이 있습니다." >> $resultfile 2>&1
									return 0
								fi
							else
								ftp_root_count=`grep -vE '^#|^\s#' ${ftpusers_files[$j]} | grep -w 'root' | wc -l`
								if [ $ftp_root_count -eq 0 ]; then
									echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
									echo " ${ftpusers_files[$j]} 파일에 'root' 계정이 없습니다." >> $resultfile 2>&1
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
		echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " ftp 서비스를 사용하고, 'root' 계정의 접근을 제한할 파일이 없습니다." >> $resultfile 2>&1
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
						echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " ${ftpusers_files[$i]} 파일에 'RootLogin on' 설정이 있습니다." >> $resultfile 2>&1
						return 0
					fi
				else
					ftp_root_count=`grep -vE '^#|^\s#' ${ftpusers_files[$i]} | grep -w 'root' | wc -l`
					if [ $ftp_root_count -eq 0 ]; then
						echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " ${ftpusers_files[$i]} 파일에 'root' 계정이 없습니다." >> $resultfile 2>&1
						return 0
					fi
				fi
			fi
		done
	fi
	if [ $ftp_running_count -gt 0 ] && [ $ftpusers_file_exists_count -eq 0 ]; then
		echo "※ U-64 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " ftp 서비스를 사용하고, 'root' 계정의 접근을 제한할 파일이 없습니다." >> $resultfile 2>&1
		return 0
	fi
	echo "※ U-64 결과 : 양호(Good)" >> $resultfile 2>&1
	return 0


if [ -f /etc/motd ]; then
		if [ `grep -vE '^ *#|^$' /etc/motd | wc -l` -eq 0 ]; then
			echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
			echo " /etc/motd 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
			return 0
		fi
	else
		echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
		echo " /etc/motd 파일이 없습니다." >> $resultfile 2>&1
		return 0
	fi
	if [ -f /etc/services ]; then
		telnet_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $telnet_port_count -gt 0 ]; then
			telnet_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#telnet_port[@]}; i++))
			do
				netstat_telnet_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${telnet_port[$i]} " | wc -l`
				if [ $netstat_telnet_count -gt 0 ]; then
					if [ -f /etc/issue.net ]; then
						if [ `grep -vE '^ *#|^$' /etc/issue.net | wc -l` -eq 0 ]; then
							echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " telnet 서비스를 사용하고, /etc/issue.net 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
							return 0
						fi
					else
						echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " telnet 서비스를 사용하고, /etc/issue.net 파일이 없습니다." >> $resultfile 2>&1
						return 0
					fi
				fi
			done
		fi
	fi
	ps_telnet_count=`ps -ef | grep -i 'telnet' | grep -v 'grep' | wc -l`
	if [ $ps_telnet_count -gt 0 ]; then
		if [ -f /etc/issue.net ]; then
			if [ `grep -vE '^ *#|^$' /etc/issue.net | wc -l` -eq 0 ]; then
				echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
				echo " telnet 서비스를 사용하고, /etc/issue.net 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
				return 0
			fi
		else
			echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
			echo " telnet 서비스를 사용하고, /etc/issue.net 파일이 없습니다." >> $resultfile 2>&1
			return 0
		fi
	fi
	if [ -f /etc/services ]; then
		ftp_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ftp_port_count -gt 0 ]; then
			ftp_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ftp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ftp_port[@]}; i++))
			do
				netstat_ftp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ftp_port[$i]} " | wc -l`
				if [ $netstat_ftp_count -gt 0 ]; then
					ftpdconf_file_exists_count=0
					if [ -f /etc/vsftpd.conf ]; then
						((ftpdconf_file_exists_count++))
						vsftpdconf_banner_count=`grep -vE '^#|^\s#' /etc/vsftpd.conf | grep 'ftpd_banner' | awk -F = '$2!=" " {print $2}' | wc -l`
						if [ $vsftpdconf_banner_count -eq 0 ]; then
							echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스를 사용하고, /etc/vsftpd.conf 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
							return 0
						fi
					fi
					if [ -f /etc/proftpd/proftpd.conf ]; then
						((ftpdconf_file_exists_count++))
						proftpdconf_banner_count=`grep -vE '^#|^\s#' /etc/proftpd/proftpd.conf | grep 'ServerIdent' | wc -l`
						if [ $proftpdconf_banner_count -eq 0 ]; then
							echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스를 사용하고, /etc/proftpd/proftpd.conf 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
							return 0
						fi
					fi
					if [ -f /etc/pure-ftpd/conf/WelcomeMsg ]; then
						((ftpdconf_file_exists_count++))
						pureftpd_conf_banner_count=`grep -vE '^ *#|^$' /etc/pure-ftpd/conf/WelcomeMsg | wc -l`
						if [ $pureftpd_conf_banner_count -eq 0 ]; then
							echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
							echo " ftp 서비스를 사용하고, /etc/pure-ftpd/conf/WelcomeMsg 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
							return 0
						fi
					fi
					if [ $ftpdconf_file_exists_count -eq 0 ]; then
						echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " ftp 서비스를 사용하고, 로그온 메시지를 설정하는 파일이 없습니다." >> $resultfile 2>&1
						return 0
					fi
					
				fi
			done
		fi
	fi
	ps_ftp_count=`ps -ef | grep -i 'ftp' | grep -vE 'grep|tftp|sftp' | wc -l`
	if [ $ps_ftp_count -gt 0 ]; then
		ftpdconf_file_exists_count=0
		if [ -f /etc/vsftpd.conf ]; then
			((ftpdconf_file_exists_count++))
			vsftpdconf_banner_count=`grep -vE '^#|^\s#' /etc/vsftpd.conf | grep 'ftpd_banner' | awk -F = '$2!=" " {print $2}' | wc -l`
			if [ $vsftpdconf_banner_count -eq 0 ]; then
				echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
				echo " ftp 서비스를 사용하고, /etc/vsftpd.conf 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
				return 0
			fi
		fi
		if [ -f /etc/proftpd/proftpd.conf ]; then
			((ftpdconf_file_exists_count++))
			proftpdconf_banner_count=`grep -vE '^#|^\s#' /etc/proftpd/proftpd.conf | grep 'ServerIdent' | wc -l`
			if [ $proftpdconf_banner_count -eq 0 ]; then
				echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
				echo " ftp 서비스를 사용하고, /etc/proftpd/proftpd.conf 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
				return 0
			fi
		fi
		if [ -f /etc/pure-ftpd/conf/WelcomeMsg ]; then
			((ftpdconf_file_exists_count++))
			pureftpd_conf_banner_count=`grep -vE '^ *#|^$' /etc/pure-ftpd/conf/WelcomeMsg | wc -l`
			if [ $pureftpd_conf_banner_count -eq 0 ]; then
				echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
				echo " ftp 서비스를 사용하고, /etc/pure-ftpd/conf/WelcomeMsg 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
				return 0
			fi
		fi
		if [ $ftpdconf_file_exists_count -eq 0 ]; then
			echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
			echo " ftp 서비스를 사용하고, 로그온 메시지를 설정하는 파일이 없습니다." >> $resultfile 2>&1
			return 0
		fi
	fi
	if [ -f /etc/services ]; then
		smtp_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="smtp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $smtp_port_count -gt 0 ]; then
			smtp_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="smtp" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#smtp_port[@]}; i++))
			do
				netstat_smtp_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${smtp_port[$i]} " | wc -l`
				if [ $netstat_smtp_count -gt 0 ]; then
					find_sendmailcf_count=`find / -name 'sendmail.cf' -type f 2>/dev/null | wc -l`
					if [ $find_sendmailcf_count -gt 0 ]; then
						sendmailcf_files=(`find / -name 'sendmail.cf' -type f 2>/dev/null`)
						for ((j=0; j<${#sendmailcf_files[@]}; j++))
						do
							sendmailcf_banner_count=`grep -vE '^#|^\s#' ${sendmailcf_files[$j]} | grep 'Smtp' | grep 'GreetingMessage' | awk -F = '{gsub(" ", "", $0); print $2}' | wc -l`
							if [ $sendmailcf_banner_count -eq 0 ]; then
								echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
								echo " smtp 서비스를 사용하고, ${sendmailcf_files[$j]} 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
								return 0
							fi
						done
					else
						echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
						echo " smtp 서비스를 사용하고, 로그온 메시지를 설정하는 파일이 없습니다." >> $resultfile 2>&1
						return 0
					fi
				fi
			done
		fi
	fi
	ps_smtp_count=`ps -ef | grep -iE 'smtp|sendmail' | grep -v 'grep' | wc -l`
	if [ $ps_smtp_count -gt 0 ]; then
		find_sendmailcf_count=`find / -name 'sendmail.cf' -type f 2>/dev/null | wc -l`
		if [ $find_sendmailcf_count -gt 0 ]; then
			sendmailcf_files=(`find / -name 'sendmail.cf' -type f 2>/dev/null`)
			for ((i=0; i<${#sendmailcf_files[@]}; i++))
			do
				sendmailcf_banner_count=`grep -vE '^#|^\s#' ${sendmailcf_files[$i]} | grep 'Smtp' | grep 'GreetingMessage' | awk -F = '{gsub(" ", "", $0); print $2}' | wc -l`
				if [ $sendmailcf_banner_count -eq 0 ]; then
					echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
					echo " smtp 서비스를 사용하고, ${sendmailcf_files[$i]} 파일에 로그온 메시지를 설정하지 않았습니다." >> $resultfile 2>&1
					return 0
				fi
			done
		else
			echo "※ U-68 결과 : 취약(Vulnerable)" >> $resultfile 2>&1
			echo " smtp 서비스를 사용하고, 로그온 메시지를 설정하는 파일이 없습니다." >> $resultfile 2>&1
			return 0
		fi
	fi
	echo "※ U-68 결과 : 양호(Good)" >> $resultfile 2>&1
	return 0

cat $result

echo ; echo

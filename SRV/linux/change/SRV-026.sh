#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-026] root 계정 원격 접속 제한 미비

cat << EOF >> $TMP1
[양호]: SSH를 통한 root 계정의 원격 접속이 제한된 경우
[취약]: SSH를 통한 root 계정의 원격 접속이 제한되지 않은 경우
EOF

BAR

# SSH 설정 파일에서 root 로그인을 허용하는 설정을 확인합니다.
if [ -f /etc/services ]; then
		# /etc/services 파일 내 telnet 서비스의 포트 번호가 설정되어 있는지 확인하고, 설정되어 있다면 실행 중인지 확인함
		telnet_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $telnet_port_count -gt 0 ]; then
			telnet_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="telnet" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#telnet_port[@]}; i++))
			do
				netstat_telnet_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${telnet_port[$i]} " | wc -l`
				if [ $netstat_telnet_count -gt 0 ]; then
					if [ -f /etc/pam.d/login ]; then
						pam_securetty_so_count=`grep -vE '^#|^\s#' /etc/pam.d/login | grep -i 'pam_securetty.so' | wc -l`
						if [ $pam_securetty_so_count -gt 0 ]; then
							if [ -f /etc/securetty ]; then
								etc_securetty_pts_count=`grep -vE '^#|^\s#' /etc/securetty | grep '^ *pts' | wc -l`
								if [ $etc_securetty_pts_count -gt 0 ]; then
									WARN " telnet 서비스를 사용하고, /etc/securetty 파일에 pts 부분이 제거 또는 주석 처리되어 있지 않습니다." >> $TMP1
									return 0
								fi
							else
								WARN " telnet 서비스를 사용하고, /etc/securetty 파일이 없습니다." >> $TMP1
								return 0
							fi
						else
							WARN " telnet 서비스를 사용하고, /etc/pam.d/login 파일에 pam_securetty.so 모듈이 제거 또는 주석 처리되어 있습니다." >> TMP1
							return 0
						fi
					else
						WARN " telnet 서비스를 사용하고, /etc/pam.d/login 파일이 없습니다." >> TMP1
						return 0
					fi
				fi
			done
		fi
	fi
	# 위 과정에서 확인되지 않을 경우를 대비하여 ps 명령으로 telnet 서비스가 실행 중인지 확인함
	ps_telnet_count=`ps -ef | grep -i 'telnet' | grep -v 'grep' | wc -l`
	if [ $ps_telnet_count -gt 0 ]; then
		if [ -f /etc/pam.d/login ]; then
			pam_securetty_so_count=`grep -vE '^#|^\s#' /etc/pam.d/login | grep -i 'pam_securetty.so' | wc -l`
			if [ $pam_securetty_so_count -gt 0 ]; then
				if [ -f /etc/securetty ]; then
					etc_securetty_pts_count=`grep -vE '^#|^\s#' /etc/securetty | grep '^ *pts' | wc -l`
					if [ $etc_securetty_pts_count -gt 0 ]; then
						WARN " telnet 서비스를 사용하고, /etc/securetty 파일에 pts 부분이 제거 또는 주석 처리되어 있지 않습니다." >> TMP1
						return 0
					fi
				else
					WARN " telnet 서비스를 사용하고, /etc/securetty 파일이 없습니다." >> TMP1
					return 0
				fi
			else
				WARN " telnet 서비스를 사용하고, /etc/pam.d/login 파일에 pam_securetty.so 모듈이 제거 또는 주석 처리되어 있습니다." >> TMP1
				return 0
			fi
		else
			WARN " telnet 서비스를 사용하고, /etc/pam.d/login 파일이 없습니다." >> TMP1
			return 0
		
		fi
	fi
	# sshd_config 파일의 존재 여부를 검색하고, 존재한다면 ssh 서비스가 실행 중일 때 점검할 별도의 배열에 저장함
	sshd_config_count=`find / -name 'sshd_config' -type f 2> /dev/null | wc -l`
	if [ $sshd_config_count -gt 0 ]; then
		sshd_config_file=(`find / -name 'sshd_config' -type f 2> /dev/null`)
	fi
	# /etc/services 파일 내 ssh 서비스의 포트 번호가 설정되어 있는지 확인하고, 설정되어 있다면 실행 중인지 확인함
	if [ -f /etc/services ]; then
		ssh_port_count=`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ssh" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}' | wc -l`
		if [ $ssh_port_count -gt 0 ]; then
			ssh_port=(`grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)=="ssh" {print $2}' | awk -F / 'tolower($2)=="tcp" {print $1}'`)
			for ((i=0; i<${#ssh_port[@]}; i++))
			do
				netstat_sshd_enable_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ssh_port[$i]} " | wc -l`
				if [ $netstat_sshd_enable_count -gt 0 ]; then
					if [ ${#sshd_config_file[@]} -eq 0 ]; then
						WARN " ssh 서비스를 사용하고, sshd_config 파일이 없습니다." >> TMP1
						return 0
					fi
					for ((j=0; j<${#sshd_config_file[@]}; j++))
					do
						sshd_permitrootlogin_no_count=`grep -vE '^#|^\s#' ${sshd_config_file[$j]} | grep -i 'permitrootlogin' | grep -i 'no' | wc -l`
						if [ $sshd_permitrootlogin_no_count -eq 0 ]; then
							WARN " ssh 서비스를 사용하고, sshd_config 파일에서 root 계정의 원격 접속이 허용되어 있습니다." >> TMP1
							return 0
						fi
					done
				fi
			done
		fi
	fi
	# 위 과정에서 확인되지 않을 경우를 대비하여 sshd_config 파일 내 ssh 서비스의 포트 번호가 설정되어 있는지 확인하고, 설정되어 있다면 실행 중인지 확인함
	if [ ${#sshd_config_file[@]} -gt 0 ]; then
		for ((i=0; i<${#sshd_config_file[@]}; i++))
		do
			ssh_port_count=`grep -vE '^#|^\s#' ${sshd_config_file[$i]} | grep -i 'port'  | awk '{print $2}' | wc -l`
			if [ $ssh_port_count -gt 0 ]; then
				ssh_port=(`grep -vE '^#|^\s#' ${sshd_config_file[$i]} | grep -i 'port'  | awk '{print $2}'`)
				for ((j=0; j<${#ssh_port[@]}; j++))
				do
					netstat_sshd_enable_count=`netstat -nat 2>/dev/null | grep -w 'tcp' | grep -Ei 'listen|established|syn_sent|syn_received' | grep ":${ssh_port[$j]} " | wc -l`
					if [ $netstat_sshd_enable_count -gt 0 ]; then
						for ((k=0; k<${#sshd_config_file[@]}; k++))
						do
							sshd_permitrootlogin_no_count=`grep -vE '^#|^\s#' ${sshd_config_file[$k]} | grep -i 'permitrootlogin' | grep -i 'no' | wc -l`
							if [ $sshd_permitrootlogin_no_count -eq 0 ]; then
								WARN " ssh 서비스를 사용하고, sshd_config 파일에서 root 계정의 원격 접속이 허용되어 있습니다." >> TMP1
								return 0
							fi
						done
					fi
				done
			fi
		done
	fi
	# 위 과정에서 확인되지 않을 경우를 대비하여 ps 명령으로 ssh 서비스가 실행 중인지 확인함
	ps_sshd_enable_count=`ps -ef | grep -i 'sshd' | grep -v 'grep' | wc -l`
	if [ $ps_sshd_enable_count -gt 0 ]; then
		if [ ${#sshd_config_file[@]} -eq 0 ]; then
			WARN " ssh 서비스를 사용하고, sshd_config 파일이 없습니다." >> TMP1
			return 0
		fi
		for ((i=0; i<${#sshd_config_file[@]}; i++))
		do
			sshd_permitrootlogin_no_count=`grep -vE '^#|^\s#' ${sshd_config_file[$i]} | grep -i 'permitrootlogin' | grep -i 'no' | wc -l`
			if [ $sshd_permitrootlogin_no_count -eq 0 ]; then
				WARN " ssh 서비스를 사용하고, sshd_config 파일에서 root 계정의 원격 접속이 허용되어 있습니다." >> TMP1
				return 0
			fi
		done
	fi
	OK "SSH를 통한 root 계정의 원격 접속이 제한" >> TMP1
	return 0

cat TMP1

echo ; echo

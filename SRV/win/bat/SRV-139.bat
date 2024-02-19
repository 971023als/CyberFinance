#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡

cat << EOF >> $result
[양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우
[취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우
EOF

BAR

if [ -f /etc/passwd ]; then		
		etc_passwd_owner_name=`ls -l /etc/passwd | awk '{print $3}'`
		if [[ $etc_passwd_owner_name =~ root ]]; then
			etc_passwd_permission=`stat /etc/passwd | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_passwd_permission -le 644 ]; then
				etc_passwd_owner_permission=`stat /etc/passwd | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
				if [ $etc_passwd_owner_permission -eq 0 ] || [ $etc_passwd_owner_permission -eq 2 ] || [ $etc_passwd_owner_permission -eq 4 ] || [ $etc_passwd_owner_permission -eq 6 ]; then
					etc_passwd_group_permission=`stat /etc/passwd | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
					if [ $etc_passwd_group_permission -eq 0 ] || [ $etc_passwd_group_permission -eq 4 ]; then
						etc_passwd_other_permission=`stat /etc/passwd | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
						if [ $etc_passwd_other_permission -eq 0 ] || [ $etc_passwd_other_permission -eq 4 ]; then
							OK "※ U-07 결과 : 양호(Good)" >> $TMP1
							return 0
						else
							WARN " /etc/passwd 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/passwd 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/passwd 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
		else
			WARN " /etc/passwd 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/passwd 파일이 없습니다." >> $TMP1
		return 0
	fi

if [ -f /etc/shadow ]; then
		etc_shadow_owner_name=`ls -l /etc/shadow | awk '{print $3}'`
		if [[ $etc_shadow_owner_name =~ root ]]; then
			etc_shadow_permission=`stat /etc/shadow | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_shadow_permission -le 400 ]; then
				etc_shadow_owner_permission=`stat /etc/shadow | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
				if [ $etc_shadow_owner_permission -eq 0 ] || [ $etc_shadow_owner_permission -eq 4 ]; then
					etc_shadow_group_permission=`stat /etc/shadow | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
					if [ $etc_shadow_group_permission -eq 0 ]; then
						etc_shadow_other_permission=`stat /etc/shadow | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
						if [ $etc_shadow_other_permission -eq 0 ]; then
							OK "※ U-08 결과 : 양호(Good)" >> $TMP1
							return 0
						else
							WARN " /etc/shadow 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/shadow 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/shadow 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
		else
			WARN " /etc/shadow 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/shadow 파일이 없습니다." >> $TMP1
		return 0
	fi

if [ -f /etc/hosts ]; then
		etc_hosts_owner_name=`ls -l /etc/hosts | awk '{print $3}'`
		if [[ $etc_hosts_owner_name =~ root ]]; then
			etc_hosts_permission=`stat /etc/hosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_hosts_permission -le 600 ]; then
				etc_hosts_owner_permission=`stat /etc/hosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
				if [ $etc_hosts_owner_permission -eq 0 ] || [ $etc_hosts_owner_permission -eq 2 ] || [ $etc_hosts_owner_permission -eq 4 ] || [ $etc_hosts_owner_permission -eq 6 ]; then
					etc_hosts_group_permission=`stat /etc/hosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
					if [ $etc_hosts_group_permission -eq 0 ]; then
						etc_hosts_other_permission=`stat /etc/hosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
						if [ $etc_hosts_other_permission -eq 0 ]; then
							OK "※ U-09 결과 : 양호(Good)" >> $TMP1
							return 0
						else
							WARN " /etc/hosts 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/hosts 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/hosts 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
		else
			WARN " /etc/hosts 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	else
		INFO "※ U-09 결과 : N/A" >> $TMP1
		WARN " /etc/hosts 파일이 없습니다." >> $TMP1
		return 0
	fi

file_exists_count=0
	if [ -f /etc/xinetd.conf ]; then
		((file_exists_count++))
		etc_xinetdconf_owner_name=`ls -l /etc/xinetd.conf | awk '{print $3}'`
		if [[ $etc_xinetdconf_owner_name =~ root ]]; then
			etc_xinetdconf_permission=`stat /etc/xinetd.conf | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_xinetdconf_permission -ne 600 ]; then
			WARN " /etc/xinetd.conf 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	fi
	if [ -d /etc/xinetd.d ]; then
		etc_xinetdd_file_count=`find /etc/xinetd.d -type f 2>/dev/null | wc -l`
		if [ $etc_xinetdd_file_count -gt 0 ]; then
			xinetdd_files=(`find /etc/xinetd.d -type f 2>/dev/null`)
			for ((i=0; i<${#xinetdd_files[@]}; i++))
			do
				xinetdd_file_owner_name=`ls -l ${xinetdd_files[$i]} | awk '{print $3}'`
				if [[ $xinetdd_file_owner_name =~ root ]]; then
					xinetdd_file_permission=`stat ${xinetdd_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
					WARN " /etc/xinetd.d 디렉터리 내 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
					return 0
				fi
			done
		fi
	fi
	if [ -f /etc/inetd.conf ]; then
		((file_exists_count++))
		etc_inetdconf_owner_name=`ls -l /etc/inetd.conf | awk '{print $3}'`
		if [[ $etc_inetdconf_owner_name =~ root ]]; then
			etc_inetdconf_permission=`stat /etc/inetd.conf | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			WARN " /etc/inetd.conf 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	fi
	if [ $file_exists_count -eq 0 ]; then
		INFO " /etc/(x)inetd.conf 파일이 없습니다." >> $TMP1
	else
		OK "※ U-10 결과 : 양호(Good)" >> $TMP1
	fi

syslogconf_files=("/etc/rsyslog.conf" "/etc/syslog.conf" "/etc/syslog-ng.conf")
	file_exists_count=0
	for ((i=0; i<${#syslogconf_files[@]}; i++))
	do
		if [ -f ${syslogconf_files[$i]} ]; then
			((file_exists_count++))
			syslogconf_file_owner_name=`ls -l ${syslogconf_files[$i]} | awk '{print $3}'`
			if [[ $syslogconf_file_owner_name =~ root ]] || [[ $syslogconf_file_owner_name =~ bin ]] || [[ $syslogconf_file_owner_name =~ sys ]]; then
				syslogconf_file_permission=`stat ${syslogconf_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
				if [ $syslogconf_file_permission -le 640 ]; then
					syslogconf_file_owner_permission=`stat ${syslogconf_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
					if [ $syslogconf_file_owner_permission -eq 6 ] || [ $syslogconf_file_owner_permission -eq 4 ] || [ $syslogconf_file_owner_permission -eq 2 ] || [ $syslogconf_file_owner_permission -eq 0 ]; then
						syslogconf_file_group_permission=`stat ${syslogconf_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
						if [ $syslogconf_file_group_permission -eq 4 ] || [ $syslogconf_file_group_permission -eq 2 ] || [ $syslogconf_file_group_permission -eq 0 ]; then
							syslogconf_file_other_permission=`stat ${syslogconf_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
							if [ $syslogconf_file_other_permission -ne 0 ]; then
								WARN " ${syslogconf_files[$i]} 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
								return 0
							fi
						else
							WARN " ${syslogconf_files[$i]} 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " ${syslogconf_files[$i]} 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${syslogconf_files[$i]} 파일의 권한이 640보다 큽니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${syslogconf_files[$i]} 파일의 소유자(owner)가 root(또는 bin, sys)가 아닙니다." >> $TMP1
				return 0
			fi
		fi
	done
	if [ $file_exists_count -eq 0 ]; then
		INFO " /etc/syslog.conf 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "※ U-11 결과 : 양호(Good)" >> $TMP1
		return 0
	fi  

if [ -f /etc/services ]; then
		etc_services_owner_name=`ls -l /etc/services | awk '{print $3}'`
		if [[ $etc_services_owner_name =~ root ]] || [[ $etc_services_owner_name =~ bin ]] || [[ $etc_services_owner_name =~ sys ]]; then
			etc_services_permission=`stat /etc/services | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_services_permission -le 644 ]; then
				etc_services_owner_permission=`stat /etc/services | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
				if [ $etc_services_owner_permission -eq 6 ] || [ $etc_services_owner_permission -eq 4 ] || [ $etc_services_owner_permission -eq 2 ] || [ $etc_services_owner_permission -eq 0 ]; then
					etc_services_group_permission=`stat /etc/services | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
					if [ $etc_services_group_permission -eq 4 ] || [ $etc_services_group_permission -eq 0 ]; then
						etc_services_other_permission=`stat /etc/services | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
						if [ $etc_services_other_permission -eq 4 ] || [ $etc_services_other_permission -eq 0 ]; then
							OK "※ U-12 결과 : 양호(Good)" >> $TMP1
							return 0
						else
							WARN " /etc/services 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/services 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/services 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
			fi
		else
			WARN " /etc/services 파일의 파일의 소유자(owner)가 root(또는 bin, sys)가 아닙니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/services 파일이 없습니다." >> $TMP1
		return 0
	fi

user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
	user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
	done
	user_homedirectory_owner_name=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $1}' /etc/passwd`) # /etc/passwd 파일에 설정된 사용자명 배열 생성
	user_homedirectory_owner_name2=() # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 저장할 빈 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_owner_name2[${#user_homedirectory_owner_name2[@]}]=`WARN ${user_homedirectory_path2[$i]} | awk -F / '{print $3}'` # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 배열에 저장함
	done
	for ((i=0; i<${#user_homedirectory_owner_name2[@]}; i++))
	do
		user_homedirectory_owner_name[${#user_homedirectory_owner_name[@]}]=${user_homedirectory_owner_name2[$i]} # 두 개의 배열 합침
	done
	start_files=(".profile" ".cshrc" ".login" ".kshrc" ".bash_profile" ".bashrc" ".bash_login")
	for ((i=0; i<${#user_homedirectory_path[@]}; i++))
	do
		for ((j=0; j<${#start_files[@]}; j++))
		do
			if [ -f ${user_homedirectory_path[$i]}/${start_files[$j]} ]; then
				user_homedirectory_owner_name2=`ls -l ${user_homedirectory_path[$i]}/${start_files[$j]} | awk '{print $3}'`
				if [[ $user_homedirectory_owner_name2 =~ root ]] || [[ $user_homedirectory_owner_name2 =~ ${user_homedirectory_owner_name[$i]} ]]; then
					user_homedirectory_other_execute_permission=`ls -l ${user_homedirectory_path[$i]}/${start_files[$j]} | awk '{print substr($1,9,1)}'`
					if [[ $user_homedirectory_other_execute_permission =~ w ]]; then
						WARN " ${user_homedirectory_path[$i]} 홈 디렉터리 내 ${start_files[$j]} 환경 변수 파일에 다른 사용자(other)의 쓰기(w) 권한이 부여 되어 있습니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${user_homedirectory_path[$i]} 홈 디렉터리 내 ${start_files[$j]} 환경 변수 파일의 소유자(owner)가 root 또는 해당 계정이 아닙니다." >> $TMP1
					return 0
				fi
			fi
		done
	done
	OK "※ U-14 결과 : 양호(Good)" >> $TMP1
	return 0

user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
	user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
	done
	user_homedirectory_owner_name=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $1}' /etc/passwd`) # /etc/passwd 파일에 설정된 사용자명 배열 생성
	user_homedirectory_owner_name2=() # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 저장할 빈 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_owner_name2[${#user_homedirectory_owner_name2[@]}]=`WARN ${user_homedirectory_path2[$i]} | awk -F / '{print $3}'` # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 배열에 저장함
	done
	for ((i=0; i<${#user_homedirectory_owner_name2[@]}; i++))
	do
		user_homedirectory_owner_name[${#user_homedirectory_owner_name[@]}]=${user_homedirectory_owner_name2[$i]} # 두 개의 배열 합침
	done
	r_command=("rsh" "rlogin" "rexec" "shell" "login" "exec")
	# /etc/xinetd.d 디렉터리 내 r command 파일 확인함
	if [ -d /etc/xinetd.d ]; then
		for ((i=0; i<${#r_command[@]}; i++))
		do
			if [ -f /etc/xinetd.d/${r_command[$i]} ]; then
				etc_xinetdd_rcommand_disable_count=`grep -vE '^#|^\s#' /etc/xinetd.d/${r_command[$i]} | grep -i 'disable' | grep -i 'yes' | wc -l`
				if [ $etc_xinetdd_rcommand_disable_count -eq 0 ]; then
					if [ -f /etc/hosts.equiv ]; then
						etc_hostsequiv_owner_name=`ls -l /etc/hosts.equiv | awk '{print $3}'`
						if [[ $etc_hostsequiv_owner_name =~ root ]]; then
							etc_hostsequiv_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
							if [ $etc_hostsequiv_permission -le 600 ]; then
								etc_hostsequiv_owner_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
								if [ $etc_hostsequiv_owner_permission -eq 6 ] || [ $etc_hostsequiv_owner_permission -eq 4 ] || [ $etc_hostsequiv_owner_permission -eq 2 ] || [ $etc_hostsequiv_owner_permission -eq 0 ]; then
									etc_hostsequiv_group_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
									if [ $etc_hostsequiv_group_permission -eq 0 ]; then
										etc_hostsequiv_other_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
										if [ $etc_hostsequiv_other_permission -eq 0 ]; then
											WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
											return 0
										fi
									else
										WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
										return 0
									fi
								else
									WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
									return 0
								fi
							else
								WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 권한이 600보다 큽니다." >> $TMP1
								return 0
							fi
						else
							WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
							return 0
						fi
					fi
					# 사용자 홈 디렉터리 내 .rhosts 파일 확인함
					for ((j=0; j<${#user_homedirectory_path[@]}; j++))
					do
						if [ -f ${user_homedirectory_path[$j]}/.rhosts ]; then
							user_homedirectory_rhosts_owner_name=`ls -l ${user_homedirectory_path[$j]}/.rhosts | awk '{print $3}'`
							if [[ $user_homedirectory_rhosts_owner_name =~ root ]] || [[ $user_homedirectory_rhosts_owner_name =~ ${user_homedirectory_owner_name[$j]} ]]; then
								user_homedirectory_rhosts_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
								if [ $user_homedirectory_rhosts_permission -le 600 ]; then
									user_homedirectory_rhosts_owner_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
									if [ $user_homedirectory_rhosts_owner_permission -eq 6 ] || [ $user_homedirectory_rhosts_owner_permission -eq 4 ] || [ $user_homedirectory_rhosts_owner_permission -eq 2 ] || [ $user_homedirectory_rhosts_owner_permission -eq 0 ]; then
										user_homedirectory_rhosts_group_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
										if [ $user_homedirectory_rhosts_group_permission -eq 0 ]; then
											user_homedirectory_rhosts_other_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
											if [ $user_homedirectory_rhosts_other_permission -eq 0 ]; then
												WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
												return 0
											fi
										else
											WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
											return 0
										fi
									else
										WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
										return 0
									fi
								else
									WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 권한이 600보다 큽니다." >> $TMP1
									return 0
								fi
							else
								WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 소유자(owner)가 root 또는 해당 계정이 아닙니다." >> $TMP1
								return 0
							fi
						fi
					done
				fi
			fi
		done
	fi
	# /etc/inetd.conf 파일 내 r command 서비스 확인함
	if [ -f /etc/inetd.conf ]; then
		for ((i=0; i<${#r_command[@]}; i++))
		do
			if [ `grep -vE '^#|^\s#' /etc/inetd.conf | grep  ${r_command[$i]} | wc -l` -gt 0 ]; then
				if [ -f /etc/hosts.equiv ]; then
					etc_hostsequiv_owner_name=`ls -l /etc/hosts.equiv | awk '{print $3}'`
					if [[ $etc_hostsequiv_owner_name =~ root ]]; then
						etc_hostsequiv_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
						if [ $etc_hostsequiv_permission -le 600 ]; then
							etc_hostsequiv_owner_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
							if [ $etc_hostsequiv_owner_permission -eq 6 ] || [ $etc_hostsequiv_owner_permission -eq 4 ] || [ $etc_hostsequiv_owner_permission -eq 2 ] || [ $etc_hostsequiv_owner_permission -eq 0 ]; then
								etc_hostsequiv_group_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
								if [ $etc_hostsequiv_group_permission -eq 0 ]; then
									etc_hostsequiv_other_permission=`stat /etc/hosts.equiv | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
									if [ $etc_hostsequiv_other_permission -eq 0 ]; then
										WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
										return 0
									fi
								else
									WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
									return 0
								fi
							else
								WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
								return 0
							fi
						else
							WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 권한이 600보다 큽니다." >> $TMP1
							return 0
						fi
					else
						WARN " r 계열 서비스를 사용하고, /etc/hosts.equiv 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
						return 0
					fi
				fi
				# 사용자 홈 디렉터리 내 .rhosts 파일 확인함
				for ((j=0; j<${#user_homedirectory_path[@]}; j++))
				do
					if [ -f ${user_homedirectory_path[$j]}/.rhosts ]; then
						user_homedirectory_rhosts_owner_name=`ls -l ${user_homedirectory_path[$j]}/.rhosts | awk '{print $3}'`
						if [[ $user_homedirectory_rhosts_owner_name =~ root ]] || [[ $user_homedirectory_rhosts_owner_name =~ ${user_homedirectory_owner_name[$j]} ]]; then
							user_homedirectory_rhosts_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
							if [ $user_homedirectory_rhosts_permission -le 600 ]; then
								user_homedirectory_rhosts_owner_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
								if [ $user_homedirectory_rhosts_owner_permission -eq 6 ] || [ $user_homedirectory_rhosts_owner_permission -eq 4 ] || [ $user_homedirectory_rhosts_owner_permission -eq 2 ] || [ $user_homedirectory_rhosts_owner_permission -eq 0 ]; then
									user_homedirectory_rhosts_group_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
									if [ $user_homedirectory_rhosts_group_permission -eq 0 ]; then
										user_homedirectory_rhosts_other_permission=`stat ${user_homedirectory_path[$j]}/.rhosts | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
										if [ $user_homedirectory_rhosts_other_permission -eq 0 ]; then
											WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
											return 0
										fi
									else
										WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
										return 0
									fi
								else
									WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
									return 0
								fi
							else
								WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 권한이 600보다 큽니다." >> $TMP1
								return 0
							fi
						else
							WARN " r 계열 서비스를 사용하고, 사용자 홈 디렉터리 내 .rhosts 파일의 소유자(owner)가 root 또는 해당 계정이 아닙니다." >> $TMP1
							return 0
						fi
					fi
				done
			fi
		done
	fi
	OK "※ U-17 결과 : 양호(Good)" >> $TMP1
	return 0

crontab_path=("/usr/bin/crontab" "/usr/sbin/crontab" "/bin/crontab")
	if [ `which crontab 2>/dev/null | wc -l` -gt 0 ]; then
		crontab_path[${#crontab_path[@]}]=`which crontab 2>/dev/null`
	fi
	for ((i=0; i<${#crontab_path[@]}; i++))
	do
		if [ -f ${crontab_path[$i]} ]; then
			crontab_permission=`stat ${crontab_path[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,2)}'` # group, owner 권한만 추출함
			if [ $crontab_permission -le 50 ]; then
				crontab_group_permission=`stat ${crontab_path[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
				if [ $crontab_group_permission -eq 5 ] || [ $crontab_group_permission -eq 4 ] || [ $crontab_group_permission -eq 1 ] || [ $crontab_group_permission -eq 0 ]; then
					crontab_other_permission=`stat ${crontab_path[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
					if [ $crontab_other_permission -ne 0 ]; then
						WARN " ${crontab_path[$i]} 명령어의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${crontab_path[$i]} 명령어의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${crontab_path[$i]} 명령어의 권한이 750보다 큽니다." >> $TMP1
				return 0
			fi
		fi
	done
	cron_directory=("/etc/cron.hourly" "/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.monthly" "/var/spool/cron" "/var/spool/cron/crontabs")
	cron_file=("/etc/crontab" "/etc/cron.allow" "/etc/cron.deny")
	for ((i=0; i<${#cron_directory[@]}; i++))
	do
		cron_file_count=`find ${cron_directory[$i]} -type f 2>/dev/null | wc -l`
		if [ $cron_file_count -gt 0 ]; then
			cron_file2=(`find ${cron_directory[$i]} -type f 2>/dev/null`)
			for ((j=0; j<${#cron_file2[@]}; j++))
			do
				cron_file[${#cron_file[@]}]=${cron_file2[$j]}
			done
		fi
	done
	for ((i=0; i<${#cron_file[@]}; i++))
	do
		if [ -f ${cron_file[$i]} ]; then
			cron_file_owner_name=`ls -l ${cron_file[$i]} | awk '{print $3}'`
			if [[ $cron_file_owner_name =~ root ]]; then
				cron_file_permission=`stat ${cron_file[$i]}| grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
				if [ $cron_file_permission -le 640 ]; then
					cron_file_owner_permission=`stat ${cron_file[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
					if [ $cron_file_owner_permission -eq 6 ] || [ $cron_file_owner_permission -eq 4 ] || [ $cron_file_owner_permission -eq 2 ] || [ $cron_file_owner_permission -eq 0 ]; then
						cron_file_group_permission=`stat ${cron_file[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
						if [ $cron_file_group_permission -eq 4 ] || [ $cron_file_group_permission -eq 0 ]; then
							cron_file_other_permission=`stat ${cron_file[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
							if [ $cron_file_other_permission -ne 0 ]; then
								WARN " ${cron_file[$i]} 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
								return 0
							fi
						else
							WARN " ${cron_file[$i]} 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " ${cron_file[$i]} 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${cron_file[$i]} 파일의 권한이 640보다 큽니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${cron_file[$i]} 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
				return 0
			fi
		fi
	done
	OK "※ U-22 결과 : 양호(Good)" >> $TMP1
	return 0

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
		INFO " ftp 접근제어 파일이 없습니다." >> $TMP1
		return 0
	else
		OK "※ U-63 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd | uniq`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
	user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
	done
	path_setting_files=(".profile" ".cshrc" ".login" ".kshrc" ".bash_profile" ".bashrc" ".bash_login")
	path=(`WARN $PATH | awk -F : '{for (i=1; i<=NF; i++) {print $i}}'`)
	for ((i=0; i<${#user_homedirectory_path[@]}; i++))
	do
		for ((j=0; j<${#path_setting_files[@]}; j++))
		do
			if [ -f ${user_homedirectory_path[$i]}/${path_setting_files[$j]} ]; then
				user_homedirectory_path_count=`grep -i 'path' ${user_homedirectory_path[$i]}/${path_setting_files[$j]} | wc -l`
				if [ $user_homedirectory_path_count -gt 0 ]; then
					path_setting_file_in_path=(`grep -i 'PATH' ${user_homedirectory_path[$i]}/${path_setting_files[$j]} | awk -F \" '{print $2}' | awk -F : '{for (l=1;l<=NF;l++) {print $l}}'`)
					for ((k=0; k<${#path_setting_file_in_path[@]}; k++))
					do
						if [[ ${path_setting_file_in_path[$k]} != \$PATH ]]; then
							if [[ ${path_setting_file_in_path[$k]} == \$HOME* ]]; then
								path_setting_file_in_path[$k]=$(WARN ${path_setting_file_in_path[$k]} | awk -v u65_awk=${user_homedirectory_path[i]} '{gsub("\\$HOME",u65_awk,$0)} 1')
							fi
							path[${#path[@]}]=${path_setting_file_in_path[$k]}
						fi
					done
				fi
			fi
		done
	done
	for ((i=0; i<${#path[@]}; i++))
	do
		if [ -f ${path[$i]}/at ]; then
			at_file_group_permission=`stat ${path[$i]}/at | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
			if [ $at_file_group_permission -eq 5 ] || [ $at_file_group_permission -eq 4 ] || [ $at_file_group_permission -eq 1 ] || [ $at_file_group_permission -eq 0 ]; then
				at_file_other_permission=`stat ${path[$i]}/at | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
				if [ $at_file_other_permission -ne 0 ]; then
					WARN " ${path[$i]}/at 실행 파일이 다른 사용자(other)에 의해 실행이 가능합니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${path[$i]}/at 실행 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
				return 0
			fi
		fi
	done
	at_access_control_files=("/etc/at.allow" "/etc/at.deny")
	for ((i=0; i<${#at_access_control_files[@]}; i++))
	do
		if [ -f ${at_access_control_files[$i]} ]; then
			at_file_owner_name=`ls -l ${at_access_control_files[$i]} | awk '{print $3}'`
			if [[ $at_file_owner_name =~ root ]]; then
				at_file_permission=`stat ${at_access_control_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
				if [ $at_file_permission -le 640 ]; then
					at_file_owner_permission=`stat ${at_access_control_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
					if [ $at_file_owner_permission -eq 6 ] || [ $at_file_owner_permission -eq 4 ] || [ $at_file_owner_permission -eq 2 ] || [ $at_file_owner_permission -eq 0 ]; then
						at_file_group_permission=`stat ${at_access_control_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
						if [ $at_file_group_permission -eq 4 ] || $at_file_owner_permission -eq 0 ]; then
							at_file_other_permission=`stat ${at_access_control_files[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
							if [ $at_file_other_permission -ne 0 ]; then
								WARN " ${at_access_control_files[$i]} 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
								return 0
							fi
						else
							WARN " ${at_access_control_files[$i]} 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " ${at_access_control_files[$i]} 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${at_access_control_files[$i]} 파일의 권한이 640보다 큽니다." >> $TMP1
					return 0
				fi
			else
				WARN " ${at_access_control_files[$i]} 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
				return 0
			fi
		fi
	done
	OK "※ U-65 결과 : 양호(Good)" >> $TMP1
	return 0

if [ -f /etc/exports ]; then
		etc_exports_owner_name=`ls -l /etc/exports | awk '{print $3}'`
		if [[ $etc_exports_owner_name =~ root ]]; then
			etc_exports_permission=`stat /etc/exports | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,3)}'`
			if [ $etc_exports_permission -le 644 ]; then
				etc_exports_owner_permission=`stat /etc/exports | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,3,1)}'`
				if [ $etc_exports_owner_permission -eq 6 ] || [ $etc_exports_owner_permission -eq 4 ] || [ $etc_exports_owner_permission -eq 2 ] || [ $etc_exports_owner_permission -eq 0 ]; then
					etc_exports_group_permission=`stat /etc/exports | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
					if [ $etc_exports_group_permission -eq 4 ] || [ $etc_exports_group_permission -eq 0 ]; then
						etc_exports_other_permission=`stat /etc/exports | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
						if [ $etc_exports_other_permission -eq 4 ] || [ $etc_exports_other_permission -eq 0 ]; then
							OK "※ U-69 결과 : 양호(Good)" >> $TMP1
							return 0
						else
							WARN " /etc/exports 파일의 다른 사용자(other)에 대한 권한이 취약합니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/exports 파일의 그룹 사용자(group)에 대한 권한이 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/exports 파일의 사용자(owner)에 대한 권한이 취약합니다." >> $TMP1
					return 0
				fi
			else
				WARN " /etc/exports 파일의 권한이 644보다 큽니다." >> $TMP1
				return 0
			fi
		else
			WARN " /etc/exports 파일의 소유자(owner)가 root가 아닙니다." >> $TMP1
			return 0
		fi
	else
		INFO " /etc/exports 파일이 없습니다." >> $TMP1
		return 0
	fi

cat $result

echo ; echo

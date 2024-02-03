#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-081] Crontab 설정파일 권한 설정 미흡

cat << EOF >> $TMP1
[양호]: Crontab 설정파일의 권한이 적절히 설정된 경우
[취약]: Crontab 설정파일의 권한이 적절히 설정되지 않은 경우
EOF

BAR

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

cat $TMP1

echo ; echo

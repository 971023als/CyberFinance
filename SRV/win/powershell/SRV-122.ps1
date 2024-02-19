#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-122] UMASK 설정 미흡

cat << EOF >> $result
[양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우
[취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우
EOF

BAR

umaks_value=`umask`
	if [ ${umaks_value:2:1} -lt 2 ]; then
		WARN " 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
		return 0
	elif [ ${umaks_value:3:1} -lt 2 ]; then
		WARN " 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
		return 0
	fi
	# /etc/profile 파일 내 umask 설정 확인함
	etc_profile_umask_count=`grep -vE '^#|^\s#' /etc/profile | grep -i 'umask' | grep -vE 'if|\`' | grep '=' | wc -l` # 설정 파일에 <umask=값> 형식으로 umask 값이 설정된 경우
	etc_profile_umask_count2=`grep -vE '^#|^\s#' /etc/profile | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}' | wc -l` # 설정 파일에 <umask 값> 형식으로 umask 값이 설정된 경우
	if [ -f /etc/profile ]; then
		if [ $etc_profile_umask_count -gt 0 ]; then
			umaks_value=(`grep -vE '^#|^\s#' /etc/profile | grep -i 'umask' | grep -vE 'if|\`' | awk -F = '{gsub(" ", "", $0); print $2}'`)
			for ((i=0; i<${#umaks_value[@]}; i++))
			do
				if [ ${#umaks_value[$i]} -eq 2 ]; then
					if [ ${umaks_value[$i]:0:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:1:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 4 ]; then
					if [ ${umaks_value[$i]:2:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:3:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 3 ]; then
					if [ ${umaks_value[$i]:1:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:2:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 1 ]; then
					WARN " /etc/profile 파일에 umask 값이 0022 이상으로 설정되지 않았습니다." >> $TMP1
					return 0
				else
					WARN " /etc/profile 파일에 설정된 umask 값이 보안 설정에 부합하지 않습니다." >> $TMP1
					return 0
				fi
			done
		elif [ $etc_profile_umask_count2 -gt 0 ]; then
			umaks_value=(`grep -vE '^#|^\s#' /etc/profile | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}'`)
			for ((i=0; i<${#umaks_value[@]}; i++))
			do
				if [ ${#umaks_value[$i]} -eq 2 ]; then
					if [ ${umaks_value[$i]:0:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:1:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 4 ]; then
					if [ ${umaks_value[$i]:2:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:3:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 3 ]; then
					if [ ${umaks_value[$i]:1:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					elif [ ${umaks_value[$i]:2:1} -lt 2 ]; then
						WARN " /etc/profile 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ ${#umaks_value[$i]} -eq 1 ]; then
					WARN " /etc/profile 파일에 umask 값이 0022 이상으로 설정되지 않았습니다." >> $TMP1
					return 0
				else
					WARN " /etc/profile 파일에 설정된 umask 값이 보안 설정에 부합하지 않습니다." >> $TMP1
					return 0
				fi
			done
		fi
	fi
	# /etc/bashrc, /etc/csh.login, /etc/csh.cshrc 파일 내 umask 설정 확인함
	umask_settings_files=("/etc/bashrc" "/etc/csh.login" "/etc/csh.cshrc")
	for ((i=0; i<${#umask_settings_files[@]}; i++))
	do
		if [ -f ${umask_settings_files[$i]} ]; then
			file_umask_count=`grep -vE '^#|^\s#' ${umask_settings_files[$i]} | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}' | wc -l`
			if [ $file_umask_count -gt 0 ]; then
				umaks_value=(`grep -vE '^#|^\s#' ${umask_settings_files[$i]} | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}'`)
				for ((j=0; j<${#umaks_value[@]}; j++))
				do
					if [ ${#umaks_value[$j]} -eq 2 ]; then
						if [ ${umaks_value[$j]:0:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						elif [ ${umaks_value[$j]:1:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						fi
					elif [ ${#umaks_value[$j]} -eq 4 ]; then
						if [ ${umaks_value[$j]:2:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						elif [ ${umaks_value[$j]:3:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						fi
					elif [ ${#umaks_value[$j]} -eq 3 ]; then
						if [ ${umaks_value[$j]:1:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						elif [ ${umaks_value[$j]:2:1} -lt 2 ]; then
							WARN " ${umask_settings_files[$i]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						fi
					elif [ ${#umaks_value[$j]} -eq 1 ]; then
						WARN " ${umask_settings_files[$i]} 파일에 umask 값이 0022 이상으로 설정되지 않았습니다." >> $TMP1
						return 0
					else
						WARN " ${umask_settings_files[$i]} 파일에 설정된 umask 값이 보안 설정에 부합하지 않습니다." >> $TMP1
						return 0
					fi
				done
			fi
		fi
	done
	# 사용자 홈 디렉터리 내 설정 파일에서 umask 설정 확인함
	user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd | uniq`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
	user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
	done
	umask_settings_files=(".cshrc" ".profile" ".login" ".bashrc" ".kshrc")
	for ((i=0; i<${#user_homedirectory_path[@]}; i++))
	do
		for ((j=0; j<${#umask_settings_files[@]}; j++))
		do
			if [ -f ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} ]; then
				user_homedirectory_setting_umask_count=`grep -vE '^#|^\s#' ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}' | wc -l`
				if [ $user_homedirectory_setting_umask_count -gt 0 ]; then
					umaks_value=(`grep -vE '^#|^\s#' ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} | grep -i 'umask' | grep -vE 'if|\`' | awk '{print $2}'`)
					for ((k=0; k<${#umaks_value[@]}; k++))
					do
						if [ ${#umaks_value[$k]} -eq 2 ]; then
							if [ ${umaks_value[$k]:0:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							elif [ ${umaks_value[$k]:1:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							fi
						elif [ ${#umaks_value[$k]} -eq 4 ]; then
							if [ ${umaks_value[$k]:2:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							elif [ ${umaks_value[$k]:3:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							fi
						elif [ ${#umaks_value[$k]} -eq 3 ]; then
							if [ ${umaks_value[$k]:1:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 그룹 사용자(group)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							elif [ ${umaks_value[$k]:2:1} -lt 2 ]; then
								WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 다른 사용자(other)에 대한 umask 값이 2 이상으로 설정되지 않았습니다." >> $TMP1
								return 0
							fi
						elif [ ${#umaks_value[$k]} -eq 1 ]; then
							WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 umask 값이 0022 이상으로 설정되지 않았습니다." >> $TMP1
							return 0
						else
							WARN " ${user_homedirectory_path[$i]}/${umask_settings_files[$j]} 파일에 설정된 umask 값이 보안 설정에 부합하지 않습니다." >> $TMP1
							return 0
						fi
					done
				fi
			fi
		done
	done
	OK "※ U-56 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

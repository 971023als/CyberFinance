#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-127] 계정 잠금 임계값 설정 미비

cat << EOF >> $result
[양호]: 계정 잠금 임계값이 적절하게 설정된 경우
[취약]: 계정 잠금 임계값이 적절하게 설정되지 않은 경우
EOF

BAR

file_exists_count=0
	deny_file_exists_count=0
	no_settings_in_deny_file=0
	deny_modules=("pam_tally2.so" "pam_faillock.so")
	# /etc/pam.d/system-auth, /etc/pam.d/password-auth 파일 내 계정 잠금 임계값 설정 확인함
	deny_settings_files=("/etc/pam.d/system-auth" "/etc/pam.d/password-auth")
	for ((i=0; i<${#deny_settings_files[@]}; i++))
	do
		if [ -f ${deny_settings_files[$i]} ]; then
			((file_exists_count++))
			for ((j=0; j<${#deny_modules[@]}; j++))
			do
				((deny_file_exists_count++))
				deny_settings_file_deny_count=`grep -vE '^#|^\s#' ${deny_settings_files[$i]} | grep -i ${deny_modules[$j]} | grep -i 'deny' | wc -l`
				if [ $deny_settings_file_deny_count -gt 0 ]; then
					deny_settings_file_deny_value=`grep -vE '^#|^\s#' ${deny_settings_files[$i]} | grep -i ${deny_modules[$j]} | grep -i 'deny' | awk -F 'deny' '{gsub(" ", "", $0); print substr($2,2,1)}'`
					deny_settings_file_deny_second_value=`grep -vE '^#|^\s#' ${deny_settings_files[$i]} | grep -i ${deny_modules[$j]} | grep -i 'deny' | awk -F 'deny' '{gsub(" ", "", $0); print substr($2,3,1)}'`
					deny_settings_file_deny_third_value=`grep -vE '^#|^\s#' ${deny_settings_files[$i]} | grep -i ${deny_modules[$j]} | grep -i 'deny' | awk -F 'deny' '{gsub(" ", "", $0); print substr($2,4,1)}'`
					if [ $deny_settings_file_deny_value -eq 0 ]; then
						continue
					elif [ $deny_settings_file_deny_value -eq 1 ]; then
						if [[ $deny_settings_file_deny_second_value =~ [1-9] ]]; then
							WARN " ${deny_settings_files[$i]} 파일에 계정 잠금 임계값이 11회 이상으로 설정되어 있습니다." >> $TMP1
							return 0
						else
							if [[ $deny_settings_file_deny_third_value =~ [0-9] ]]; then
								WARN " ${deny_settings_files[$i]} 파일에 계정 잠금 임계값이 11회 이상으로 설정되어 있습니다." >> $TMP1
								return 0
							fi
						fi
					else
						if [[ $deny_settings_file_deny_second_value =~ [0-9] ]]; then
							WARN " ${deny_settings_files[$i]} 파일에 계정 잠금 임계값이 11회 이상으로 설정되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				else
					((no_settings_in_deny_file++))
				fi
			done
		fi
	done
	if [ $file_exists_count -eq 0 ]; then
		WARN " 계정 잠금 임계값을 설정하는 파일이 없습니다." >> $TMP1
		return 0
	elif [ $deny_file_exists_count -eq $no_settings_in_deny_file ]; then
		WARN " 계정 잠금 임계값을 설정한 파일이 없습니다." >> $TMP1
		return 0
	fi
	OK "※ U-03 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-075] 유추 가능한 계정 비밀번호 존재

cat << EOF >> $result
[양호]: 암호 정책이 강력하게 설정되어 있는 경우
[취약]: 암호 정책이 약하게 설정되어 있는 경우
EOF

BAR

file_exists_count=0 # 패스워드 설정 파일 존재 시 카운트할 변수
	minlen_file_exists_count=0 # 패스워드 최소 길이 설정 파일 존재 시 카운트할 변수
	no_settings_in_minlen_file=0 # 설정 파일 존재하는데, 최소 길이에 대한 설정이 없을 때 카운트할 변수 -> 추후 file_exists_count 변수와 값을 비교하여 동일하면 모든 파일에 패스워드 최소 길이 설정이 없는 것이므로 취약으로 판단함
	mininput_file_exists_count=0 # 패스워드 최소 입력 설정 파일 존재 시 카운트할 변수
	no_settings_in_mininput_file=0 # 설정 파일 존재하는데, 최소 입력에 대한 설정이 없을 때 카운트할 변수 -> 추후 mininput_file_exists_count 변수와 값을 비교하여 동일하면 모든 파일에 패스워드 최소 입력 설정이 없는 것이므로 취약으로 판단함
	input_options=("lcredit" "ucredit" "dcredit" "ocredit")
	input_modules=("pam_pwquality.so" "pam_cracklib.so" "pam_unix.so")
	# /etc/login.defs 파일 내 패스워드 최소 길이 설정 확인함
	if [ -f /etc/login.defs ]; then
		((file_exists_count++))
		((minlen_file_exists_count++))
		etc_logindefs_minlen_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_LEN' | awk '{print $2}' | wc -l`
		if [ $etc_logindefs_minlen_count -gt 0 ]; then
		etc_logindefs_minlen_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_LEN' | awk '{print $2}'`
			if [ $etc_logindefs_minlen_value -lt 8 ]; then
				WARN " /etc/login.defs 파일에 최소 길이(PASS_MIN_LEN)가 8 미만으로 설정되어 있습니다." >> $TMP1
				return 0
			fi
		else
			((no_settings_in_minlen_file++))
		fi
	fi
	# /etc/pam.d/system-auth, /etc/pam.d/password-auth 파일 내 패스워드 최소 길이와 최소 입력 확인함
	pw_settings_files=("/etc/pam.d/system-auth" "/etc/pam.d/password-auth")
	for ((i=0; i<${#pw_settings_files[@]}; i++))
	do
		if [ -f ${pw_settings_files[$i]} ]; then
			((file_exists_count++))
			# 패스워드 최소 길이 체크
			for ((j=0; j<${#input_modules[@]}; j++))
			do
				((minlen_file_exists_count++))
				pw_settings_file_minlen_count=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | wc -l`
				if [ $pw_settings_file_minlen_count -gt 0 ]; then
					pw_settings_file_minlen_value=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,2,1)}'`
					if [ $pw_settings_file_minlen_value -lt 8 ]; then
						pw_settings_file_minlen_second_value=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,3,1)}'`
						if [[ $pw_settings_file_minlen_second_value != [0-9] ]]; then
							WARN " ${pw_settings_files[$i]} 파일에 최소 길이(minlen)가 8 미만으로 설정되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				else
					((no_settings_in_minlen_file++))
				fi
			done
			# 패스워드 최소 입력 체크
			for ((j=0; j<${#input_modules[@]}; j++))
			do
				for ((k=0; k<${#input_options[@]}; k++))
				do
					((mininput_file_exists_count++))
					pw_settings_file_mininput_count=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i ${input_options[$k]} | grep -i ${input_modules[$j]} | wc -l`
					if [ $pw_settings_file_mininput_count -gt 0 ]; then
						pw_settings_file_mininput_dash=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i ${input_options[$k]} | grep -i ${input_modules[$j]} | awk -F ${input_options[$k]} '{gsub(" ", "", $0); print substr($2,2,1)}'`
						if [[ $pw_settings_file_mininput_dash =~ - ]]; then
							pw_settings_file_mininput_value=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i ${input_options[$k]} | grep -i ${input_modules[$j]} | awk -F ${input_options[$k]} '{gsub(" ", "", $0); print substr($2,3,1)}'`
							if [ $pw_settings_file_mininput_value -lt 1 ]; then
								WARN " ${pw_settings_files[$i]} 파일에 영문, 숫자, 특수문자의 최소 입력이 1 미만으로 설정되어 있습니다." >> $TMP1
								return 0
							fi
						else
							WARN " /${pw_settings_files[$i]} 파일에 영문, 숫자, 특수문자의 최소 입력에 대한 설정이 없습니다." >> $TMP1
							return 0
						fi
					else
						((no_settings_in_mininput_file++))
					fi
				done
			done
		fi
	done
	# /etc/security/pwquality.conf 파일 내 패스워드 최소 길이와 최소 입력 확인함
	if [ -f /etc/security/pwquality.conf ]; then
		((file_exists_count++))
		# 패스워드 최소 길이 체크
		((minlen_file_exists_count++))
		etc_security_pwqualityconf_minlen_count=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i 'minlen' | wc -l`
		if [ $etc_security_pwqualityconf_minlen_count -gt 0 ]; then
			etc_security_pwqualityconf_minlen_value=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i 'minlen' | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,2,1)}'`
			if [ $etc_security_pwqualityconf_minlen_value -lt 8 ]; then
				etc_security_pwqualityconf_minlen_second_value=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i 'minlen' | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,3,1)}'`
				if [[ $etc_security_pwqualityconf_minlen_second_value != [0-9] ]]; then
					WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)가 8 미만으로 설정되어 있습니다." >> $TMP1
					return 0
				fi
			else
				if [ -f /etc/pam.d/system-auth ] && [ -f /etc/pam.d/password-auth ]; then
					etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
					etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_systemauth_module_count -eq 0 ] && [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ -f /etc/pam.d/system-auth ]; then
					etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_systemauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ -f /etc/pam.d/password-auth ]; then
					etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
					return 0
				fi
			fi
		else
			((no_settings_in_minlen_file++))
		fi
		# 패스워드 최소 입력 체크
		for ((i=0; i<${#input_options[@]}; i++))
		do
			((mininput_file_exists_count++))
			etc_security_pwqualityconf_mininput_count=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i ${input_options[$i]} | wc -l`
			if [ $etc_security_pwqualityconf_mininput_count -gt 0 ]; then
				etc_security_pwqualityconf_mininput_dash=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i ${input_options[$i]} | awk -F ${input_options[$i]} '{gsub(" ", "", $0); print substr($2,2,1)}'`
				if [[ $etc_security_pwqualityconf_mininput_dash =~ - ]]; then
					etc_security_pwqualityconf_mininput_value=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i ${input_options[$i]} | awk -F ${input_options[$i]} '{gsub(" ", "", $0); print substr($2,3,1)}'`
					if [ $etc_security_pwqualityconf_mininput_value -ge 1 ]; then
						if [ -f /etc/pam.d/system-auth ] && [ -f /etc/pam.d/password-auth ]; then
							etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
							etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
							if [ $etc_pamd_systemauth_module_count -eq 0 ] && [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
								WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력을 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
								return 0
							fi
						elif [ -f /etc/pam.d/system-auth ]; then
							etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
							if [ $etc_pamd_systemauth_module_count -eq 0 ]; then
								WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력을 설정하고, /etc/pam.d/system-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
								return 0
							fi
						elif [ -f /etc/pam.d/password-auth ]; then
							etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
							if [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
								WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력을 설정하고, /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
								return 0
							fi
						else
							WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력을 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
							return 0
						fi
					else
						WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력이 1 미만으로 설정되어 있습니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/security/pwquality.conf 파일에 영문, 숫자, 특수문자의 최소 입력에 대한 설정이 없습니다." >> $TMP1
					return 0
				fi
			else
				((no_settings_in_mininput_file++))
			fi
		done
	fi
	if [ $file_exists_count -eq 0 ]; then
		WARN " 패스워드의 복잡성을 설정하는 파일이 없습니다." >> $TMP1
		return 0
	elif [ $minlen_file_exists_count -eq $no_settings_in_minlen_file ]; then
		WARN " 패스워드의 최소 길이를 설정한 파일이 없습니다." >> $TMP1
		return 0
	elif [ $mininput_file_exists_count -eq $no_settings_in_mininput_file ]; then
		WARN " 패스워드의 영문, 숫자, 특수문자의 최소 입력을 설정한 파일이 없습니다." >> $TMP1
		return 0
	fi
	OK "※ U-02 결과 : 양호(Good)" >> $TMP1
	return 0


if [ `awk -F : '$2!="x"' /etc/passwd | wc -l` -gt 0 ]; then
		WARN " 쉐도우 패스워드를 사용하고 있지 않습니다." >> $TMP1
		return 0
	else
		OK "※ U-04 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

file_exists_count=0
	minlen_file_exists_count=0
	no_settings_in_minlen_file=0
	input_modules=("pam_pwquality.so" "pam_cracklib.so" "pam_unix.so")
	# /etc/login.defs 파일 내 패스워드 최소 길이 설정 확인함
	if [ -f /etc/login.defs ]; then
		((file_exists_count++))
		((minlen_file_exists_count++))
		etc_logindefs_minlen_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_LEN' | awk '{print $2}' | wc -l`
		if [ $etc_logindefs_minlen_count -gt 0 ]; then
			etc_logindefs_minlen_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_LEN' | awk '{print $2}'`
			if [ $etc_logindefs_minlen_value -lt 8 ]; then
				WARN " /etc/login.defs 파일에 패스워드 최소 길이가 8 미만으로 설정되어 있습니다." >> $TMP1
				return 0
			fi
		else
			((no_settings_in_minlen_file++))
		fi
	fi
	# /etc/pam.d/system-auth, /etc/pam.d/password-auth 파일 내 패스워드 최소 길이 설정 확인함
	minlen_settings_files=("/etc/pam.d/system-auth" "/etc/pam.d/password-auth")
	for ((i=0; i<${#minlen_settings_files[@]}; i++))
	do
		if [ -f ${minlen_settings_files[$i]} ]; then
			((file_exists_count++))
			for ((j=0; j<${#input_modules[@]}; j++))
			do
				((minlen_file_exists_count++))
				pw_settings_file_minlen_count=`grep -vE '^#|^\s#' ${minlen_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | wc -l`
				if [ $pw_settings_file_minlen_count -gt 0 ]; then
					pw_settings_file_minlen_value=`grep -vE '^#|^\s#' ${minlen_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,2,1)}'`
					if [ $pw_settings_file_minlen_value -lt 8 ]; then
						pw_settings_file_minlen_second_value=`grep -vE '^#|^\s#' ${pw_settings_files[$i]} | grep -i 'minlen' | grep -i ${input_modules[$j]} | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,3,1)}'`
						if [[ $pw_settings_file_minlen_second_value != [0-9] ]]; then
							WARN " ${minlen_settings_files[$i]} 파일에 패스워드 최소 길이가 8 미만으로 설정되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				else
					((no_settings_in_minlen_file++))
				fi
			done
		fi
	done
	# /etc/security/pwquality 파일 내 패스워드 최소 길이 확인함
	if [ -f /etc/security/pwquality.conf ]; then
		((file_exists_count++))
		((minlen_file_exists_count++))
		etc_security_pwqualityconf_minlen_count=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i 'minlen' | wc -l`
		if [ $etc_security_pwqualityconf_minlen_count -gt 0 ]; then
			etc_security_pwqualityconf_minlen_value=`grep -vE '^#|^\s#' /etc/security/pwquality.conf | grep -i 'minlen' | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,2,1)}'`
			if [ $etc_security_pwqualityconf_minlen_value -lt 8 ]; then
				etc_security_pwqualityconf_minlen_second_value=`grep -vE '^#|^\s#' /etc/security/pwquality.conf  | grep -i 'minlen' | awk -F 'minlen' '{gsub(" ", "", $0); print substr($2,3,1)}'`
				if [[ $etc_security_pwqualityconf_minlen_second_value != [0-9] ]]; then
					WARN " /etc/security/pwquality.defs 파일에서 패스워드 최소 길이가 8 미만으로 설정되어 있습니다." >> $TMP1
					return 0
				fi
			else
				if [ -f /etc/pam.d/system-auth ] && [ -f /etc/pam.d/password-auth ]; then
					etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
					etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_systemauth_module_count -eq 0 ] && [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ -f /etc/pam.d/system-auth ]; then
					etc_pamd_systemauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/system-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_systemauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				elif [ -f /etc/pam.d/password-auth ]; then
					etc_pamd_passwordauth_module_count=`grep -vE '^#|^\s#' /etc/pam.d/password-auth | grep -i 'pam_pwquality.so' | wc -l`
					if [ $etc_pamd_passwordauth_module_count -eq 0 ]; then
						WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
						return 0
					fi
				else
					WARN " /etc/security/pwquality.conf 파일에 최소 길이(minlen)를 8 이상으로 설정하고, /etc/pam.d/system-auth 또는 /etc/pam.d/password-auth 파일에 pam_pwquality.so 모듈을 추가하지 않았습니다." >> $TMP1
					return 0
				fi
			fi
		else
			((no_settings_in_minlen_file++))
		fi
	fi
	if [ $file_exists_count -eq 0 ]; then
		WARN " 패스워드 최소 길이를 설정하는 파일이 없습니다." >> $TMP1
		return 0
	elif [ $minlen_file_exists_count -eq $no_settings_in_minlen_file ]; then
		WARN " 패스워드 최소 길이를 설정한 파일이 없습니다." >> $TMP1
		return 0
	else
		WARN "※ U-46 결과 : 양호(Good)" >> $TMP1
		return 0
	fi

if [ -f /etc/login.defs ]; then
		etc_logindefs_maxdays_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MAX_DAYS' | awk '{print $2}' | wc -l`
		if [ $etc_logindefs_maxdays_count -gt 0 ]; then
			etc_logindefs_maxdays_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MAX_DAYS' | awk '{print $2}'`
			if [ $etc_logindefs_maxdays_value -gt 90 ]; then
				WARN " /etc/login.defs 파일에 패스워드 최대 사용 기간이 91일 이상으로 설정되어 있습니다." >> $TMP1
				return 0
			else
				OK "※ U-47 결과 : 양호(Good)" >> $TMP1
				return 0
			fi
		else
			WARN " /etc/login.defs 파일에 패스워드 최대 사용 기간이 설정되어 있지 않습니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/login.defs 파일이 없습니다." >> $TMP1
		return 0
	fi
if [ -f /etc/login.defs ]; then
		etc_logindefs_mindays_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_DAYS' | awk '{print $2}' | wc -l`
		if [ $etc_logindefs_mindays_count -gt 0 ]; then
			etc_logindefs_mindays_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_DAYS' | awk '{print $2}'`
			if [ $etc_logindefs_mindays_value -lt 1 ]; then
				WARN " /etc/login.defs 파일에 패스워드 최소 사용 기간이 1일 미만으로 설정되어 있습니다." >> $TMP1
				return 0
			else
				OK "※ U-48 결과 : 양호(Good)" >> $TMP1
				return 0
			fi
		else
			WARN " /etc/login.defs 파일에 패스워드 최소 사용 기간이 설정되어 있지 않습니다." >> $TMP1
			return 0
		fi
	else
		WARN " /etc/login.defs 파일이 없습니다." >> $TMP1
		return 0
	fi

cat $result

echo ; echo

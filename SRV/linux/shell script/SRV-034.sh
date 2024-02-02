#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-034] 불필요한 서비스 활성화

cat << EOF >> $result
[양호]: 불필요한 서비스가 비활성화된 경우
[취약]: 불필요한 서비스가 활성화된 경우
EOF

BAR

r_command=("rsh" "rlogin" "rexec" "shell" "login" "exec")
	if [ -d /etc/xinetd.d ]; then
		for ((i=0; i<${#r_command[@]}; i++))
		do
			if [ -f /etc/xinetd.d/${r_command[$i]} ]; then
				etc_xinetdd_rcommand_disable_count=`grep -vE '^#|^\s#' /etc/xinetd.d/${r_command[$i]} | grep -i 'disable' | grep -i 'yes' | wc -l`
				if [ $etc_xinetdd_rcommand_disable_count -eq 0 ]; then
					WARN " 불필요한 ${r_command[$i]} 서비스가 실행 중입니다." >> $TMP1
					return 0
				fi
			fi
		done
	fi
	if [ -f /etc/inetd.conf ]; then
		for ((i=0; i<${#r_command[@]}; i++))
		do
			etc_inetdconf_enable_count=`grep -vE '^#|^\s#' /etc/inetd.conf | grep ${r_command[$i]} | wc -l`
			if [ $etc_inetdconf_enable_count -gt 0 ]; then
				WARN " 불필요한 ${r_command[$i]} 서비스가 실행 중입니다." >> $TMP1
				return 0
			fi
		done
	fi
	OK "※ U-21 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

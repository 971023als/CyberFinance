#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비

cat << EOF >> $result
[양호]: SU 명령을 특정 그룹에만 허용한 경우
[취약]: SU 명령을 모든 사용자가 사용할 수 있는 경우
EOF

BAR

rpm_libpam_count=`rpm -qa 2>/dev/null | grep '^libpam' | wc -l`
	dnf_libpam_count=`dnf list installed 2>/dev/null | grep -i '^libpam' | wc -l`
	if [ $rpm_libpam_count -gt 0 ] && [ $dnf_libpam_count -gt 0 ]; then
		# !!! pam_rootok.so 설정을 하지 않은 경우 하단의 첫 번째 if 문을 삭제하세요.
		etc_pamd_su_rootokso_count=`grep -vE '^#|^\s#' /etc/pam.d/su | grep 'pam_rootok.so' | wc -l`
		if [ $etc_pamd_su_rootokso_count -gt 0 ]; then
			# !!! pam_wheel.so 설정에 trust 문구를 추가한 경우 하단의 if 문 조건절에 'grep 'trust'를 추가하세요.
			etc_pamd_su_wheelso_count=`grep -vE '^#|^\s#' /etc/pam.d/su | grep 'pam_wheel.so' | wc -l`
			if [ $etc_pamd_su_wheelso_count -eq 0 ]; then
				WARN " /etc/pam.d/su 파일에 pam_wheel.so 모듈이 없습니다." >> $TMP1
				return 0
			fi
		else
			WARN " /etc/pam.d/su 파일에서 pam_rootok.so 모듈이 없습니다." >> $TMP1
			return 0
		fi
	else
		su_executables=("/bin/su" "/usr/bin/su")
		if [ `which su 2>/dev/null | wc -l` -gt 0 ]; then
			su_executables[${#su_executables[@]}]=`which su 2>/dev/null`
		fi
		for ((i=0; i<${#su_executables[@]}; i++))
		do
			if [ -f ${su_executables[$i]} ]; then
				su_group_permission=`stat ${su_executables[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,4,1)}'`
				if [ $su_group_permission -eq 5 ] || [ $su_group_permission -eq 4 ] || [ $su_group_permission -eq 1 ] || [ $su_group_permission -eq 0 ]; then
					su_other_permission=`stat ${su_executables[$i]} | grep -i 'Uid' | awk '{print $2}' | awk -F / '{print substr($1,5,1)}'`
					if [ $su_other_permission -ne 0 ]; then
						WARN " ${su_executables[$i]} 실행 파일의 다른 사용자(other)에 대한 권한 취약합니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${su_executables[$i]} 실행 파일의 그룹 사용자(group)에 대한 권한 취약합니다." >> $TMP1
					return 0
				fi
			fi
		done
	fi
	OK "※ U-45 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo

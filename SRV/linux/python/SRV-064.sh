#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-064] 취약한 버전의 DNS 서비스 사용

cat << EOF >> $TMP1
[양호]: DNS 서비스가 최신 버전으로 업데이트되어 있는 경우
[취약]: DNS 서비스가 최신 버전으로 업데이트되어 있지 않은 경우
EOF

BAR

ps_dns_count=`ps -ef | grep -i 'named' | grep -v 'grep' | wc -l`
	if [ $ps_dns_count -gt 0 ]; then
		rpm_bind9_minor_version=(`rpm -qa 2>/dev/null | grep '^bind' | awk -F '9.' '{print $2}' | grep -v '^$' | uniq`)
		dnf_bind_major_minor_version=(`dnf list installed bind* 2>/dev/null | grep -v 'Installed Packages' | awk -F : '{print $2}' | grep -v '^$' | uniq`)
		if [ ${#rpm_bind9_minor_version[@]} -gt 0 ] && [ ${#dnf_bind_major_minor_version[@]} -gt 0 ]; then
			for ((i=0; i<${#rpm_bind9_minor_version[@]}; i++))
			do
				if [[ ${rpm_bind9_minor_version[$i]} =~ 18.* ]]; then
					rpm_bind9_patch_version=(`rpm -qa 2>/dev/null | grep '^bind' | awk -F '18.' '{print $2}' | grep -v '^$' | uniq`)
					if [ ${#rpm_bind9_patch_version[@]} -gt 0 ]; then
						for ((j=0; j<${#rpm_bind9_patch_version[@]}; j++))
						do
							if [[ ${rpm_bind9_patch_version[$j]} != [7-9]* ]] || [[ ${rpm_bind9_patch_version[$j]} != 1[0-6]* ]]; then
								WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
								return 0
							fi
						done
					else
						WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
						return 0
					fi
				else
					WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
					return 0
				fi
			done
			for ((i=0; i<${#dnf_bind_major_minor_version[@]}; i++))
			do
				if [[ ${dnf_bind_major_minor_version[$i]} =~ 9.18.* ]]; then
					dnf_bind_patch_version=(`dnf list installed bind* 2>/dev/null | grep -v 'Installed Packages' | awk -F : '{print $2}' | awk -F '18.' '{print $2}' | grep -v '^$' | uniq`)
					if [ ${#dnf_bind_patch_version[@]} -gt 0 ]; then
						for ((j=0; j<${#dnf_bind_patch_version[@]}; j++))
						do
							if [[ ${dnf_bind_patch_version[$j]} != [7-9]* ]] || [[ ${dnf_bind_patch_version[$j]} != 1[0-6]* ]]; then
								WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
								return 0
							fi
						done
					else
						WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
						return 0
					fi
				else
					WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
					return 0
				fi
			done
		else
			WARN " BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다." >> $TMP1
			return 0
		fi		
	fi
	OK "※ U-33 결과 : 양호(Good)" >> $TMP1
	return 0 "DNS 서버가 최신 버전이 아닐 수 있습니다: $dns_version"
fi

cat $TMP1

echo ; echo
